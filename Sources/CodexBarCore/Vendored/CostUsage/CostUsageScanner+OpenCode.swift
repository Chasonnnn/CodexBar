import Foundation
#if canImport(SQLite3)
import SQLite3
#endif

extension CostUsageScanner {
    private static let opencodeCostScale: Double = 1_000_000_000

    private static func defaultOpenCodeDatabaseURL(options: Options) -> URL {
        if let override = options.opencodeDatabaseURL {
            return override
        }
        if let envPath = ProcessInfo.processInfo.environment["CODEXBAR_OPENCODE_DB_PATH"]?
            .trimmingCharacters(in: .whitespacesAndNewlines),
            !envPath.isEmpty
        {
            return URL(fileURLWithPath: envPath)
        }
        return FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".local/share/opencode/opencode.db", isDirectory: false)
    }

    static func loadOpenCodeDaily(range: CostUsageDayRange, now: Date, options: Options) -> CostUsageDailyReport {
        var cache = CostUsageCacheIO.load(provider: .opencode, cacheRoot: options.cacheRoot)
        let nowMs = Int64(now.timeIntervalSince1970 * 1000)
        let refreshMs = Int64(max(0, options.refreshMinIntervalSeconds) * 1000)
        let shouldRefresh = refreshMs == 0 || cache.lastScanUnixMs == 0 || nowMs - cache.lastScanUnixMs > refreshMs
        let dbURL = self.defaultOpenCodeDatabaseURL(options: options)

        if shouldRefresh {
            if options.forceRescan {
                cache = CostUsageCache()
            }

            var days: [String: [String: [Int]]] = [:]
            if FileManager.default.fileExists(atPath: dbURL.path) {
                #if canImport(SQLite3)
                days = (try? self.scanOpenCodeDatabase(dbURL: dbURL, range: range)) ?? [:]
                #endif
            }
            cache.days = days
            cache.files.removeAll()
            Self.pruneDays(cache: &cache, sinceKey: range.scanSinceKey, untilKey: range.scanUntilKey)
            cache.lastScanUnixMs = nowMs
            CostUsageCacheIO.save(provider: .opencode, cache: cache, cacheRoot: options.cacheRoot)
        }

        return self.buildOpenCodeReportFromCache(cache: cache, range: range)
    }

    private static func buildOpenCodeReportFromCache(
        cache: CostUsageCache,
        range: CostUsageDayRange) -> CostUsageDailyReport
    {
        var entries: [CostUsageDailyReport.Entry] = []
        var totalInput = 0
        var totalOutput = 0
        var totalCacheRead = 0
        var totalCacheCreation = 0
        var totalTokens = 0
        var totalCost: Double = 0
        var costSeen = false

        let dayKeys = cache.days.keys.sorted().filter {
            CostUsageDayRange.isInRange(dayKey: $0, since: range.sinceKey, until: range.untilKey)
        }

        for day in dayKeys {
            guard let models = cache.days[day] else { continue }
            let modelNames = models.keys.sorted()

            var dayInput = 0
            var dayOutput = 0
            var dayCacheRead = 0
            var dayCacheCreation = 0
            var dayCost: Double = 0
            var dayCostSeen = false
            var breakdown: [CostUsageDailyReport.ModelBreakdown] = []

            for model in modelNames {
                let packed = models[model] ?? []
                let input = packed[safe: 0] ?? 0
                let cacheRead = packed[safe: 1] ?? 0
                let cacheCreation = packed[safe: 2] ?? 0
                let output = packed[safe: 3] ?? 0
                let costNanos = packed[safe: 4] ?? 0
                let costKnown = (packed[safe: 5] ?? 0) > 0
                let nativeCount = packed[safe: 6] ?? 0
                let fallbackCount = packed[safe: 7] ?? 0
                let modelCost = costKnown ? Double(costNanos) / self.opencodeCostScale : nil
                let costSource: CostUsageDailyReport.ModelBreakdown.CostSource? = if nativeCount > 0, fallbackCount > 0 {
                    .mixed
                } else if nativeCount > 0 {
                    .native
                } else if fallbackCount > 0 {
                    .fallback
                } else {
                    nil
                }

                dayInput += input
                dayCacheRead += cacheRead
                dayCacheCreation += cacheCreation
                dayOutput += output
                if let modelCost {
                    dayCost += modelCost
                    dayCostSeen = true
                }
                breakdown.append(CostUsageDailyReport.ModelBreakdown(
                    modelName: model,
                    costUSD: modelCost,
                    costSource: costSource))
            }

            breakdown.sort { lhs, rhs in (rhs.costUSD ?? -1) < (lhs.costUSD ?? -1) }
            let top = Array(breakdown.prefix(3))
            let dayTotal = dayInput + dayCacheRead + dayCacheCreation + dayOutput
            let entryCost = dayCostSeen ? dayCost : nil

            entries.append(CostUsageDailyReport.Entry(
                date: day,
                inputTokens: dayInput,
                outputTokens: dayOutput,
                cacheReadTokens: dayCacheRead,
                cacheCreationTokens: dayCacheCreation,
                totalTokens: dayTotal,
                costUSD: entryCost,
                modelsUsed: modelNames,
                modelBreakdowns: top))

            totalInput += dayInput
            totalOutput += dayOutput
            totalCacheRead += dayCacheRead
            totalCacheCreation += dayCacheCreation
            totalTokens += dayTotal
            if let entryCost {
                totalCost += entryCost
                costSeen = true
            }
        }

        let summary: CostUsageDailyReport.Summary? = entries.isEmpty
            ? nil
            : CostUsageDailyReport.Summary(
                totalInputTokens: totalInput,
                totalOutputTokens: totalOutput,
                cacheReadTokens: totalCacheRead,
                cacheCreationTokens: totalCacheCreation,
                totalTokens: totalTokens,
                totalCostUSD: costSeen ? totalCost : nil)

        return CostUsageDailyReport(data: entries, summary: summary)
    }
}

#if canImport(SQLite3)
extension CostUsageScanner {
    private enum OpenCodeDBError: Error {
        case openFailed(String)
        case queryPrepareFailed(String)
        case queryStepFailed(String)
    }

    private static func scanOpenCodeDatabase(
        dbURL: URL,
        range: CostUsageDayRange) throws -> [String: [String: [Int]]]
    {
        var db: OpaquePointer?
        guard sqlite3_open_v2(dbURL.path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            throw OpenCodeDBError.openFailed(self.sqliteErrorMessage(db: db))
        }
        defer { sqlite3_close(db) }

        sqlite3_busy_timeout(db, 250)

        let sql = """
        SELECT
          p.time_created,
          COALESCE(json_extract(m.data, '$.modelID'), ''),
          COALESCE(json_extract(p.data, '$.tokens.input'), 0),
          COALESCE(json_extract(p.data, '$.tokens.output'), 0),
          COALESCE(json_extract(p.data, '$.tokens.cache.read'), 0),
          COALESCE(json_extract(p.data, '$.tokens.cache.write'), 0),
          COALESCE(json_extract(p.data, '$.cost'), 0)
        FROM part p
        JOIN message m
          ON m.id = p.message_id
         AND m.session_id = p.session_id
        WHERE json_extract(p.data, '$.type') = 'step-finish'
        """

        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            throw OpenCodeDBError.queryPrepareFailed(self.sqliteErrorMessage(db: db))
        }
        defer { sqlite3_finalize(stmt) }

        var days: [String: [String: [Int]]] = [:]

        while true {
            let step = sqlite3_step(stmt)
            if step == SQLITE_DONE {
                break
            }
            guard step == SQLITE_ROW else {
                throw OpenCodeDBError.queryStepFailed(self.sqliteErrorMessage(db: db))
            }

            let timestampRaw = sqlite3_column_int64(stmt, 0)
            let modelRaw = self.sqliteText(stmt: stmt, column: 1) ?? ""
            if modelRaw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                continue
            }

            let input = max(0, Int(sqlite3_column_int64(stmt, 2)))
            let output = max(0, Int(sqlite3_column_int64(stmt, 3)))
            let cacheRead = max(0, Int(sqlite3_column_int64(stmt, 4)))
            let cacheCreation = max(0, Int(sqlite3_column_int64(stmt, 5)))
            if input == 0, output == 0, cacheRead == 0, cacheCreation == 0 {
                continue
            }

            let timestampMs = timestampRaw > 3_000_000_000 ? timestampRaw : timestampRaw * 1_000
            let timestampDate = Date(timeIntervalSince1970: TimeInterval(timestampMs) / 1_000)
            let dayKey = CostUsageDayRange.dayKey(from: timestampDate)
            guard CostUsageDayRange.isInRange(dayKey: dayKey, since: range.scanSinceKey, until: range.scanUntilKey)
            else {
                continue
            }

            let normalizedModel = CostUsagePricing.normalizeOpenCodeModel(modelRaw)
            let nativeCost = sqlite3_column_double(stmt, 6)
            let computedCost = nativeCost > 0
                ? nativeCost
                : CostUsagePricing.openCodeCostUSD(
                    model: modelRaw,
                    inputTokens: input,
                    cacheReadInputTokens: cacheRead,
                    cacheCreationInputTokens: cacheCreation,
                    outputTokens: output)

            let costKnown = computedCost != nil ? 1 : 0
            let costNanos = computedCost.map { Int(($0 * self.opencodeCostScale).rounded()) } ?? 0
            let nativeSource = nativeCost > 0 ? 1 : 0
            let fallbackSource = nativeCost <= 0 && computedCost != nil ? 1 : 0

            var dayModels = days[dayKey] ?? [:]
            var packed = dayModels[normalizedModel] ?? [0, 0, 0, 0, 0, 0, 0, 0]
            packed[0] = (packed[safe: 0] ?? 0) + input
            packed[1] = (packed[safe: 1] ?? 0) + cacheRead
            packed[2] = (packed[safe: 2] ?? 0) + cacheCreation
            packed[3] = (packed[safe: 3] ?? 0) + output
            packed[4] = (packed[safe: 4] ?? 0) + costNanos
            packed[5] = (packed[safe: 5] ?? 0) + costKnown
            packed[6] = (packed[safe: 6] ?? 0) + nativeSource
            packed[7] = (packed[safe: 7] ?? 0) + fallbackSource
            dayModels[normalizedModel] = packed
            days[dayKey] = dayModels
        }

        return days
    }

    private static func sqliteText(stmt: OpaquePointer?, column: Int32) -> String? {
        guard let text = sqlite3_column_text(stmt, column) else { return nil }
        return String(cString: text)
    }

    private static func sqliteErrorMessage(db: OpaquePointer?) -> String {
        guard let db else { return "unknown sqlite error" }
        guard let message = sqlite3_errmsg(db) else { return "unknown sqlite error" }
        return String(cString: message)
    }
}
#endif

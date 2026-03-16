import Foundation
import Testing
@testable import CodexBarCore
#if canImport(SQLite3)
import SQLite3

@Suite
struct OpenCodeCostScannerTests {
    @Test
    func openCodeDailyReportParsesSqliteUsage() throws {
        let env = try OpenCodeCostTestEnvironment()
        defer { env.cleanup() }

        let day = try env.makeLocalNoon(year: 2026, month: 3, day: 3)
        let timestampMs = Int64(day.timeIntervalSince1970 * 1000)

        try env.insertRow(OpenCodeCostTestEnvironment.Row(
            sessionID: "ses_1",
            messageID: "msg_1",
            modelID: "anthropic.claude-4.6-opus-thinking",
            providerID: "cornell",
            timestampMs: timestampMs,
            inputTokens: 1000,
            outputTokens: 100,
            cacheReadTokens: 200,
            cacheWriteTokens: 50,
            costUSD: 0))

        try env.insertRow(OpenCodeCostTestEnvironment.Row(
            sessionID: "ses_1",
            messageID: "msg_2",
            modelID: "openai.gpt-5.3-codex-xhigh",
            providerID: "cornell-openai",
            timestampMs: timestampMs + 1,
            inputTokens: 400,
            outputTokens: 40,
            cacheReadTokens: 100,
            cacheWriteTokens: 0,
            costUSD: 0))

        var options = CostUsageScanner.Options(
            codexSessionsRoot: nil,
            claudeProjectsRoots: nil,
            opencodeDatabaseURL: env.dbURL,
            cacheRoot: env.cacheRoot)
        options.refreshMinIntervalSeconds = 0

        let report = CostUsageScanner.loadDailyReport(
            provider: .opencode,
            since: day,
            until: day,
            now: day,
            options: options)

        #expect(report.data.count == 1)
        #expect(report.data[0].modelsUsed?.contains("claude-opus-4-6") == true)
        #expect(report.data[0].modelsUsed?.contains("gpt-5.3") == true)
        #expect(report.data[0].inputTokens == 1400)
        #expect(report.data[0].cacheReadTokens == 300)
        #expect(report.data[0].cacheCreationTokens == 50)
        #expect(report.data[0].outputTokens == 140)
        #expect(report.data[0].totalTokens == 1890)
        #expect((report.data[0].costUSD ?? 0) > 0)
        #expect((report.summary?.totalCostUSD ?? 0) > 0)

        let sources = Dictionary(
            (report.data[0].modelBreakdowns ?? []).map { ($0.modelName, $0.costSource) },
            uniquingKeysWith: { lhs, _ in lhs })
        #expect(sources["claude-opus-4-6"] == .fallback)
        #expect(sources["gpt-5.3"] == .fallback)
    }

    @Test
    func openCodeDailyReportPrefersNativeCostField() throws {
        let env = try OpenCodeCostTestEnvironment()
        defer { env.cleanup() }

        let day = try env.makeLocalNoon(year: 2026, month: 3, day: 3)
        let timestampMs = Int64(day.timeIntervalSince1970 * 1000)

        try env.insertRow(OpenCodeCostTestEnvironment.Row(
            sessionID: "ses_native",
            messageID: "msg_native",
            modelID: "custom.model.without.pricing",
            providerID: "cornell",
            timestampMs: timestampMs,
            inputTokens: 200,
            outputTokens: 10,
            cacheReadTokens: 0,
            cacheWriteTokens: 0,
            costUSD: 0.5))

        var options = CostUsageScanner.Options(
            codexSessionsRoot: nil,
            claudeProjectsRoots: nil,
            opencodeDatabaseURL: env.dbURL,
            cacheRoot: env.cacheRoot)
        options.refreshMinIntervalSeconds = 0

        let report = CostUsageScanner.loadDailyReport(
            provider: .opencode,
            since: day,
            until: day,
            now: day,
            options: options)

        #expect(report.data.count == 1)
        #expect(report.data[0].modelsUsed == ["custom.model.without.pricing"])
        #expect(report.data[0].costUSD == 0.5)
        #expect(report.summary?.totalCostUSD == 0.5)
        #expect(report.data[0].modelBreakdowns?.first?.costSource == .native)
    }

    @Test
    func openCodeDailyReportMarksMixedCostSource() throws {
        let env = try OpenCodeCostTestEnvironment()
        defer { env.cleanup() }

        let day = try env.makeLocalNoon(year: 2026, month: 3, day: 3)
        let timestampMs = Int64(day.timeIntervalSince1970 * 1000)

        try env.insertRow(OpenCodeCostTestEnvironment.Row(
            sessionID: "ses_mixed",
            messageID: "msg_mixed_1",
            modelID: "openai.gpt-5.2",
            providerID: "cornell-openai",
            timestampMs: timestampMs,
            inputTokens: 100,
            outputTokens: 20,
            cacheReadTokens: 10,
            cacheWriteTokens: 0,
            costUSD: 0))

        try env.insertRow(OpenCodeCostTestEnvironment.Row(
            sessionID: "ses_mixed",
            messageID: "msg_mixed_2",
            modelID: "openai.gpt-5.2",
            providerID: "cornell-openai",
            timestampMs: timestampMs + 1,
            inputTokens: 100,
            outputTokens: 20,
            cacheReadTokens: 10,
            cacheWriteTokens: 0,
            costUSD: 0.2))

        var options = CostUsageScanner.Options(
            codexSessionsRoot: nil,
            claudeProjectsRoots: nil,
            opencodeDatabaseURL: env.dbURL,
            cacheRoot: env.cacheRoot)
        options.refreshMinIntervalSeconds = 0

        let report = CostUsageScanner.loadDailyReport(
            provider: .opencode,
            since: day,
            until: day,
            now: day,
            options: options)

        #expect(report.data.count == 1)
        #expect(report.data[0].modelsUsed == ["gpt-5.2"])
        #expect(report.data[0].modelBreakdowns?.first?.costSource == .mixed)
    }
}

private struct OpenCodeCostTestEnvironment {
    struct Row {
        let sessionID: String
        let messageID: String
        let modelID: String
        let providerID: String
        let timestampMs: Int64
        let inputTokens: Int
        let outputTokens: Int
        let cacheReadTokens: Int
        let cacheWriteTokens: Int
        let costUSD: Double
    }

    let root: URL
    let cacheRoot: URL
    let dbURL: URL

    init() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(
            "codexbar-opencode-cost-\(UUID().uuidString)",
            isDirectory: true)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        self.root = root
        self.cacheRoot = root.appendingPathComponent("cache", isDirectory: true)
        self.dbURL = root.appendingPathComponent("opencode.db", isDirectory: false)
        try FileManager.default.createDirectory(at: self.cacheRoot, withIntermediateDirectories: true)
        try self.createSchema()
    }

    func cleanup() {
        try? FileManager.default.removeItem(at: self.root)
    }

    func makeLocalNoon(year: Int, month: Int, day: Int) throws -> Date {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.timeZone = TimeZone.current
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        guard let date = components.date else {
            throw NSError(domain: "OpenCodeCostTestEnvironment", code: 1)
        }
        return date
    }

    func insertRow(_ row: Row) throws {
        var db: OpaquePointer?
        guard sqlite3_open_v2(self.dbURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK else {
            throw self.sqliteError(db: db, domain: "insertRow")
        }
        defer { sqlite3_close(db) }

        let messageJSON = try self.jsonString([
            "role": "assistant",
            "modelID": row.modelID,
            "providerID": row.providerID,
        ])
        let partJSON = try self.jsonString([
            "type": "step-finish",
            "tokens": [
                "input": row.inputTokens,
                "output": row.outputTokens,
                "cache": [
                    "read": row.cacheReadTokens,
                    "write": row.cacheWriteTokens,
                ],
            ],
            "cost": row.costUSD,
        ])

        try self.exec(
            db: db,
            sql: """
            INSERT INTO message (id, session_id, time_created, time_updated, data)
            VALUES (?, ?, ?, ?, ?)
            """,
            bindings: [
                .text(row.messageID),
                .text(row.sessionID),
                .int64(row.timestampMs),
                .int64(row.timestampMs),
                .text(messageJSON),
            ])

        try self.exec(
            db: db,
            sql: """
            INSERT INTO part (id, message_id, session_id, time_created, time_updated, data)
            VALUES (?, ?, ?, ?, ?, ?)
            """,
            bindings: [
                .text("prt_\(row.messageID)"),
                .text(row.messageID),
                .text(row.sessionID),
                .int64(row.timestampMs),
                .int64(row.timestampMs),
                .text(partJSON),
            ])
    }

    private func createSchema() throws {
        var db: OpaquePointer?
        guard sqlite3_open_v2(self.dbURL.path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else {
            throw self.sqliteError(db: db, domain: "createSchema")
        }
        defer { sqlite3_close(db) }

        try self.execRaw(db: db, sql: """
        CREATE TABLE message (
          id TEXT PRIMARY KEY,
          session_id TEXT NOT NULL,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL,
          data TEXT NOT NULL
        );
        """)

        try self.execRaw(db: db, sql: """
        CREATE TABLE part (
          id TEXT PRIMARY KEY,
          message_id TEXT NOT NULL,
          session_id TEXT NOT NULL,
          time_created INTEGER NOT NULL,
          time_updated INTEGER NOT NULL,
          data TEXT NOT NULL
        );
        """)
    }

    private enum SQLiteBinding {
        case text(String)
        case int64(Int64)
    }

    private func exec(db: OpaquePointer?, sql: String, bindings: [SQLiteBinding]) throws {
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            throw self.sqliteError(db: db, domain: "prepare")
        }
        defer { sqlite3_finalize(stmt) }

        for (index, binding) in bindings.enumerated() {
            let position = Int32(index + 1)
            switch binding {
            case let .text(value):
                let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
                _ = value.withCString { ptr in
                    sqlite3_bind_text(stmt, position, ptr, -1, transient)
                }
            case let .int64(value):
                sqlite3_bind_int64(stmt, position, value)
            }
        }

        guard sqlite3_step(stmt) == SQLITE_DONE else {
            throw self.sqliteError(db: db, domain: "step")
        }
    }

    private func execRaw(db: OpaquePointer?, sql: String) throws {
        guard sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK else {
            throw self.sqliteError(db: db, domain: "execRaw")
        }
    }

    private func jsonString(_ object: [String: Any]) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: object)
        guard let value = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "OpenCodeCostTestEnvironment", code: 2)
        }
        return value
    }

    private func sqliteError(db: OpaquePointer?, domain: String) -> NSError {
        let message = if let db, let cString = sqlite3_errmsg(db) {
            String(cString: cString)
        } else {
            "sqlite error"
        }
        return NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
#endif

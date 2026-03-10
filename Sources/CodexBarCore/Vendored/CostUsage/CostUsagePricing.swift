import Foundation

enum CostUsagePricing {
    struct CodexPricing: Sendable {
        let inputCostPerToken: Double
        let outputCostPerToken: Double
        let cacheReadInputCostPerToken: Double
    }

    struct ClaudePricing: Sendable {
        let inputCostPerToken: Double
        let outputCostPerToken: Double
        let cacheCreationInputCostPerToken: Double
        let cacheReadInputCostPerToken: Double

        let thresholdTokens: Int?
        let inputCostPerTokenAboveThreshold: Double?
        let outputCostPerTokenAboveThreshold: Double?
        let cacheCreationInputCostPerTokenAboveThreshold: Double?
        let cacheReadInputCostPerTokenAboveThreshold: Double?
    }

    struct GeminiPricing: Sendable {
        let inputCostPerToken: Double
        let outputCostPerToken: Double
        let cacheReadInputCostPerToken: Double

        let thresholdTokens: Int?
        let inputCostPerTokenAboveThreshold: Double?
        let outputCostPerTokenAboveThreshold: Double?
        let cacheReadInputCostPerTokenAboveThreshold: Double?
    }

    private static let codex: [String: CodexPricing] = [
        "gpt-5": CodexPricing(
            inputCostPerToken: 1.25e-6,
            outputCostPerToken: 1e-5,
            cacheReadInputCostPerToken: 1.25e-7),
        "gpt-5-codex": CodexPricing(
            inputCostPerToken: 1.25e-6,
            outputCostPerToken: 1e-5,
            cacheReadInputCostPerToken: 1.25e-7),
        "gpt-5.1": CodexPricing(
            inputCostPerToken: 1.25e-6,
            outputCostPerToken: 1e-5,
            cacheReadInputCostPerToken: 1.25e-7),
        "gpt-5.2": CodexPricing(
            inputCostPerToken: 1.75e-6,
            outputCostPerToken: 1.4e-5,
            cacheReadInputCostPerToken: 1.75e-7),
        "gpt-5.2-codex": CodexPricing(
            inputCostPerToken: 1.75e-6,
            outputCostPerToken: 1.4e-5,
            cacheReadInputCostPerToken: 1.75e-7),
        "gpt-5.3": CodexPricing(
            inputCostPerToken: 1.75e-6,
            outputCostPerToken: 1.4e-5,
            cacheReadInputCostPerToken: 1.75e-7),
        "gpt-5.3-codex": CodexPricing(
            inputCostPerToken: 1.75e-6,
            outputCostPerToken: 1.4e-5,
            cacheReadInputCostPerToken: 1.75e-7),
        "gpt-5.4": CodexPricing(
            inputCostPerToken: 1.75e-6,
            outputCostPerToken: 1.4e-5,
            cacheReadInputCostPerToken: 1.75e-7),
        "gpt-5.4-codex": CodexPricing(
            inputCostPerToken: 1.75e-6,
            outputCostPerToken: 1.4e-5,
            cacheReadInputCostPerToken: 1.75e-7),
    ]

    private static let claude: [String: ClaudePricing] = [
        "claude-haiku-4-5-20251001": ClaudePricing(
            inputCostPerToken: 1e-6,
            outputCostPerToken: 5e-6,
            cacheCreationInputCostPerToken: 1.25e-6,
            cacheReadInputCostPerToken: 1e-7,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-haiku-4-5": ClaudePricing(
            inputCostPerToken: 1e-6,
            outputCostPerToken: 5e-6,
            cacheCreationInputCostPerToken: 1.25e-6,
            cacheReadInputCostPerToken: 1e-7,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-opus-4-5-20251101": ClaudePricing(
            inputCostPerToken: 5e-6,
            outputCostPerToken: 2.5e-5,
            cacheCreationInputCostPerToken: 6.25e-6,
            cacheReadInputCostPerToken: 5e-7,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-opus-4-5": ClaudePricing(
            inputCostPerToken: 5e-6,
            outputCostPerToken: 2.5e-5,
            cacheCreationInputCostPerToken: 6.25e-6,
            cacheReadInputCostPerToken: 5e-7,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-opus-4-6-20260205": ClaudePricing(
            inputCostPerToken: 5e-6,
            outputCostPerToken: 2.5e-5,
            cacheCreationInputCostPerToken: 6.25e-6,
            cacheReadInputCostPerToken: 5e-7,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-opus-4-6": ClaudePricing(
            inputCostPerToken: 5e-6,
            outputCostPerToken: 2.5e-5,
            cacheCreationInputCostPerToken: 6.25e-6,
            cacheReadInputCostPerToken: 5e-7,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-sonnet-4-5": ClaudePricing(
            inputCostPerToken: 3e-6,
            outputCostPerToken: 1.5e-5,
            cacheCreationInputCostPerToken: 3.75e-6,
            cacheReadInputCostPerToken: 3e-7,
            thresholdTokens: 200_000,
            inputCostPerTokenAboveThreshold: 6e-6,
            outputCostPerTokenAboveThreshold: 2.25e-5,
            cacheCreationInputCostPerTokenAboveThreshold: 7.5e-6,
            cacheReadInputCostPerTokenAboveThreshold: 6e-7),
        "claude-sonnet-4-5-20250929": ClaudePricing(
            inputCostPerToken: 3e-6,
            outputCostPerToken: 1.5e-5,
            cacheCreationInputCostPerToken: 3.75e-6,
            cacheReadInputCostPerToken: 3e-7,
            thresholdTokens: 200_000,
            inputCostPerTokenAboveThreshold: 6e-6,
            outputCostPerTokenAboveThreshold: 2.25e-5,
            cacheCreationInputCostPerTokenAboveThreshold: 7.5e-6,
            cacheReadInputCostPerTokenAboveThreshold: 6e-7),
        "claude-opus-4-20250514": ClaudePricing(
            inputCostPerToken: 1.5e-5,
            outputCostPerToken: 7.5e-5,
            cacheCreationInputCostPerToken: 1.875e-5,
            cacheReadInputCostPerToken: 1.5e-6,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-opus-4-1": ClaudePricing(
            inputCostPerToken: 1.5e-5,
            outputCostPerToken: 7.5e-5,
            cacheCreationInputCostPerToken: 1.875e-5,
            cacheReadInputCostPerToken: 1.5e-6,
            thresholdTokens: nil,
            inputCostPerTokenAboveThreshold: nil,
            outputCostPerTokenAboveThreshold: nil,
            cacheCreationInputCostPerTokenAboveThreshold: nil,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "claude-sonnet-4-20250514": ClaudePricing(
            inputCostPerToken: 3e-6,
            outputCostPerToken: 1.5e-5,
            cacheCreationInputCostPerToken: 3.75e-6,
            cacheReadInputCostPerToken: 3e-7,
            thresholdTokens: 200_000,
            inputCostPerTokenAboveThreshold: 6e-6,
            outputCostPerTokenAboveThreshold: 2.25e-5,
            cacheCreationInputCostPerTokenAboveThreshold: 7.5e-6,
            cacheReadInputCostPerTokenAboveThreshold: 6e-7),
    ]

    // Gemini API pricing uses tiered rates by prompt size for Pro preview models.
    // We normalize OpenCode model aliases into these canonical keys.
    private static let gemini: [String: GeminiPricing] = [
        "gemini-3.1-pro-preview": GeminiPricing(
            inputCostPerToken: 2e-6,
            outputCostPerToken: 12e-6,
            cacheReadInputCostPerToken: 0,
            thresholdTokens: 200_000,
            inputCostPerTokenAboveThreshold: 4e-6,
            outputCostPerTokenAboveThreshold: 18e-6,
            cacheReadInputCostPerTokenAboveThreshold: nil),
        "gemini-3-pro-preview": GeminiPricing(
            inputCostPerToken: 2e-6,
            outputCostPerToken: 12e-6,
            cacheReadInputCostPerToken: 0,
            thresholdTokens: 200_000,
            inputCostPerTokenAboveThreshold: 4e-6,
            outputCostPerTokenAboveThreshold: 18e-6,
            cacheReadInputCostPerTokenAboveThreshold: nil),
    ]

    static func normalizeCodexModel(_ raw: String) -> String {
        var trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("openai.") {
            trimmed = String(trimmed.dropFirst("openai.".count))
        }
        if trimmed.hasPrefix("openai/") {
            trimmed = String(trimmed.dropFirst("openai/".count))
        }
        for suffix in ["-xhigh", "-high", "-medium", "-low", "-thinking"] {
            if trimmed.hasSuffix(suffix) {
                let candidate = String(trimmed.dropLast(suffix.count))
                if self.codex[candidate] != nil {
                    trimmed = candidate
                    break
                }
            }
        }
        if let codexRange = trimmed.range(of: "-codex") {
            let base = String(trimmed[..<codexRange.lowerBound])
            if self.codex[base] != nil { return base }
        }
        return trimmed
    }

    static func normalizeClaudeModel(_ raw: String) -> String {
        var trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("anthropic.") {
            trimmed = String(trimmed.dropFirst("anthropic.".count))
        }

        if let lastDot = trimmed.lastIndex(of: "."),
           trimmed.contains("claude-")
        {
            let tail = String(trimmed[trimmed.index(after: lastDot)...])
            if tail.hasPrefix("claude-") {
                trimmed = tail
            }
        }

        if let vRange = trimmed.range(of: #"-v\d+:\d+$"#, options: .regularExpression) {
            trimmed.removeSubrange(vRange)
        }

        if let reordered = self.reorderedClaudeModel(trimmed) {
            trimmed = reordered
        }

        for suffix in ["-thinking", "-preview"] {
            if trimmed.hasSuffix(suffix) {
                let candidate = String(trimmed.dropLast(suffix.count))
                if self.claude[candidate] != nil {
                    trimmed = candidate
                    break
                }
            }
        }

        if let baseRange = trimmed.range(of: #"-\d{8}$"#, options: .regularExpression) {
            let base = String(trimmed[..<baseRange.lowerBound])
            if self.claude[base] != nil {
                return base
            }
        }

        return trimmed
    }

    static func normalizeGeminiModel(_ raw: String) -> String {
        var trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("google.") {
            trimmed = String(trimmed.dropFirst("google.".count))
        }
        if trimmed.hasPrefix("google/") {
            trimmed = String(trimmed.dropFirst("google/".count))
        }

        if trimmed.hasPrefix("gemini-3.1-pro-preview") {
            return "gemini-3.1-pro-preview"
        }
        if trimmed.hasPrefix("gemini-3-pro-preview") {
            return "gemini-3-pro-preview"
        }
        return trimmed
    }

    static func normalizeOpenCodeModel(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.contains("claude-") || trimmed.hasPrefix("anthropic.") {
            return self.normalizeClaudeModel(trimmed)
        }
        if trimmed.contains("gpt-") || trimmed.hasPrefix("openai.") || trimmed.hasPrefix("openai/") {
            return self.normalizeCodexModel(trimmed)
        }
        if trimmed.contains("gemini-") || trimmed.hasPrefix("google.") || trimmed.hasPrefix("google/") {
            return self.normalizeGeminiModel(trimmed)
        }
        return trimmed
    }

    static func codexCostUSD(model: String, inputTokens: Int, cachedInputTokens: Int, outputTokens: Int) -> Double? {
        let key = self.normalizeCodexModel(model)
        guard let pricing = self.codex[key] else { return nil }
        let cached = min(max(0, cachedInputTokens), max(0, inputTokens))
        let nonCached = max(0, inputTokens - cached)
        return Double(nonCached) * pricing.inputCostPerToken
            + Double(cached) * pricing.cacheReadInputCostPerToken
            + Double(max(0, outputTokens)) * pricing.outputCostPerToken
    }

    static func claudeCostUSD(
        model: String,
        inputTokens: Int,
        cacheReadInputTokens: Int,
        cacheCreationInputTokens: Int,
        outputTokens: Int) -> Double?
    {
        let key = self.normalizeClaudeModel(model)
        guard let pricing = self.claude[key] else { return nil }

        func tiered(_ tokens: Int, base: Double, above: Double?, threshold: Int?) -> Double {
            guard let threshold, let above else { return Double(tokens) * base }
            let below = min(tokens, threshold)
            let over = max(tokens - threshold, 0)
            return Double(below) * base + Double(over) * above
        }

        return tiered(
            max(0, inputTokens),
            base: pricing.inputCostPerToken,
            above: pricing.inputCostPerTokenAboveThreshold,
            threshold: pricing.thresholdTokens)
            + tiered(
                max(0, cacheReadInputTokens),
                base: pricing.cacheReadInputCostPerToken,
                above: pricing.cacheReadInputCostPerTokenAboveThreshold,
                threshold: pricing.thresholdTokens)
            + tiered(
                max(0, cacheCreationInputTokens),
                base: pricing.cacheCreationInputCostPerToken,
                above: pricing.cacheCreationInputCostPerTokenAboveThreshold,
                threshold: pricing.thresholdTokens)
            + tiered(
                max(0, outputTokens),
                base: pricing.outputCostPerToken,
                above: pricing.outputCostPerTokenAboveThreshold,
                threshold: pricing.thresholdTokens)
    }

    static func geminiCostUSD(
        model: String,
        inputTokens: Int,
        cacheReadInputTokens: Int,
        outputTokens: Int) -> Double?
    {
        let key = self.normalizeGeminiModel(model)
        guard let pricing = self.gemini[key] else { return nil }

        func tiered(_ tokens: Int, base: Double, above: Double?, threshold: Int?) -> Double {
            guard let threshold, let above else { return Double(tokens) * base }
            let below = min(tokens, threshold)
            let over = max(tokens - threshold, 0)
            return Double(below) * base + Double(over) * above
        }

        return tiered(
            max(0, inputTokens),
            base: pricing.inputCostPerToken,
            above: pricing.inputCostPerTokenAboveThreshold,
            threshold: pricing.thresholdTokens)
            + tiered(
                max(0, cacheReadInputTokens),
                base: pricing.cacheReadInputCostPerToken,
                above: pricing.cacheReadInputCostPerTokenAboveThreshold,
                threshold: pricing.thresholdTokens)
            + tiered(
                max(0, outputTokens),
                base: pricing.outputCostPerToken,
                above: pricing.outputCostPerTokenAboveThreshold,
                threshold: pricing.thresholdTokens)
    }

    static func openCodeCostUSD(
        model: String,
        inputTokens: Int,
        cacheReadInputTokens: Int,
        cacheCreationInputTokens: Int,
        outputTokens: Int) -> Double?
    {
        let normalized = self.normalizeOpenCodeModel(model)
        if normalized.contains("claude-") {
            return self.claudeCostUSD(
                model: normalized,
                inputTokens: inputTokens,
                cacheReadInputTokens: cacheReadInputTokens,
                cacheCreationInputTokens: cacheCreationInputTokens,
                outputTokens: outputTokens)
        }
        if normalized.contains("gpt-") {
            return self.codexCostUSD(
                model: normalized,
                inputTokens: inputTokens,
                cachedInputTokens: cacheReadInputTokens,
                outputTokens: outputTokens)
        }
        if normalized.contains("gemini-") {
            return self.geminiCostUSD(
                model: normalized,
                inputTokens: inputTokens,
                cacheReadInputTokens: cacheReadInputTokens,
                outputTokens: outputTokens)
        }
        return nil
    }

    private static func reorderedClaudeModel(_ raw: String) -> String? {
        let pattern = #"^claude-(\d+)\.(\d+)-(opus|sonnet|haiku)(?:-[A-Za-z0-9._-]+)?$"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        let nsRange = NSRange(raw.startIndex..<raw.endIndex, in: raw)
        guard let match = regex.firstMatch(in: raw, options: [], range: nsRange),
              match.numberOfRanges == 4,
              let majorRange = Range(match.range(at: 1), in: raw),
              let minorRange = Range(match.range(at: 2), in: raw),
              let familyRange = Range(match.range(at: 3), in: raw)
        else {
            return nil
        }
        let major = raw[majorRange]
        let minor = raw[minorRange]
        let family = raw[familyRange]
        return "claude-\(family)-\(major)-\(minor)"
    }
}

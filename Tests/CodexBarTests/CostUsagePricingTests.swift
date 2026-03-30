import Testing
@testable import CodexBarCore

struct CostUsagePricingTests {
    @Test
    func `normalizes codex model variants exactly`() {
        #expect(CostUsagePricing.normalizeCodexModel("openai/gpt-5-codex") == "gpt-5-codex")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.2-codex") == "gpt-5.2-codex")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.1-codex-max") == "gpt-5.1-codex-max")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.4-pro-2026-03-05") == "gpt-5.4-pro")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.4-mini-2026-03-17") == "gpt-5.4-mini")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.4-nano-2026-03-17") == "gpt-5.4-nano")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.3-codex-2026-03-05") == "gpt-5.3-codex")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.3-codex-spark") == "gpt-5.3-codex-spark")
    }

    @Test
    func `codex cost supports gpt51 codex max`() {
        let cost = CostUsagePricing.codexCostUSD(
            model: "gpt-5.1-codex-max",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func `codex cost supports gpt53 codex`() {
        let cost = CostUsagePricing.codexCostUSD(
            model: "gpt-5.3-codex",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func `codex cost supports gpt54 mini and nano`() {
        let mini = CostUsagePricing.codexCostUSD(
            model: "gpt-5.4-mini-2026-03-17",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)
        let nano = CostUsagePricing.codexCostUSD(
            model: "gpt-5.4-nano",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)

        #expect(mini != nil)
        #expect(nano != nil)
    }

    @Test
    func `codex cost returns zero for research preview model`() {
        let cost = CostUsagePricing.codexCostUSD(
            model: "gpt-5.3-codex-spark",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)
        #expect(cost == 0)
        #expect(CostUsagePricing.codexDisplayLabel(model: "gpt-5.3-codex-spark") == "Research Preview")
        #expect(CostUsagePricing.codexDisplayLabel(model: "gpt-5.2-codex") == nil)
    }

    @Test
    func `normalizes claude opus41 dated variants`() {
        #expect(CostUsagePricing.normalizeClaudeModel("claude-opus-4-1-20250805") == "claude-opus-4-1")
    }

    @Test
    func `claude cost supports opus41 dated variant`() {
        let cost = CostUsagePricing.claudeCostUSD(
            model: "claude-opus-4-1-20250805",
            inputTokens: 10,
            cacheReadInputTokens: 0,
            cacheCreationInputTokens: 0,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func `claude cost supports opus46 dated variant`() {
        let cost = CostUsagePricing.claudeCostUSD(
            model: "claude-opus-4-6-20260205",
            inputTokens: 10,
            cacheReadInputTokens: 0,
            cacheCreationInputTokens: 0,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func `claude cost returns nil for unknown models`() {
        let cost = CostUsagePricing.claudeCostUSD(
            model: "glm-4.6",
            inputTokens: 100,
            cacheReadInputTokens: 500,
            cacheCreationInputTokens: 0,
            outputTokens: 40)
        #expect(cost == nil)
    }

    @Test
    func normalizesOpenCodeClaudeAndOpenAIAliases() {
        #expect(CostUsagePricing.normalizeOpenCodeModel("anthropic.claude-4.6-opus-thinking") == "claude-opus-4-6")
        #expect(CostUsagePricing.normalizeOpenCodeModel("openai.gpt-5.3-codex-xhigh") == "gpt-5.3")
    }

    @Test
    func openCodeCostSupportsClaudeAlias() {
        let cost = CostUsagePricing.openCodeCostUSD(
            model: "anthropic.claude-4.6-opus-thinking",
            inputTokens: 1000,
            cacheReadInputTokens: 100,
            cacheCreationInputTokens: 100,
            outputTokens: 100)
        #expect(cost != nil)
    }

    @Test
    func openCodeCostSupportsOpenAIAlias() {
        let cost = CostUsagePricing.openCodeCostUSD(
            model: "openai.gpt-5.3-codex-xhigh",
            inputTokens: 1000,
            cacheReadInputTokens: 200,
            cacheCreationInputTokens: 0,
            outputTokens: 100)
        #expect(cost != nil)
    }

    @Test
    func openCodeCostSupportsGeminiAlias() {
        let cost = CostUsagePricing.openCodeCostUSD(
            model: "google.gemini-3.1-pro-preview-thinking",
            inputTokens: 1000,
            cacheReadInputTokens: 0,
            cacheCreationInputTokens: 0,
            outputTokens: 100)
        #expect(cost != nil)
    }
}

import Testing
@testable import CodexBarCore

@Suite
struct CostUsagePricingTests {
    @Test
    func normalizesCodexModelVariants() {
        #expect(CostUsagePricing.normalizeCodexModel("openai/gpt-5-codex") == "gpt-5")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.2-codex") == "gpt-5.2")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.1-codex-max") == "gpt-5.1")
        #expect(CostUsagePricing.normalizeCodexModel("gpt-5.3-codex-max") == "gpt-5.3")
    }

    @Test
    func codexCostSupportsGpt51CodexMax() {
        let cost = CostUsagePricing.codexCostUSD(
            model: "gpt-5.1-codex-max",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func codexCostSupportsGpt53CodexMax() {
        let cost = CostUsagePricing.codexCostUSD(
            model: "gpt-5.3-codex-max",
            inputTokens: 100,
            cachedInputTokens: 10,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func normalizesClaudeOpus41DatedVariants() {
        #expect(CostUsagePricing.normalizeClaudeModel("claude-opus-4-1-20250805") == "claude-opus-4-1")
    }

    @Test
    func claudeCostSupportsOpus41DatedVariant() {
        let cost = CostUsagePricing.claudeCostUSD(
            model: "claude-opus-4-1-20250805",
            inputTokens: 10,
            cacheReadInputTokens: 0,
            cacheCreationInputTokens: 0,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func claudeCostSupportsOpus46DatedVariant() {
        let cost = CostUsagePricing.claudeCostUSD(
            model: "claude-opus-4-6-20260205",
            inputTokens: 10,
            cacheReadInputTokens: 0,
            cacheCreationInputTokens: 0,
            outputTokens: 5)
        #expect(cost != nil)
    }

    @Test
    func claudeCostReturnsNilForUnknownModels() {
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
            inputTokens: 1_000,
            cacheReadInputTokens: 100,
            cacheCreationInputTokens: 100,
            outputTokens: 100)
        #expect(cost != nil)
    }

    @Test
    func openCodeCostSupportsOpenAIAlias() {
        let cost = CostUsagePricing.openCodeCostUSD(
            model: "openai.gpt-5.3-codex-xhigh",
            inputTokens: 1_000,
            cacheReadInputTokens: 200,
            cacheCreationInputTokens: 0,
            outputTokens: 100)
        #expect(cost != nil)
    }

    @Test
    func openCodeCostSupportsGeminiAlias() {
        let cost = CostUsagePricing.openCodeCostUSD(
            model: "google.gemini-3.1-pro-preview-thinking",
            inputTokens: 1_000,
            cacheReadInputTokens: 0,
            cacheCreationInputTokens: 0,
            outputTokens: 100)
        #expect(cost != nil)
    }
}

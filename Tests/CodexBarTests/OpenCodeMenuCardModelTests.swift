import CodexBarCore
import Foundation
import Testing
@testable import CodexBar

struct OpenCodeMenuCardModelTests {
    @Test
    func `opencode model prefers local cost over web cookie error`() throws {
        let now = Date()
        let metadata = try #require(ProviderDefaults.metadata[.opencode])
        let tokenSnapshot = CostUsageTokenSnapshot(
            sessionTokens: 1234,
            sessionCostUSD: 1.23,
            last30DaysTokens: 5678,
            last30DaysCostUSD: 9.87,
            daily: [],
            updatedAt: now)

        let model = UsageMenuCardView.Model.make(.init(
            provider: .opencode,
            metadata: metadata,
            snapshot: nil,
            credits: nil,
            creditsError: nil,
            dashboard: nil,
            dashboardError: nil,
            tokenSnapshot: tokenSnapshot,
            tokenError: nil,
            account: AccountInfo(email: nil, plan: nil),
            isRefreshing: false,
            lastError: "No OpenCode session cookies found in browsers.",
            usageBarsShowUsed: false,
            resetTimeDisplayStyle: .countdown,
            tokenCostUsageEnabled: true,
            showOptionalCreditsAndExtraUsage: true,
            hidePersonalInfo: false,
            now: now))

        #expect(model.subtitleStyle == .info)
        #expect(model.subtitleText.contains("Local cost"))
        #expect(model.tokenUsage != nil)
        #expect(model.placeholder == nil)
    }
}

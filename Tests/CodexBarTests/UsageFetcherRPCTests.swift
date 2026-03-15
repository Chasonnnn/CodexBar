import Foundation
import Testing
@testable import CodexBarCore

@Suite("Codex RPC", .serialized)
struct UsageFetcherRPCTests {
    @Test
    func fallsBackToTTYUsageWhenRPCRequestTimesOut() async throws {
        let environment = try FakeCodexCLIEnvironment()
        defer { environment.cleanup() }

        let previousCLIPath = ProcessInfo.processInfo.environment["CODEX_CLI_PATH"]
        setenv("CODEX_CLI_PATH", environment.binaryURL.path, 1)
        defer {
            if let previousCLIPath {
                setenv("CODEX_CLI_PATH", previousCLIPath, 1)
            } else {
                unsetenv("CODEX_CLI_PATH")
            }
        }

        let previousTimeout = CodexRPCTestHooks.requestTimeoutOverride
        CodexRPCTestHooks.requestTimeoutOverride = 0.1
        defer { CodexRPCTestHooks.requestTimeoutOverride = previousTimeout }

        let clock = ContinuousClock()
        let start = clock.now
        let snapshot = try await UsageFetcher().loadLatestUsage()
        let elapsed = start.duration(to: clock.now)

        #expect(elapsed < .seconds(2))
        #expect(snapshot.primary?.usedPercent == 25)
        #expect(snapshot.secondary?.usedPercent == 75)
    }

    @Test
    func fallsBackToTTYCreditsWhenRPCRequestTimesOut() async throws {
        let environment = try FakeCodexCLIEnvironment()
        defer { environment.cleanup() }

        let previousCLIPath = ProcessInfo.processInfo.environment["CODEX_CLI_PATH"]
        setenv("CODEX_CLI_PATH", environment.binaryURL.path, 1)
        defer {
            if let previousCLIPath {
                setenv("CODEX_CLI_PATH", previousCLIPath, 1)
            } else {
                unsetenv("CODEX_CLI_PATH")
            }
        }

        let previousTimeout = CodexRPCTestHooks.requestTimeoutOverride
        CodexRPCTestHooks.requestTimeoutOverride = 0.1
        defer { CodexRPCTestHooks.requestTimeoutOverride = previousTimeout }

        let clock = ContinuousClock()
        let start = clock.now
        let credits = try await UsageFetcher().loadLatestCredits()
        let elapsed = start.duration(to: clock.now)

        #expect(elapsed < .seconds(2))
        #expect(credits.remaining == 980)
    }
}

private struct FakeCodexCLIEnvironment {
    let rootURL: URL
    let binaryURL: URL

    init() throws {
        let rootURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("codexbar-codex-rpc-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true)

        let binaryURL = rootURL.appendingPathComponent("fake-codex.sh")
        let script = """
        #!/bin/sh
        for arg in "$@"; do
          if [ "$arg" = "app-server" ]; then
            sleep 3
            exit 0
          fi
        done
        cat <<'EOF'
        Credits: 980 credits
        5h limit: [#####] 75% left
        Weekly limit: [##] 25% left
        EOF
        """
        try script.write(to: binaryURL, atomically: true, encoding: .utf8)
        try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: binaryURL.path)

        self.rootURL = rootURL
        self.binaryURL = binaryURL
    }

    func cleanup() {
        try? FileManager.default.removeItem(at: self.rootURL)
    }
}

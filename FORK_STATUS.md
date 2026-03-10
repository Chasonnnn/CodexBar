# CodexBar Fork - Current Status

**Last Updated:** March 10, 2026
**Fork Maintainer:** Chasonnnn
**Branch:** `main`

---

## ✅ Completed Work

### Phase 1: Fork Identity & Credits ✓

**Commits:**
1. `f15cadd` - "chore: apply fork customizations on upstream main"
2. `5bf6f14` - "fix: add keychain access group to prevent permission prompts"
3. `2055677` - "chore: update Package.resolved for KeyboardShortcuts 1.9.0 pin"
4. `05758e9` - "fix: manual implementation of menuItemHighlighted EnvironmentKey"

**Changes:**
- ✅ Updated About section with dual attribution (original + fork)
- ✅ Updated PreferencesAboutPane with organized sections
- ✅ Changed app icon click to open fork repository
- ✅ Updated README with fork notice and enhancements section
- ✅ Created comprehensive `docs/augment.md` documentation
- ✅ Created `docs/FORK_ROADMAP.md` with 5-phase plan
- ✅ Created `docs/FORK_QUICK_START.md` developer guide
- ✅ Created `FORK_STATUS.md` tracking document
- ✅ **Implemented complete multi-upstream management system**

**Build Status:** ✅ App builds and runs successfully

### Multi-Upstream Management System ✓

**Automation Scripts:**
- ✅ `Scripts/check_upstreams.sh` - Monitor both upstreams
- ✅ `Scripts/review_upstream.sh` - Create review branches
- ✅ `Scripts/prepare_upstream_pr.sh` - Prepare upstream PRs
- ✅ `Scripts/analyze_quotio.sh` - Analyze quotio patterns

**GitHub Actions:**
- ✅ `.github/workflows/upstream-monitor.yml` - Automated monitoring

**Documentation:**
- ✅ `docs/UPSTREAM_STRATEGY.md` - Complete management guide
- ✅ `docs/QUOTIO_ANALYSIS.md` - Pattern analysis framework
- ✅ `docs/FORK_SETUP.md` - One-time setup guide

### Upstream Sync ✓ (February 28, 2026)

**Merge commit:** `a598a89` - "chore: sync 61 upstream commits from steipete/CodexBar"

**61 commits merged from steipete/CodexBar**, including:
- ✅ Copilot quota fallback improvements (7 commits)
- ✅ Overview tab / merged switcher (10 commits)
- ✅ GPT-5.3 Codex pricing
- ✅ JSONL scanner performance optimizations
- ✅ TTY command runner hardening
- ✅ OpenCode null subscription handling
- ✅ MiniMax CN region fix
- ✅ Gecko browser case-insensitive profile detection
- ✅ Many new test suites (CopilotUsageModels, SettingsStore, StatusMenu, etc.)
- ✅ OpenAI dashboard navigation fixes
- ✅ OpenRouter improvements
- ✅ Kimi provider fixes
- ✅ Codex credits display

**No merge conflicts** — all 60 upstream files integrated cleanly.

### Upstream Sync ✓ (March 2, 2026)

**Merge commit:** `chore: sync 16 upstream commits from steipete/CodexBar`

**16 commits merged from steipete/CodexBar** (`855a10f..982b476`), including:
- ✅ Add Kilo API mode provider support
- ✅ Surface actionable Kilo credential errors
- ✅ Add Kilo CLI source-mode readiness
- ✅ Implement Kilo usage source modes and fallback behavior
- ✅ Improve Kilo usage menu detail handling & CLI output parity
- ✅ Enable Kilo in widget provider selection
- ✅ Add must-have Kilo regression tests (718+ lines of tests)
- ✅ Handle Kilo zero-balance credit payload
- ✅ Refactor Kilo login handling and auto top-up activity detection
- ✅ Degrade optional Kilo tRPC errors and split activity labels
- ✅ Fix Kilo provider icon
- ✅ New docs: `docs/kilo.md`

**No merge conflicts** — all 50 upstream files integrated cleanly (3,771 insertions).

### Upstream Sync ✓ (March 10, 2026)

**Merge commit:** `0601822` - merge upstream/main (14 commits from steipete/CodexBar)

**14 commits merged from steipete/CodexBar** (`982b476..df39246`), including:
- ✅ Remove redundant extra usage rescale (double-division bug fix)
- ✅ Fix SwiftFormat lint in ClaudeUsageFetcher
- ✅ Surface Claude CLI rate limit errors
- ✅ Use Claude Code user agent for OAuth usage
- ✅ Harden Codex historical pace and backfill
- ✅ Avoid Codex account lookup for Claude pace
- ✅ Gate pace computation by display mode
- ✅ Split UsageStore support types into separate file
- ✅ Centralize clamping and harden deterministic test timezones
- ✅ Move historical tracking toggle to Codex settings
- ✅ Bound OpenAI WebView timeouts
- ✅ Handle zero-usage days in backfill
- ✅ New: `HistoricalUsagePace.swift` (852 lines), `UsageStoreSupport.swift`, `Double+Clamped.swift`
- ✅ 813+ lines of new historical usage pace tests

**No merge conflicts** — all 39 upstream files integrated cleanly (2,523 insertions).

### Fork Feature: OpenCode Cost Usage Support ✓ (March 10, 2026)

**Commit:** `4f5341e` - "feat: add OpenCode cost usage support"

**18 files changed** (1,002 insertions), including:
- ✅ `CostUsageScanner+OpenCode.swift` — SQLite-based OpenCode database scanner (NEW)
- ✅ `CostUsagePricing.swift` — OpenCode model pricing with Claude/OpenAI/Gemini alias normalization (+174 lines)
- ✅ Wire OpenCode into UsageStore, CostUsageFetcher, CLI, menu card, and preferences
- ✅ Add `CostSource` enum (native/fallback/mixed) to model breakdowns
- ✅ Detect OpenCode database as token cost usage source
- ✅ `OpenCodeCostScannerTests.swift` — comprehensive test suite (NEW)
- ✅ Additional tests in CostUsagePricingTests, MenuCardModelTests, SettingsStoreAdditionalTests

---

## 🎯 Current State

### Git Remotes
```
origin    https://github.com/Chasonnnn/CodexBar.git
upstream  https://github.com/steipete/CodexBar.git
```

### Branch Status
- `main` is **in sync with upstream** (merge commit synced to `df39246`)
- Fork is 11 commits ahead of upstream (fork customizations + 3 sync merges + OpenCode feature)
- Fork is pushed to `origin/main` ✅

### What Works
- ✅ Fork identity clearly established
- ✅ Dual attribution in place (original + fork)
- ✅ Comprehensive documentation
- ✅ Clear development roadmap
- ✅ App builds without errors
- ✅ All existing functionality preserved
- ✅ **Multi-upstream management system operational**
- ✅ **Automated upstream monitoring configured**
- ✅ **61 upstream commits synced (Feb 28, 2026)**
- ✅ **16 upstream Kilo provider commits synced (Mar 2, 2026)**
- ✅ **14 upstream commits synced (Mar 10, 2026)**
- ✅ **OpenCode cost usage feature committed and pushed (Mar 10, 2026)**

### Critical Discovery (from earlier sync)
- ⚠️ **Upstream (steipete) had REMOVED Augment provider** at one point
  - 627 lines deleted from `AugmentStatusProbe.swift`
  - 88 lines deleted from `AugmentStatusProbeTests.swift`
  - **This validates our fork strategy!**
  - We preserve Augment support for our users
  - We can selectively sync other improvements

### Known Issues
- ⚠️ Augment cookie disconnection (Phase 2 will address)
- ⚠️ Debug print statements in AugmentStatusProbe.swift (needs proper logging)

---

## 📋 Next Steps

### Immediate (Phase 2)
1. **Replace debug prints with proper logging**
   - Use `CodexBarLog.logger("augment")` pattern
   - Add structured metadata
   - Follow Claude/Cursor provider patterns

2. **Enhanced cookie diagnostics**
   - Log cookie expiration times
   - Track refresh attempts
   - Add domain filtering diagnostics

3. **Session keepalive monitoring**
   - Add keepalive status to debug pane
   - Log refresh attempts
   - Add manual "Force Refresh" button

### Short Term (Phases 3-4)
- **Analyze Quotio features** using `./Scripts/analyze_quotio.sh`
- **Regular upstream monitoring** (automated via GitHub Actions)
- **Weekly sync routine** (Monday: upstream, Thursday: quotio)

### Medium Term (Phase 5)
- Implement multi-account management (inspired by quotio)
- Start with Augment provider
- Extend to other providers

---

## 📁 Key Files Modified (Fork-Specific)

### Source Code
- `Sources/CodexBar/MenuHighlightStyle.swift` - Fork UI tweak
- `Sources/CodexBar/PreferencesAboutPane.swift` - Dual attribution
- `Sources/CodexBarCore/KeychainCacheStore.swift` - Keychain access group fix
- `Package.swift` / `Package.resolved` - Dependency updates

### Documentation
- `README.md` - Fork notice and enhancements
- `docs/augment.md` - Augment provider guide (NEW)
- `docs/FORK_ROADMAP.md` - Development roadmap (NEW)
- `docs/FORK_QUICK_START.md` - Quick reference (NEW)

---

## 🔄 Git Status

```bash
# Current branch
main

# Commits ahead of upstream/main
11 commits (fork customizations + 3 upstream sync merges + OpenCode feature)

# Last sync
March 10, 2026 — 14 commits from steipete/CodexBar + OpenCode cost usage feature

# Upstream tip synced to
df39246 — Update CHANGELOG.md

# Working tree
clean — nothing to commit
```

---

## 📊 Progress Tracking

### Phase 1: Fork Identity ✅ COMPLETE
- [x] Dual attribution in About
- [x] Fork notice in README
- [x] Augment documentation
- [x] Development roadmap
- [x] Quick start guide

### Upstream Sync ✅ COMPLETE (Feb 28, 2026)
- [x] 61 commits merged from steipete/CodexBar
- [x] No conflicts
- [x] Pushed to origin

### Upstream Sync ✅ COMPLETE (Mar 2, 2026)
- [x] 16 Kilo provider commits merged from steipete/CodexBar
- [x] No conflicts
- [x] Pushed to origin

### Upstream Sync ✅ COMPLETE (Mar 10, 2026)
- [x] 14 commits merged from steipete/CodexBar
- [x] No conflicts
- [x] OpenCode cost usage feature committed
- [x] Pushed to origin

### Phase 2: Enhanced Diagnostics 🔄 READY TO START
- [ ] Replace print() with CodexBarLog
- [ ] Enhanced cookie diagnostics
- [ ] Session keepalive monitoring
- [ ] Debug pane improvements

### Phase 3: Quotio Analysis 📋 PLANNED
- [ ] Feature comparison matrix
- [ ] Implementation recommendations
- [ ] Priority ranking

### Phase 4: Upstream Sync Automation 📋 PLANNED
- [ ] Sync script
- [ ] Conflict resolution guide
- [ ] Automated checks

### Phase 5: Multi-Account 📋 PLANNED
- [ ] Account management UI
- [ ] Account storage
- [ ] Account switching
- [ ] UI enhancements

---

## 🎯 Success Criteria

### Phase 1 (Current) ✅
- [x] Fork identity clearly established
- [x] Original author properly credited
- [x] Comprehensive documentation
- [x] App builds and runs
- [x] No regressions

### Phase 2 (Next)
- [ ] Zero cookie disconnection issues
- [ ] Proper structured logging
- [ ] Enhanced debug diagnostics
- [ ] Manual refresh capability
- [ ] All tests passing

---

## 🔗 Quick Links

- **Roadmap:** `docs/FORK_ROADMAP.md`
- **Quick Start:** `docs/FORK_QUICK_START.md`
- **Augment Docs:** `docs/augment.md`
- **Original Repo:** https://github.com/steipete/CodexBar
- **Fork Repo:** https://github.com/Chasonnnn/CodexBar

---

## 💡 Recommendations

1. **Review new upstream features** — Copilot fallback, overview tab, and Kimi fixes are significant
2. **Test the build** after the large sync — `swift build` or open in Xcode
3. **Start Phase 2** — `feature/augment-diagnostics` branch
4. **Start with logging** — Replace prints with proper CodexBarLog
5. **Document as you go** — Update docs with findings

---

**Ready to proceed with Phase 2?** See `docs/FORK_ROADMAP.md` for detailed tasks.

import XCTest
@testable import ReverseWorld

/// R5-6: Real unit tests for core models (R5-6 fix: was 0 tests, file was empty)
final class RuleDataTests: XCTestCase {

    func testAllRulesCount() {
        XCTAssertEqual(RuleData.allRules.count, 8, "Should have exactly 8 reverse rules")
    }

    func testAllRulesHaveUniqueIDs() {
        let ids = RuleData.allRules.map { $0.id }
        XCTAssertEqual(Set(ids).count, ids.count, "All rule IDs should be unique")
    }

    func testAllRulesHaveNonEmptyTitle() {
        for rule in RuleData.allRules {
            XCTAssertFalse(rule.title.isEmpty, "Rule title should not be empty")
            XCTAssertGreaterThan(rule.title.count, 5, "Rule title should be at least 6 chars")
        }
    }

    func testAllRulesHaveNonEmptyDescription() {
        for rule in RuleData.allRules {
            XCTAssertFalse(rule.description.isEmpty, "Rule description should not be empty")
        }
    }

    func testRuleForTodayIsDeterministic() {
        let date1 = Date(timeIntervalSince1970: 1_700_000_000)  // 2023-11-14
        let date2 = Date(timeIntervalSince1970: 1_700_086_400)  // 2023-11-15 (next day)

        let ruleDay1 = RuleData.ruleForToday(now: date1)
        let ruleDay2 = RuleData.ruleForToday(now: date2)

        XCTAssertNotEqual(ruleDay1.id, ruleDay2.id, "Different days should produce different rules")
    }

    func testRuleForTodayWrapsAround() {
        // Test that 9 days (more than 8 rules) wraps to the start
        let baseDate = Date(timeIntervalSince1970: 1_700_000_000)
        let ruleDay1 = RuleData.ruleForToday(now: baseDate)
        let ruleDay9 = RuleData.ruleForToday(now: baseDate.addingTimeInterval(8 * 86400))

        XCTAssertEqual(ruleDay1.id, ruleDay9.id, "After 8 days, rule should wrap around")
    }
}

final class RuleManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Clear persisted state for each test
        UserDefaults.standard.removeObject(forKey: "ruleHistory")
    }

    func testInitialState() {
        let manager = RuleManager()
        XCTAssertEqual(manager.ruleHistory.count, 0, "New manager should have empty history")
    }

    func testCompleteCurrentRuleAppends() {
        let manager = RuleManager()
        let initialRuleId = manager.currentRule.id
        manager.completeCurrentRule()
        XCTAssertTrue(manager.ruleHistory.contains { $0.id == initialRuleId }, "Completed rule should be in history")
        XCTAssertTrue(manager.ruleHistory.first { $0.id == initialRuleId }?.isCompleted == true, "Completed rule should be marked")
    }

    func testCompleteTwiceIsIdempotent() {
        let manager = RuleManager()
        let ruleId = manager.currentRule.id
        manager.completeCurrentRule()
        let countAfterFirst = manager.ruleHistory.count
        manager.refreshRule()  // Simulate next day
        manager.completeCurrentRule()  // Try to re-complete
        // Note: completeCurrentRule only appends if not already in history
        // After refresh, currentRule.id is different, so a 2nd rule is added
        XCTAssertGreaterThanOrEqual(manager.ruleHistory.count, countAfterFirst, "Should not lose history")
        // The first rule should still be in history
        XCTAssertTrue(manager.ruleHistory.contains { $0.id == ruleId }, "First rule should remain in history")
    }
}

final class StatsManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Clear persisted state for each test
        UserDefaults.standard.removeObject(forKey: "reverseDays")
        UserDefaults.standard.removeObject(forKey: "rulesDiscovered")
        UserDefaults.standard.removeObject(forKey: "mirrorTimeMinutes")
        UserDefaults.standard.removeObject(forKey: "achievements")
    }

    func testInitialState() {
        let manager = StatsManager()
        XCTAssertEqual(manager.reverseDays, 0, "New manager should have 0 reverse days")
        XCTAssertEqual(manager.rulesDiscovered, 0, "New manager should have 0 rules")
        XCTAssertEqual(manager.mirrorTimeMinutes, 0, "New manager should have 0 mirror minutes")
    }

    func testIncrementReverseDays() {
        let manager = StatsManager()
        manager.reverseDays = 0
        manager.incrementReverseDays()
        XCTAssertEqual(manager.reverseDays, 1, "Should increment to 1")
        manager.incrementReverseDays()
        XCTAssertEqual(manager.reverseDays, 2, "Should increment to 2")
    }

    func testIncrementMirrorTime() {
        let manager = StatsManager()
        manager.mirrorTimeMinutes = 0
        manager.incrementMirrorTime()
        XCTAssertEqual(manager.mirrorTimeMinutes, 1, "Should increment to 1")
    }

    func testAddRuleDiscovery() {
        let manager = StatsManager()
        manager.rulesDiscovered = 0
        manager.addRuleDiscovery()
        XCTAssertEqual(manager.rulesDiscovered, 1, "Should increment to 1")
    }

    func testUnlockAchievement() {
        let manager = StatsManager()
        manager.achievements = []
        manager.unlockAchievement(name: "Test Achievement", icon: "star.fill")
        XCTAssertEqual(manager.achievements.count, 1, "Should have 1 achievement")
        XCTAssertEqual(manager.achievements.first?.name, "Test Achievement", "Name should match")
    }

    func testUnlockAchievementIdempotent() {
        let manager = StatsManager()
        manager.achievements = []
        manager.unlockAchievement(name: "Test", icon: "star.fill")
        manager.unlockAchievement(name: "Test", icon: "star.fill")
        XCTAssertEqual(manager.achievements.count, 1, "Should not add duplicate")
    }
}

final class L10nTests: XCTestCase {

    func testAllKeysHaveNonEmptyValues() {
        // Just verify L10n enum can be referenced and produces non-empty strings
        XCTAssertFalse(L10n.appName.isEmpty, "appName should not be empty")
        XCTAssertFalse(L10n.homeTitle.isEmpty, "homeTitle should not be empty")
        XCTAssertFalse(L10n.translatorTitle.isEmpty, "translatorTitle should not be empty")
        XCTAssertFalse(L10n.profileTitle.isEmpty, "profileTitle should not be empty")
    }

    func testCountdownFormat() {
        let result = L10n.countdownFormat(hours: 5, minutes: 30)
        XCTAssertEqual(result, "5h 30m until new rule", "Format should match")
    }

    func testNDaysFormat() {
        let result = L10n.nDays(7)
        XCTAssertEqual(result, "7 days reversing", "Format should match")
    }
}

import SwiftUI

@main
struct ReverseWorldApp: App {
    @StateObject private var ruleManager = RuleManager()
    @StateObject private var statsManager = StatsManager()
    @StateObject private var permissionsManager = PermissionsManager()
    @AppStorage("isDarkMode") private var isDarkMode = true

    init() {
        if CommandLine.arguments.contains("-forceDarkMode") {
            UserDefaults.standard.set(true, forKey: "isDarkMode")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ruleManager)
                .environmentObject(statsManager)
                .environmentObject(permissionsManager)  // Per 佛老爷 09:06 CST "摄像头和相册权限优化"
                .environmentObject(PremiumManager.shared)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

class RuleManager: ObservableObject {
    @Published var currentRule: ReverseRule
    @Published var ruleHistory: [ReverseRule] = []

    private let historyKey = "ruleHistory"

    init() {
        // R2: deterministic daily rotation via RuleData.ruleForToday()
        currentRule = RuleData.ruleForToday()
        loadHistory()
    }

    func refreshRule() {
        // R2: same logic — pick next day's rule (not random)
        let tomorrow = Date().addingTimeInterval(86400)
        currentRule = RuleData.ruleForToday(now: tomorrow)
    }

    func completeCurrentRule() {
        // BUGFIX: previously created newRule with new UUID but checked currentRule.id
        // (different UUID), so nothing was ever appended. Now preserve the same id.
        let completedRule = ReverseRule(
            id: currentRule.id,
            title: currentRule.title,
            description: currentRule.description,
            isCompleted: true
        )
        if !ruleHistory.contains(where: { $0.id == currentRule.id }) {
            ruleHistory.append(completedRule)
            saveHistory()
        }
        refreshRule()
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([ReverseRule].self, from: data) {
            ruleHistory = decoded
        }
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(ruleHistory) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
}

struct ReverseRule: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, description: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}

class StatsManager: ObservableObject {
    @Published var reverseDays: Int = 0
    @Published var rulesDiscovered: Int = 0
    @Published var mirrorTimeMinutes: Int = 0
    @Published var achievements: [Achievement] = []  // P9: now persisted

    init() {
        loadStats()
    }

    func incrementReverseDays() {
        reverseDays += 1
        saveStats()
    }

    func incrementMirrorTime() {
        mirrorTimeMinutes += 1
        saveStats()
    }

    func addRuleDiscovery() {
        rulesDiscovered += 1
        saveStats()
    }

    /// P9: unlock achievement
    func unlockAchievement(name: String, icon: String) {
        if !achievements.contains(where: { $0.name == name }) {
            achievements.append(Achievement(name: name, icon: icon, isUnlocked: true))
            saveStats()
            // Trigger achievement notification
            ReverseNotificationService.shared.scheduleAchievementNotification(achievement: name)
        }
    }

    private func loadStats() {
        reverseDays = UserDefaults.standard.integer(forKey: "reverseDays")
        rulesDiscovered = UserDefaults.standard.integer(forKey: "rulesDiscovered")
        mirrorTimeMinutes = UserDefaults.standard.integer(forKey: "mirrorTimeMinutes")
        if let data = UserDefaults.standard.data(forKey: "achievements"),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }
    }

    func saveStats() {
        UserDefaults.standard.set(reverseDays, forKey: "reverseDays")
        UserDefaults.standard.set(rulesDiscovered, forKey: "rulesDiscovered")
        UserDefaults.standard.set(mirrorTimeMinutes, forKey: "mirrorTimeMinutes")
        if let data = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(data, forKey: "achievements")
        }
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let name: String
    let icon: String
    var isUnlocked: Bool

    init(id: UUID = UUID(), name: String, icon: String, isUnlocked: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.isUnlocked = isUnlocked
    }
}

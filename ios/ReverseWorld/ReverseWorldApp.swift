import SwiftUI

@main
struct ReverseWorldApp: App {
    @StateObject private var ruleManager = RuleManager()
    @StateObject private var statsManager = StatsManager()
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ruleManager)
                .environmentObject(statsManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

class RuleManager: ObservableObject {
    @Published var currentRule: ReverseRule
    @Published var ruleHistory: [ReverseRule] = []

    private let rules = [
        ReverseRule(title: "Walk backwards to move forward", description: "Today, every step backward takes you further ahead."),
        ReverseRule(title: "Speak in reverse sentences", description: "Form your sentences in reverse word order."),
        ReverseRule(title: "Read everything backwards", description: "Start from the end of text to understand the beginning."),
        ReverseRule(title: "Use your non-dominant hand", description: "Switch hands for all tasks today."),
        ReverseRule(title: "Reverse your daily routine", description: "Do everything in opposite order today."),
        ReverseRule(title: "Think opposite", description: "For every thought, consider the reverse."),
    ]

    init() {
        currentRule = rules.randomElement() ?? rules[0]
        loadHistory()
    }

    func refreshRule() {
        currentRule = rules.randomElement() ?? rules[0]
    }

    private func loadHistory() {
        // Load from UserDefaults
    }
}

struct ReverseRule: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isCompleted = false
}

class StatsManager: ObservableObject {
    @Published var reverseDays: Int = 0
    @Published var rulesDiscovered: Int = 0
    @Published var mirrorTimeMinutes: Int = 0
    @Published var achievements: [Achievement] = []

    init() {
        loadStats()
    }

    func incrementReverseDays() {
        reverseDays += 1
        saveStats()
    }

    private func loadStats() {
        reverseDays = UserDefaults.standard.integer(forKey: "reverseDays")
        rulesDiscovered = UserDefaults.standard.integer(forKey: "rulesDiscovered")
        mirrorTimeMinutes = UserDefaults.standard.integer(forKey: "mirrorTimeMinutes")
    }

    func saveStats() {
        UserDefaults.standard.set(reverseDays, forKey: "reverseDays")
        UserDefaults.standard.set(rulesDiscovered, forKey: "rulesDiscovered")
        UserDefaults.standard.set(mirrorTimeMinutes, forKey: "mirrorTimeMinutes")
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let isUnlocked: Bool
}
import Foundation

/// Single source of truth for reverse rules (R1: previously duplicated in RuleManager and RulesView)
enum RuleData {
    static let allRules: [ReverseRule] = [
        ReverseRule(title: "Walk backwards to move forward", description: "Today, every step backward takes you further ahead."),
        ReverseRule(title: "Speak in reverse sentences", description: "Form your sentences in reverse word order."),
        ReverseRule(title: "Read everything backwards", description: "Start from the end of text to understand the beginning."),
        ReverseRule(title: "Use your non-dominant hand", description: "Switch hands for all tasks today."),
        ReverseRule(title: "Reverse your daily routine", description: "Do everything in opposite order today."),
        ReverseRule(title: "Think opposite", description: "For every thought, consider the reverse."),
        ReverseRule(title: "Write with your eyes closed", description: "Let your hand write without seeing."),
        ReverseRule(title: "Speak in questions only", description: "Only ask questions, never make statements."),
    ]

    /// R2: deterministic daily rotation (was randomElement() which broke "Today's Rule" semantics)
    static func ruleForToday(now: Date = Date()) -> ReverseRule {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: now) ?? 1
        let index = (dayOfYear - 1) % allRules.count
        return allRules[index]
    }
}

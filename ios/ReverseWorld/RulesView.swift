import SwiftUI

struct RulesView: View {
    @EnvironmentObject var ruleManager: RuleManager
    @State private var showAllRules = false

    let allRules = [
        ReverseRule(title: "Walk backwards to move forward", description: "Today, every step backward takes you further ahead."),
        ReverseRule(title: "Speak in reverse sentences", description: "Form your sentences in reverse word order."),
        ReverseRule(title: "Read everything backwards", description: "Start from the end of text to understand the beginning."),
        ReverseRule(title: "Use your non-dominant hand", description: "Switch hands for all tasks today."),
        ReverseRule(title: "Reverse your daily routine", description: "Do everything in opposite order today."),
        ReverseRule(title: "Think opposite", description: "For every thought, consider the reverse."),
        ReverseRule(title: "Write with your eyes closed", description: "Let your hand write without seeing."),
        ReverseRule(title: "Speak in questions only", description: "Only ask questions, never make statements."),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0a0a1a")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Today's Rule Card
                        VStack(spacing: 16) {
                            HStack {
                                Text("TODAY'S RULE")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.2))
                                    .clipShape(Capsule())

                                Spacer()

                                Text(countdownText)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }

                            VStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 40))
                                    .foregroundStyle(
                                        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )

                                Text(ruleManager.currentRule.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                Text(ruleManager.currentRule.description)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "1a0a2e"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                                )
                        )
                        .padding(.horizontal)

                        // Complete Button
                        Button {
                            completeRule()
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("I Did It!")
                            }
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)

                        // Rules Discovery
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("DISCOVERED RULES")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.cyan)

                                Spacer()

                                Text("\(ruleManager.ruleHistory.count)/\(allRules.count)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                                ForEach(allRules.prefix(6)) { rule in
                                    RuleMiniCard(rule: rule, isDiscovered: ruleManager.ruleHistory.contains { $0.id == rule.id })
                                }
                            }
                        }
                        .padding(.horizontal)

                        // All Rules Preview
                        VStack(alignment: .leading, spacing: 12) {
                            Button {
                                showAllRules.toggle()
                            } label: {
                                HStack {
                                    Text("ALL REVERSE RULES")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)

                                    Spacer()

                                    Image(systemName: showAllRules ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.purple)
                                }
                            }

                            if showAllRules {
                                ForEach(allRules) { rule in
                                    RuleRow(rule: rule)
                                }
                            }
                        }
                        .padding()
                        .background(Color(hex: "1a0a2e"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Reverse Rules")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var countdownText: String {
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.startOfDay(for: now + 86400)
        let diff = tomorrow.timeIntervalSince(now)

        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        return "\(hours)h \(minutes)m until new rule"
    }

    func completeRule() {
        withAnimation(.spring()) {
            ruleManager.completeCurrentRule()
        }
    }
}

struct RuleMiniCard: View {
    let rule: ReverseRule
    let isDiscovered: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isDiscovered ? "checkmark.circle.fill" : "questionmark.circle")
                .font(.title2)
                .foregroundColor(isDiscovered ? .green : .gray)

            Text(isDiscovered ? "Discovered" : "???")
                .font(.caption2)
                .foregroundColor(isDiscovered ? .white : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(hex: "0a0a1a"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RuleRow: View {
    let rule: ReverseRule

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(rule.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Text(rule.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: "0a0a1a"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    RulesView()
        .environmentObject(RuleManager())
        .environmentObject(StatsManager())
}
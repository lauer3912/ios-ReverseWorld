import SwiftUI

struct RulesView: View {
    @EnvironmentObject var ruleManager: RuleManager
    @State private var showAllRules = false
    @State private var showCompleteConfirm = false
    @State private var selectedRule: ReverseRule?  // R7: detail sheet
    @State private var showDetail = false

    // R1: use shared RuleData.allRules
    private var allRules: [ReverseRule] { RuleData.allRules }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Layout.sectionSpacing) {
                        todaysRuleCard
                        completeButton
                        rulesDiscovery
                        allRulesSection
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Reverse Rules")
            .navigationBarTitleDisplayMode(.inline)
            // R4: confirmation dialog before completing
            .confirmationDialog("Mark this rule as completed?", isPresented: $showCompleteConfirm, titleVisibility: .visible) {
                Button("I Did It!") {
                    ruleManager.completeCurrentRule()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Once marked, you can discover it in your collection.")
            }
            // R7: rule detail sheet
            .sheet(item: $selectedRule) { rule in
                RuleDetailView(rule: rule, isDiscovered: ruleManager.ruleHistory.contains { $0.id == rule.id })
            }
        }
    }

    private var todaysRuleCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("TODAY'S RULE")
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(Theme.Accent.warning)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Theme.Accent.warning.opacity(0.2))
                    .clipShape(Capsule())
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                TimelineView(.periodic(from: .now, by: 60)) { context in
                    Text(countdownText(at: context.date))
                        .font(.caption)
                        .foregroundColor(Theme.Text.tertiary)
                }
            }

            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .accessibilityHidden(true)

                Text(ruleManager.currentRule.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Text.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)

                Text(ruleManager.currentRule.description)
                    .font(.body)
                    .foregroundColor(Theme.Text.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.Background.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                )
        )
        .padding(.horizontal)
    }

    private var completeButton: some View {
        Button {
            showCompleteConfirm = true  // R4
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
            .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
        }
        .padding(.horizontal)
        .accessibilityLabel("Mark current rule as completed")
    }

    private var rulesDiscovery: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("DISCOVERED RULES")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                Text("\(ruleManager.ruleHistory.count)/\(allRules.count)")
                    .font(.caption)
                    .foregroundColor(Theme.Text.tertiary)
            }

            // R5: use adaptive min 110
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 12) {
                ForEach(allRules.prefix(6)) { rule in
                    Button {
                        selectedRule = rule  // R7
                    } label: {
                        RuleMiniCard(rule: rule, isDiscovered: ruleManager.ruleHistory.contains { $0.id == rule.id })
                    }
                    .accessibilityLabel(discoveredAccessibilityLabel(for: rule))
                }
            }
        }
        .padding(.horizontal)
    }

    private var allRulesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                showAllRules.toggle()
            } label: {
                HStack {
                    Text("ALL REVERSE RULES")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .accessibilityAddTraits(.isHeader)

                    Spacer()

                    Image(systemName: showAllRules ? "chevron.up" : "chevron.down")
                        .foregroundColor(.purple)
                }
            }
            .accessibilityLabel(showAllRules ? "Hide all rules" : "Show all rules")

            if showAllRules {
                ForEach(allRules) { rule in
                    Button {
                        selectedRule = rule  // R7
                    } label: {
                        RuleRow(rule: rule, isDiscovered: ruleManager.ruleHistory.contains { $0.id == rule.id })
                    }
                    .accessibilityLabel(rowAccessibilityLabel(for: rule))
                }
            }
        }
        .padding()
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
        .padding(.horizontal)
    }

    // R3: helper for TimelineView - takes the current date
    private func countdownText(at date: Date) -> String {
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: date + 86400)
        let diff = tomorrow.timeIntervalSince(date)
        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        return "\(hours)h \(minutes)m until new rule"
    }

    // R6: discovered accessibility label
    private func discoveredAccessibilityLabel(for rule: ReverseRule) -> String {
        let isDiscovered = ruleManager.ruleHistory.contains { $0.id == rule.id }
        if isDiscovered {
            return "Discovered rule: \(rule.title)"
        } else {
            return "Undiscovered rule, tap to view"
        }
    }

    private func rowAccessibilityLabel(for rule: ReverseRule) -> String {
        let isDiscovered = ruleManager.ruleHistory.contains { $0.id == rule.id }
        if isDiscovered {
            return "Discovered: \(rule.title). \(rule.description)"
        } else {
            return "Undiscovered rule, tap for preview"
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
                .foregroundColor(isDiscovered ? Theme.Accent.success : .gray)

            Text(isDiscovered ? "Discovered" : "???")
                .font(.caption2)
                .foregroundColor(isDiscovered ? Theme.Text.primary : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.Background.primary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RuleRow: View {
    let rule: ReverseRule
    let isDiscovered: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: isDiscovered ? "checkmark.circle.fill" : "questionmark.circle")
                .foregroundColor(isDiscovered ? Theme.Accent.success : .gray)
            VStack(alignment: .leading, spacing: 4) {
                Text(rule.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.Text.primary)
                Text(isDiscovered ? rule.description : "Tap to reveal this rule's challenge")
                    .font(.caption)
                    .foregroundColor(isDiscovered ? Theme.Text.secondary : Theme.Text.tertiary)
                    .italic(!isDiscovered)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Background.primary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RuleDetailView: View {
    let rule: ReverseRule
    let isDiscovered: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Image(systemName: isDiscovered ? "checkmark.seal.fill" : "questionmark.circle")
                        .font(.system(size: 80))
                        .foregroundColor(isDiscovered ? Theme.Accent.success : Theme.Text.tertiary)
                        .padding(.top, 40)

                    Text(rule.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Text.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text(isDiscovered ? rule.description : "Discover this rule by completing it to reveal its challenge.")
                        .font(.body)
                        .foregroundColor(Theme.Text.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle(isDiscovered ? "Rule" : "Mystery Rule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.Text.primary)
                }
            }
        }
    }
}

#Preview {
    RulesView()
        .environmentObject(RuleManager())
        .environmentObject(StatsManager())
}

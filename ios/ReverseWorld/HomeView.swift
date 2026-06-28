import SwiftUI

struct HomeView: View {
    @EnvironmentObject var ruleManager: RuleManager
    @EnvironmentObject var statsManager: StatsManager
    @State private var showGlowEffect = false  // H1: changed from rotation to opacity

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Layout.sectionSpacing) {
                        // H1: Header with opacity glow (was forced rotation animation)
                        VStack(spacing: 8) {
                            Text("REVERSE WORLD")
                                .font(.system(size: 28, weight: .bold, design: .rounded))  // 28 instead of 32 to prevent truncation
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .opacity(showGlowEffect ? 1.0 : 0.7)  // H1: opacity instead of rotation
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showGlowEffect)
                                .accessibilityAddTraits(.isHeader)
                                .lineLimit(1)  // explicit: keep on one line
                                .minimumScaleFactor(0.7)  // shrink if needed on narrow screens

                            Text("Flip Reality. Reverse Rules.")
                                .font(.subheadline)
                                .foregroundColor(Theme.Text.secondary)
                        }
                        .padding(.top, 20)

                        // Mirror Card
                        NavigationLink {
                            MirrorView()
                        } label: {
                            ReverseCard(
                                icon: "camera.viewfinder",
                                title: "Mirror World",
                                subtitle: "See yourself reversed",
                                gradient: [Color.purple, Color.blue]
                            )
                        }
                        .accessibilityLabel("Open Mirror World")

                        // Reverse Translator Card
                        NavigationLink {
                            TranslatorView()
                        } label: {
                            ReverseCard(
                                icon: "text.bubble.fill",
                                title: "Reverse Translator",
                                subtitle: "Transform words backwards",
                                gradient: [Color.green, Color.cyan]
                            )
                        }
                        .accessibilityLabel("Open Reverse Translator")

                        // Today's Rule Card (H4: added completion button)
                        todaysRuleCard

                        // Stats
                        HStack(spacing: 20) {
                            StatBox(
                                value: "\(statsManager.reverseDays)",
                                label: "Reverse Days",
                                icon: "calendar.badge.clock",
                                hint: statsManager.reverseDays == 0 ? "Start your first" : nil
                            )
                            StatBox(
                                value: "\(statsManager.rulesDiscovered)",
                                label: "Rules Found",
                                icon: "scroll.fill",
                                hint: statsManager.rulesDiscovered == 0 ? "Complete a rule" : nil
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear { showGlowEffect = true }
        .onDisappear { showGlowEffect = false }  // H5: stop animation when not visible
    }

    // H4: Today's rule card with completion button
    private var todaysRuleCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("TODAY'S REVERSE RULE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Accent.warning)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button {
                    ruleManager.refreshRule()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(Theme.Accent.warning)
                }
                .accessibilityLabel("Get a new rule")
            }

            VStack(spacing: 8) {
                Text(ruleManager.currentRule.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.Text.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)

                Text(ruleManager.currentRule.description)
                    .font(.caption)
                    .foregroundColor(Theme.Text.secondary)
                    .multilineTextAlignment(.center)
            }

            // H4: completion button
            Button {
                ruleManager.completeCurrentRule()
                statsManager.unlockAchievement(name: "First Rule", icon: "scroll.fill")
            } label: {
                Text("I Did It!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(colors: [Theme.Accent.warning, Color.orange], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
            }
            .accessibilityLabel("Mark current rule as completed")
        }
        .padding(Theme.Layout.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                .fill(Theme.Background.card)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                        .stroke(Theme.Accent.warning.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

struct ReverseCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Theme.Text.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Theme.Text.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Theme.Text.disabled)
        }
        .padding(Theme.Layout.cardPadding)
        .background(
            LinearGradient(colors: [Theme.Background.card, Theme.Background.primary], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                .stroke(LinearGradient(colors: gradient.map { $0.opacity(0.5) }, startPoint: .leading, endPoint: .trailing), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    var hint: String? = nil  // R2-12: 0-value hint

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Theme.Accent.primary)
                .accessibilityHidden(true)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Theme.Text.primary)
                .accessibilityLabel("\(label): \(value)")
            Text(label)
                .font(.caption)
                .foregroundColor(Theme.Text.secondary)
            if let hint = hint {
                Text(hint)
                    .font(.caption2)
                    .italic()
                    .foregroundColor(Theme.Accent.warning)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
    }
}

#Preview {
    HomeView()
        .environmentObject(RuleManager())
        .environmentObject(StatsManager())
}

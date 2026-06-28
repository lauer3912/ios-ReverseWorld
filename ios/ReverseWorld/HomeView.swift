import SwiftUI

/// Home dashboard — R6 redesigned to showcase 3 core content categories
/// (Visual / Audio / Real Event) per 佛老爷 22:13 feedback
struct HomeView: View {
    @EnvironmentObject var ruleManager: RuleManager
    @EnvironmentObject var statsManager: StatsManager
    @State private var showGlowEffect = false
    var onProfileTap: (() -> Void)? = nil

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad: skip NavigationStack (per #44 #5), NavigationSplitView provides sidebar
                ZStack {
                    Theme.Background.primary
                        .ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: Theme.Layout.sectionSpacing) {
                            header
                            todaysRuleCard
                            coreContentSection
                            videoCoreContent
                            discoverTeaser
                            statsRow
                            profileButton
                        }
                        .padding(.bottom, 40)
                    }
                }
            } else {
                // iPhone: NavigationStack for navigation title
                NavigationStack {
                    ZStack {
                        Theme.Background.primary
                            .ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: Theme.Layout.sectionSpacing) {
                                header
                                todaysRuleCard
                                coreContentSection
                                videoCoreContent
                                discoverTeaser
                                statsRow
                                profileButton
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .onAppear { showGlowEffect = true }
        .onDisappear { showGlowEffect = false }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(L10n.homeTitle)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(showGlowEffect ? 1.0 : 0.7)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showGlowEffect)
                .accessibilityAddTraits(.isHeader)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(L10n.homeTagline)
                .font(.subheadline)
                .foregroundColor(Theme.Text.secondary)
        }
        .padding(.top, 20)
    }

    private var todaysRuleCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text(L10n.homeTodayRuleLabel)
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

            Button {
                ruleManager.completeCurrentRule()
                statsManager.unlockAchievement(name: "First Rule", icon: "scroll.fill")
            } label: {
                Text(L10n.homeDidIt)
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

    /// R6: 3 core content cards - the actual core of the product
    private var coreContentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("EXPLORE REVERSAL")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Accent.primary)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
            }
            .padding(.horizontal)

            // 1. Visual (Mirror) — with effect
            NavigationLink {
                MirrorView()
            } label: {
                CoreContentCard(
                    icon: "camera.viewfinder",
                    title: "Visual Reversal",
                    subtitle: "Mirror the world. Apply effects.",
                    gradient: [Color.purple, Color.blue],
                    badge: "VISUAL"
                )
            }
            .accessibilityLabel("Open Visual Reversal: Mirror World with effects")

            // 2. Audio (Voice Inversion) — NEW core
            NavigationLink {
                VoiceInversionView()
            } label: {
                CoreContentCard(
                    icon: "waveform.badge.magnifyingglass",
                    title: "Sound Secrets",
                    subtitle: "Record. Reverse. Listen for hidden meaning.",
                    gradient: [Color.cyan, Color.indigo],
                    badge: "AUDIO"
                )
            }
            .accessibilityLabel("Open Sound Secrets: Voice Inversion")

            // 3. Text (Translate) — kept
            NavigationLink {
                TranslatorView()
            } label: {
                CoreContentCard(
                    icon: "text.bubble.fill",
                    title: "Text Reverse",
                    subtitle: "Transform words backwards.",
                    gradient: [Color.green, Color.mint],
                    badge: "TEXT"
                )
            }
            .accessibilityLabel("Open Text Reverse: Reverse Translator")
        }
    }

    /// R7: 视频反转 card (Video reversal core content)
    @ViewBuilder
    private var videoCoreContent: some View {
        NavigationLink {
            VideoInversionView()
        } label: {
            CoreContentCard(
                icon: "video.bubble.left",
                title: "Real Event Reversal",
                subtitle: "Record video. Play it backwards.",
                gradient: [Color.orange, Color.red],
                badge: "VIDEO"
            )
        }
        .accessibilityLabel("Open Real Event Reversal: Video inversion")
    }

    /// R7: Discover teaser
    private var discoverTeaser: some View {
        NavigationLink {
            DiscoverView()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(LinearGradient(colors: [.yellow, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Discover Real Events")
                        .font(.headline)
                        .foregroundColor(Theme.Text.primary)
                    Text("Architecture, music, DNA, butterflies — all reverse.")
                        .font(.caption)
                        .foregroundColor(Theme.Text.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Text.disabled)
            }
            .padding(Theme.Layout.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                    .fill(Theme.Background.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                            .stroke(LinearGradient(colors: [.yellow.opacity(0.3), .pink.opacity(0.3)], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }

    /// Profile button (R7: moved out of tab bar)
    private var profileButton: some View {
        Button {
            onProfileTap?()
        } label: {
            HStack {
                Image(systemName: "person.crop.circle")
                    .font(.title3)
                Text(L10n.profileTitle)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundColor(Theme.Text.secondary)
            .padding()
            .background(Theme.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
            .padding(.horizontal)
        }
    }

    private var statsRow: some View {
        HStack(spacing: 16) {
            StatBox(
                value: "\(statsManager.reverseDays)",
                label: L10n.statReverseDays,
                icon: "calendar.badge.clock",
                hint: statsManager.reverseDays == 0 ? L10n.statStartYourFirst : nil
            )
            StatBox(
                value: "\(statsManager.rulesDiscovered)",
                label: L10n.statRulesFound,
                icon: "scroll.fill",
                hint: statsManager.rulesDiscovered == 0 ? L10n.statCompleteARule : nil
            )
        }
        .padding(.horizontal)
    }
}

struct CoreContentCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let badge: String

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 56, height: 56)
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(badge)
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.Accent.primary)
                        .clipShape(Capsule())
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Theme.Text.primary)
                }
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Theme.Text.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Theme.Text.disabled)
        }
        .padding(Theme.Layout.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                .fill(Theme.Background.card)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                        .stroke(LinearGradient(colors: gradient.map { $0.opacity(0.4) }, startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    var hint: String? = nil

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

import SwiftUI
import StoreKit

struct ProfileView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var ruleManager: RuleManager
    @EnvironmentObject var premiumManager: PremiumManager
    @Environment(\.openURL) private var openURL
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = false
    @AppStorage("username") private var username = ""  // P5: empty default, force user to set
    @State private var showEditName = false
    @State private var showRestoreAlert = false
    @State private var restoreMessage = ""

    // P9: Achievements now come from StatsManager (persisted)
    private var achievements: [Achievement] {
        statsManager.achievements
    }

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad: skip NavigationStack (per #44 #5)
                ZStack {
                    Theme.Background.primary.ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: Theme.Layout.sectionSpacing) {
                            profileHeader
                            statsRow
                            achievementsSection
                            premiumSection
                            settingsSection
                            Text("ReverseWorldGo v\(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                                .font(.caption)
                                .foregroundColor(Theme.Text.disabled)
                                .padding(.top, 20)
                        }
                        .padding(.bottom, 40)
                    }
                }
            } else {
                // iPhone: NavigationStack for navigation title (when shown via sheet)
                NavigationStack {
                    ZStack {
                        Theme.Background.primary.ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: Theme.Layout.sectionSpacing) {
                                profileHeader
                                statsRow
                                achievementsSection
                                premiumSection
                                settingsSection
                                Text("ReverseWorldGo v\(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                                    .font(.caption)
                                    .foregroundColor(Theme.Text.disabled)
                                    .padding(.top, 20)
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .navigationTitle(L10n.profileTitle)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .alert(L10n.profileEditNameTitle, isPresented: $showEditName) {
            TextField(L10n.profileNamePrompt, text: $username)
                .textInputAutocapitalization(.never)
            Button(L10n.save) { validateAndSaveName() }
                .disabled(!isUsernameValid)
            Button(L10n.cancel, role: .cancel) {}
        } message: {
            Text(L10n.profileNameMessage)
        }
        .alert(L10n.profileRestorePurchases, isPresented: $showRestoreAlert) {
            Button(L10n.ok, role: .cancel) {}
        } message: {
            Text(restoreMessage)
        }
    }

    // MARK: - Sub-views

    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Avatar (P10: removed scaleEffect(x: -1) which made the whole icon unreadable)
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            .accessibilityLabel("Profile avatar")

            VStack(spacing: 4) {
                Button {
                    showEditName = true
                } label: {
                    HStack {
                        Text(username.isEmpty ? L10n.profileSetName : "@\(username)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(username.isEmpty ? Theme.Text.tertiary : Theme.Text.primary)
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(Theme.Text.secondary)
                    }
                }
                .accessibilityLabel(username.isEmpty ? L10n.profileSetName : "Edit username")

                // P11: dynamic subtitle reflecting actual usage
                Text(profileSubtitle)
                    .font(.caption)
                    .foregroundColor(Theme.Text.tertiary)
            }
        }
        .padding(.top, 20)
    }

    private var profileSubtitle: String {
        if statsManager.reverseDays == 0 {
            return L10n.profileStartReverse
        } else if statsManager.reverseDays == 1 {
            return L10n.profileDay1
        } else {
            return "\(statsManager.reverseDays) days reversing"
        }
    }

    private var statsRow: some View {
        HStack(spacing: 16) {
            ProfileStatCard(value: "\(statsManager.reverseDays)", label: L10n.statReverseDays, icon: "calendar.badge.clock", color: .orange)
            ProfileStatCard(value: "\(ruleManager.ruleHistory.count)", label: L10n.profileRulesDone, icon: "scroll.fill", color: .yellow)
            ProfileStatCard(value: "\(statsManager.mirrorTimeMinutes)", label: L10n.profileMirrorMin, icon: "camera.viewfinder", color: .purple)
        }
        .padding(.horizontal)
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.profileAchievements)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Theme.Accent.warning)
                .padding(.horizontal)

            if achievements.isEmpty {
                Text(L10n.profileAchievementsEmpty)
                    .font(.caption)
                    .foregroundColor(Theme.Text.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 12) {
                    ForEach(achievements) { achievement in
                        AchievementBadge(name: achievement.name, icon: achievement.icon, level: achievement.isUnlocked ? 3 : 0)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var premiumSection: some View {
        PremiumSection(
            onRestore: {
                Task {
                    await premiumManager.restorePurchases()
                    // R2-9 fix: use restoreError from PremiumManager for proper feedback
                    if premiumManager.isPremium {
                        restoreMessage = L10n.restoreSuccess
                    } else if let error = premiumManager.restoreError {
                        restoreMessage = error
                    } else {
                        restoreMessage = L10n.restoreNotFound
                    }
                    showRestoreAlert = true
                }
            }
        )
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.profileSettings)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .padding(.horizontal)

            VStack(spacing: 0) {
                SettingsRow(icon: "moon.fill", title: L10n.profileDarkMode, color: .purple) {
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                        .accessibilityLabel("Dark mode toggle")
                }

                Divider().background(Color.white.opacity(0.1))

                SettingsRow(icon: "bell.fill", title: L10n.profileDailyReminder, color: .yellow) {
                    Toggle("", isOn: $isNotificationsEnabled)
                        .labelsHidden()
                        .accessibilityLabel("Daily reminder toggle")
                        .onChange(of: isNotificationsEnabled) { _, newValue in
                            if newValue {
                                ReverseNotificationService.shared.requestAuthorization { granted in
                                    if granted {
                                        ReverseNotificationService.shared.scheduleDailyRuleReminder()
                                    } else {
                                        // Reset toggle if user denied
                                        DispatchQueue.main.async {
                                            isNotificationsEnabled = false
                                        }
                                    }
                                }
                            } else {
                                ReverseNotificationService.shared.cancelNotification(identifier: "daily_rule")
                            }
                        }
                }

                Divider().background(Color.white.opacity(0.1))

                NavigationLink {
                    PrivacyPolicyView()
                } label: {
                    SettingsRow(icon: "hand.raised.fill", title: L10n.profilePrivacyPolicy, color: .blue, showChevron: true) {}
                }
                .accessibilityLabel("Privacy policy")

                Divider().background(Color.white.opacity(0.1))

                Button {
                    if let url = URL(string: "mailto:support@techidaily.com") {
                        openURL(url)  // P12: use Environment openURL instead of force-unwrap Link
                    }
                } label: {
                    SettingsRow(icon: "envelope.fill", title: L10n.profileContactUs, color: .green, showChevron: true) {}
                }
                .accessibilityLabel("Contact us via email")

                Divider().background(Color.white.opacity(0.1))

                NavigationLink {
                    AboutView()
                } label: {
                    SettingsRow(icon: "info.circle.fill", title: L10n.profileAbout, color: .orange, showChevron: true) {}
                }
                .accessibilityLabel("About ReverseWorldGo")
            }
            .background(Theme.Background.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
            .padding(.horizontal)
        }
    }

    // MARK: - Helpers

    private var isUsernameValid: Bool {
        let trimmed = username.trimmingCharacters(in: .whitespaces)
        return trimmed.count >= 3 && trimmed.count <= 20
    }

    private func validateAndSaveName() {
        let trimmed = username.trimmingCharacters(in: .whitespaces)
        if trimmed.count >= 3 && trimmed.count <= 20 {
            username = trimmed
        } else {
            username = ""
        }
    }
}

struct ProfileStatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .accessibilityHidden(true)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Theme.Text.primary)
                .accessibilityLabel("\(label): \(value)")
            Text(label)
                .font(.caption2)
                .foregroundColor(Theme.Text.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
    }
}

struct AchievementBadge: View {
    let name: String
    let icon: String
    let level: Int

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(colors: level > 0 ? [.yellow, .orange] : [.gray.opacity(0.3), .gray.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(level > 0 ? .black : .white.opacity(0.5))
            }
            .accessibilityLabel(level > 0 ? "Unlocked: \(name)" : "Locked: \(name)")

            Text(name)
                .font(.caption2)
                .foregroundColor(level > 0 ? Theme.Text.primary : Theme.Text.tertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
    }
}

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    var showChevron: Bool = false
    @ViewBuilder let trailing: () -> Content

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(color)
                .frame(width: 30)
                .accessibilityHidden(true)
            Text(title)
                .font(.body)
                .foregroundColor(Theme.Text.primary)
            Spacer()
            trailing()
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Theme.Text.disabled)
            }
        }
        .padding()
    }
}

struct PrivacyPolicyView: View {
    // P2: WebView loads the live policy so app and website stay in sync
    var body: some View {
        ZStack {
            Theme.Background.primary
                .ignoresSafeArea()

            if let url = URL(string: "https://lauer3912.github.io/ios-ReverseWorld/PrivacyPolicy.html") {
                PrivacyPolicyWebView(url: url)
                    .ignoresSafeArea(edges: .bottom)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    Text("Privacy Policy URL is invalid.")
                        .foregroundColor(Theme.Text.primary)
                }
            }
        }
        .navigationTitle(L10n.profilePrivacyPolicy)
        .navigationBarTitleDisplayMode(.inline)
    }
}

import WebKit
struct PrivacyPolicyWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
}

struct AboutView: View {
    // P1: derive version from Bundle.main
    var body: some View {
        ZStack {
            Theme.Background.primary
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .accessibilityHidden(true)

                Text(L10n.appName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Text.primary)

                Text("Version \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                    .foregroundColor(Theme.Text.tertiary)

                Text(L10n.aboutTagline)
                    .font(.body)
                    .foregroundColor(Theme.Text.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 60)
        }
        .navigationTitle(L10n.profileAbout)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Premium Section

struct PremiumSection: View {
    @EnvironmentObject var premiumManager: PremiumManager  // P3: use shared via Environment
    @State private var showPaywall = false
    let onRestore: () -> Void  // P7: restore action from parent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(L10n.profilePremium)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Accent.warning)
                if premiumManager.isPremium {
                    Text(L10n.profilePremiumActive)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Accent.success)
                }
                Spacer()
            }
            .padding(.horizontal)

            Button {
                if !premiumManager.isPremium {
                    showPaywall = true
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: premiumManager.isPremium ? "checkmark.seal.fill" : "crown.fill")
                        .font(.title2)
                        .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .leading, endPoint: .trailing))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(premiumManager.isPremium ? L10n.profilePremiumActiveTitle : L10n.paywallTitle)
                            .font(.headline)
                            .foregroundColor(Theme.Text.primary)
                        Text(premiumManager.isPremium ? L10n.profilePremiumDescriptionActive : L10n.profilePremiumDescription)
                            .font(.caption)
                            .foregroundColor(Theme.Text.secondary)
                    }
                    Spacer()
                    if !premiumManager.isPremium {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.Text.disabled)
                    }
                }
                .padding()
                .background(
                    LinearGradient(colors: premiumManager.isPremium ?
                        [Theme.Background.card, Theme.Background.primary] :
                        [Theme.Background.elevated, Theme.Background.card], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Card.cornerRadius)
                        .stroke(LinearGradient(colors: [.yellow.opacity(0.5), .orange.opacity(0.5)], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                )
            }
            .padding(.horizontal)
            .accessibilityLabel(premiumManager.isPremium ? "Premium active" : "Unlock premium")

            // P7: Restore Purchases always visible (Apple 3.1.1 requirement)
            if !premiumManager.isPremium {
                Button {
                    onRestore()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise.circle")
                        Text(L10n.profileRestorePurchases)
                    }
                    .font(.caption)
                    .foregroundColor(Theme.Text.secondary)
                }
                .padding(.horizontal)
                .accessibilityLabel("Restore previous purchases")
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(isPresented: $showPaywall)
                .environmentObject(premiumManager)  // P13: pass once
        }
    }
}

struct PaywallView: View {
    @EnvironmentObject var premiumManager: PremiumManager
    @Binding var isPresented: Bool
    @State private var purchasing = false
    @State private var purchaseError: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary.ignoresSafeArea()

                VStack(spacing: Theme.Layout.sectionSpacing) {
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .accessibilityHidden(true)
                        Text(L10n.paywallTitle)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Text.primary)
                        Text("Get 7-day free trial, then \(premiumManager.displayPrice)/month")
                            .font(.subheadline)
                            .foregroundColor(Theme.Text.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 40)

                    VStack(alignment: .leading, spacing: 12) {
                        PremiumFeatureRow(icon: "camera.viewfinder", title: L10n.paywallFeatureFilters)
                        PremiumFeatureRow(icon: "text.bubble.fill", title: L10n.paywallFeatureTranslator)
                        PremiumFeatureRow(icon: "scroll.fill", title: L10n.paywallFeatureJournal)
                        PremiumFeatureRow(icon: "bell.fill", title: L10n.paywallFeatureRules)
                        PremiumFeatureRow(icon: "xmark.circle.fill", title: L10n.paywallFeatureNoAds)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Spacer()

                    VStack(spacing: 12) {
                        if let yearly = premiumManager.yearlyProduct {
                            PurchaseButton(
                                title: L10n.paywallYearly,
                                subtitle: "Best value • \(premiumManager.yearlyDisplayPrice)/year",
                                product: yearly,
                                isPopular: true,
                                purchasing: $purchasing,
                                onPurchase: { purchase(product: yearly) }
                            )
                        } else {
                            PurchaseButton(
                                title: L10n.paywallYearly,
                                subtitle: L10n.paywallYearlyFallback,
                                product: nil,
                                isPopular: true,
                                purchasing: $purchasing,
                                onPurchase: nil
                            )
                        }

                        if let monthly = premiumManager.monthlyProduct {
                            PurchaseButton(
                                title: L10n.paywallMonthly,
                                subtitle: premiumManager.displayPrice + "/month",
                                product: monthly,
                                isPopular: false,
                                purchasing: $purchasing,
                                onPurchase: { purchase(product: monthly) }
                            )
                        }
                    }
                    .padding(.horizontal)

                    Button {
                        Task {
                            await premiumManager.restorePurchases()
                            isPresented = premiumManager.isPremium
                        }
                    } label: {
                        Text(L10n.profileRestorePurchases)
                            .font(.caption)
                            .foregroundColor(Theme.Text.secondary)
                    }
                    .padding(.bottom)
                    .accessibilityLabel("Restore previous purchases")

                    if let error = purchaseError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(Theme.Accent.danger)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.paywallClose) { isPresented = false }
                        .foregroundColor(Theme.Text.primary)
                }
            }
        }
    }

    private func purchase(product: Product) {
        purchasing = true
        purchaseError = nil
        Task {
            do {
                let success = try await premiumManager.purchase(product)
                if success {
                    isPresented = false
                } else {
                    purchaseError = L10n.purchaseCancelled
                }
            } catch {
                AppLog.premium.error("Purchase failed: \(error.localizedDescription, privacy: .public)")
                purchaseError = error.localizedDescription
            }
            purchasing = false
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Theme.Accent.warning)
                .frame(width: 24)
                .accessibilityHidden(true)
            Text(title)
                .font(.subheadline)
                .foregroundColor(Theme.Text.primary)
            Spacer()
        }
    }
}

struct PurchaseButton: View {
    let title: String
    let subtitle: String
    let product: Product?
    let isPopular: Bool
    @Binding var purchasing: Bool
    let onPurchase: (() -> Void)?

    var body: some View {
        Button {
            onPurchase?()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(isPopular ? .black : Theme.Text.primary)
                        if isPopular {
                            Text(L10n.paywallPopular)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.yellow)
                                .clipShape(Capsule())
                        }
                    }
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(isPopular ? .black.opacity(0.8) : Theme.Text.secondary)
                }
                Spacer()
                if purchasing {
                    ProgressView().tint(isPopular ? .black : .white)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(isPopular ? .black : Theme.Text.secondary)
                }
            }
            .padding()
            .background(
                LinearGradient(colors: isPopular ?
                    [Color.yellow, Color.orange] :
                    [Theme.Background.card, Theme.Background.primary], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(StatsManager())
        .environmentObject(RuleManager())
        .environmentObject(PremiumManager())
}

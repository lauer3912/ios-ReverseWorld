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
        NavigationStack {
            ZStack {
                Theme.Background.primary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Layout.sectionSpacing) {
                        // Profile Header
                        profileHeader

                        // Stats Cards
                        statsRow

                        // Achievements
                        achievementsSection

                        // Premium Section
                        premiumSection

                        // Settings Section
                        settingsSection

                        // Version (P1: derive from Bundle.main)
                        Text("ReverseWorldGo v\(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                            .font(.caption)
                            .foregroundColor(Theme.Text.disabled)
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit Username", isPresented: $showEditName) {
                TextField("Username (3-20 chars)", text: $username)
                    .textInputAutocapitalization(.never)
                Button("Save") { validateAndSaveName() }
                    .disabled(!isUsernameValid)
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Pick a name shown in your profile and shared reverse content.")
            }
            .alert("Restore Purchases", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(restoreMessage)
            }
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
                        Text(username.isEmpty ? "Set your name" : "@\(username)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(username.isEmpty ? Theme.Text.tertiary : Theme.Text.primary)
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(Theme.Text.secondary)
                    }
                }
                .accessibilityLabel(username.isEmpty ? "Set your name" : "Edit username")

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
            return "Reversing starts today"
        } else if statsManager.reverseDays == 1 {
            return "Day 1 of reversing"
        } else {
            return "\(statsManager.reverseDays) days reversing"
        }
    }

    private var statsRow: some View {
        HStack(spacing: 16) {
            ProfileStatCard(value: "\(statsManager.reverseDays)", label: "Reverse Days", icon: "calendar.badge.clock", color: .orange)
            ProfileStatCard(value: "\(ruleManager.ruleHistory.count)", label: "Rules Done", icon: "scroll.fill", color: .yellow)
            ProfileStatCard(value: "\(statsManager.mirrorTimeMinutes)", label: "Mirror Min", icon: "camera.viewfinder", color: .purple)
        }
        .padding(.horizontal)
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ACHIEVEMENTS")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Theme.Accent.warning)
                .padding(.horizontal)

            if achievements.isEmpty {
                Text("Complete rules to unlock achievements")
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
                    restoreMessage = premiumManager.isPremium
                        ? "✅ Premium restored successfully"
                        : "No previous purchases found for this Apple ID"
                    showRestoreAlert = true
                }
            }
        )
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SETTINGS")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
                .padding(.horizontal)

            VStack(spacing: 0) {
                SettingsRow(icon: "moon.fill", title: "Dark Mode", color: .purple) {
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                        .accessibilityLabel("Dark mode toggle")
                }

                Divider().background(Color.white.opacity(0.1))

                SettingsRow(icon: "bell.fill", title: "Daily Reminder", color: .yellow) {
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
                    SettingsRow(icon: "hand.raised.fill", title: "Privacy Policy", color: .blue, showChevron: true) {}
                }
                .accessibilityLabel("Privacy policy")

                Divider().background(Color.white.opacity(0.1))

                Button {
                    if let url = URL(string: "mailto:support@techidaily.com") {
                        openURL(url)  // P12: use Environment openURL instead of force-unwrap Link
                    }
                } label: {
                    SettingsRow(icon: "envelope.fill", title: "Contact Us", color: .green, showChevron: true) {}
                }
                .accessibilityLabel("Contact us via email")

                Divider().background(Color.white.opacity(0.1))

                NavigationLink {
                    AboutView()
                } label: {
                    SettingsRow(icon: "info.circle.fill", title: "About", color: .orange, showChevron: true) {}
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
        .navigationTitle("Privacy Policy")
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

                Text("ReverseWorldGo")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Text.primary)

                Text("Version \(Bundle.main.appVersion) (\(Bundle.main.buildNumber))")
                    .foregroundColor(Theme.Text.tertiary)

                Text("Flip reality. Reverse rules. Experience the world differently.")
                    .font(.body)
                    .foregroundColor(Theme.Text.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 60)
        }
        .navigationTitle("About")
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
                Text("PREMIUM")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Accent.warning)
                if premiumManager.isPremium {
                    Text("· ACTIVE")
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
                        Text(premiumManager.isPremium ? "Premium Active" : "Unlock Premium")
                            .font(.headline)
                            .foregroundColor(Theme.Text.primary)
                        Text(premiumManager.isPremium ? "All filters, ad-free, unlimited entries" : "Get 7-day free trial")
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
                        Text("Restore Purchases")
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
                        Text("Unlock Premium")
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
                        PremiumFeatureRow(icon: "camera.viewfinder", title: "All mirror filters unlocked")
                        PremiumFeatureRow(icon: "text.bubble.fill", title: "All reverse translator modes")
                        PremiumFeatureRow(icon: "scroll.fill", title: "Unlimited reverse journal entries")
                        PremiumFeatureRow(icon: "bell.fill", title: "Priority rule updates")
                        PremiumFeatureRow(icon: "xmark.circle.fill", title: "Ad-free experience")
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    Spacer()

                    VStack(spacing: 12) {
                        if let yearly = premiumManager.yearlyProduct {
                            PurchaseButton(
                                title: "Yearly",
                                subtitle: "Best value • \(premiumManager.yearlyDisplayPrice)/year",
                                product: yearly,
                                isPopular: true,
                                purchasing: $purchasing,
                                onPurchase: { purchase(product: yearly) }
                            )
                        } else {
                            PurchaseButton(
                                title: "Yearly",
                                subtitle: "Best value • $29.99/year",
                                product: nil,
                                isPopular: true,
                                purchasing: $purchasing,
                                onPurchase: nil
                            )
                        }

                        if let monthly = premiumManager.monthlyProduct {
                            PurchaseButton(
                                title: "Monthly",
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
                        Text("Restore Purchases")
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
                    Button("Close") { isPresented = false }
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
                    purchaseError = "Purchase cancelled"
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
                            Text("POPULAR")
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

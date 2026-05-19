import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var statsManager: StatsManager
    @EnvironmentObject var ruleManager: RuleManager
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = false
    @AppStorage("username") private var username = "ReverseKing"
    @State private var showEditName = false

    let achievements = [
        ("7 Day Streak", "flame.fill", 7),
        ("Mirror Master", "camera.viewfinder", 1),
        ("Rule Discoverer", "scroll.fill", 3),
        ("Word Reverser", "text.bubble.fill", 1),
        ("Reverse Legend", "star.fill", 5),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0a0a1a")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Avatar with mirror effect
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .frame(width: 100, height: 100)

                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)

                                // Mirror reflection effect
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .frame(width: 30, height: 30)
                                    .offset(x: 35, y: -35)
                                    .mask(
                                        Circle()
                                            .frame(width: 100, height: 100)
                                            .scaleEffect(x: -1, y: 1)
                                    )
                            }
                            .scaleEffect(x: -1, y: 1) // Mirror the whole avatar

                            VStack(spacing: 4) {
                                Button {
                                    showEditName = true
                                } label: {
                                    HStack {
                                        Text("@\(username)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Image(systemName: "pencil")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                }

                                Text("Reversing since day one")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding(.top, 20)

                        // Stats Cards
                        HStack(spacing: 16) {
                            ProfileStatCard(value: "\(statsManager.reverseDays)", label: "Reverse Days", icon: "calendar.badge.clock", color: .orange)
                            ProfileStatCard(value: "\(ruleManager.ruleHistory.count)", label: "Rules Done", icon: "scroll.fill", color: .yellow)
                            ProfileStatCard(value: "\(statsManager.mirrorTimeMinutes)", label: "Mirror Min", icon: "camera.viewfinder", color: .purple)
                        }
                        .padding(.horizontal)

                        // Achievements
                        VStack(alignment: .leading, spacing: 16) {
                            Text("ACHIEVEMENTS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                                .padding(.horizontal)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                                ForEach(achievements, id: \.0) { achievement in
                                    AchievementBadge(name: achievement.0, icon: achievement.1, level: achievement.2)
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Settings Section
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
                                }

                                Divider().background(Color.white.opacity(0.1))

                                SettingsRow(icon: "bell.fill", title: "Daily Reminder", color: .yellow) {
                                    Toggle("", isOn: $isNotificationsEnabled)
                                        .labelsHidden()
                                        .onChange(of: isNotificationsEnabled) { _, newValue in
                                            if newValue {
                                                ReverseNotificationService.shared.requestAuthorization { granted in
                                                    if granted {
                                                        ReverseNotificationService.shared.scheduleDailyRuleReminder()
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

                                Divider().background(Color.white.opacity(0.1))

                                Link(destination: URL(string: "mailto:support@techidaily.com")!) {
                                    SettingsRow(icon: "envelope.fill", title: "Contact Us", color: .green, showChevron: true) {}
                                }

                                Divider().background(Color.white.opacity(0.1))

                                NavigationLink {
                                    AboutView()
                                } label: {
                                    SettingsRow(icon: "info.circle.fill", title: "About", color: .orange, showChevron: true) {}
                                }
                            }
                            .background(Color(hex: "1a0a2e"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }

                        // Version
                        Text("ReverseWorld v1.0.0")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit Username", isPresented: $showEditName) {
                TextField("Username", text: $username)
                Button("Save") {}
                Button("Cancel", role: .cancel) {}
            }
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
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(hex: "1a0a2e"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.black)
            }

            Text(name)
                .font(.caption2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            HStack(spacing: 2) {
                ForEach(0..<level, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 6))
                        .foregroundColor(.yellow)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(hex: "1a0a2e"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
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

            Text(title)
                .font(.body)
                .foregroundColor(.white)

            Spacer()

            trailing()

            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .padding()
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color(hex: "0a0a1a")
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Last updated: May 1, 2026")
                        .foregroundColor(.secondary)

                    Text("""
                    ReverseWorld is committed to protecting your privacy. This app does not collect any personal data.

                    **Data Storage**
                    - All data is stored locally on your device
                    - We do not use any cloud services
                    - No account or login required

                    **Permissions**
                    - Camera: Used only for mirror mode feature
                    - Photo Library: Used to save your creations

                    **Third Parties**
                    - We do not share any data with third parties

                    **Contact**
                    support@techidaily.com
                    """)
                    .foregroundColor(.white.opacity(0.9))
                }
                .padding()
            }
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ZStack {
            Color(hex: "0a0a1a")
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )

                Text("ReverseWorld")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Version 1.0.0")
                    .foregroundColor(.white.opacity(0.5))

                Text("Flip reality. Reverse rules. Experience the world differently.")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
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

#Preview {
    ProfileView()
        .environmentObject(StatsManager())
        .environmentObject(RuleManager())
}
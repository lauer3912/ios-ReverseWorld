import SwiftUI

struct HomeView: View {
    @EnvironmentObject var ruleManager: RuleManager
    @EnvironmentObject var statsManager: StatsManager
    @State private var showReverseEffect = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0a0a1a")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Header with cosmic effect
                        VStack(spacing: 8) {
                            Text("REVERSE WORLD")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .rotationEffect(.degrees(showReverseEffect ? 180 : 0))
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: showReverseEffect)

                            Text("Flip Reality. Reverse Rules.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.6))
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

                        // Today's Rule Card
                        VStack(spacing: 16) {
                            HStack {
                                Text("TODAY'S REVERSE RULE")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                                Spacer()
                                Button {
                                    ruleManager.refreshRule()
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .foregroundColor(.yellow)
                                }
                            }

                            VStack(spacing: 8) {
                                Text(ruleManager.currentRule.title)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)

                                Text(ruleManager.currentRule.description)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "1a0a2e"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal)

                        // Stats
                        HStack(spacing: 20) {
                            StatBox(value: "\(statsManager.reverseDays)", label: "Reverse Days", icon: "calendar.badge.clock")
                            StatBox(value: "\(statsManager.rulesDiscovered)", label: "Rules Found", icon: "scroll.fill")
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            showReverseEffect = true
        }
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

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(20)
        .background(
            LinearGradient(colors: [Color(hex: "1a0a2e"), Color(hex: "0a0a1a")], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(LinearGradient(colors: gradient.map { $0.opacity(0.5) }, startPoint: .leading, endPoint: .trailing), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "1a0a2e"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    HomeView()
        .environmentObject(RuleManager())
        .environmentObject(StatsManager())
}
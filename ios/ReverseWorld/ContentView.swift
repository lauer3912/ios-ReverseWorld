import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            MirrorView()
                .tabItem {
                    Label("Mirror", systemImage: "camera.fill")
                }
                .tag(Tab.mirror)

            TranslatorView()
                .tabItem {
                    Label("Translate", systemImage: "text.bubble.fill")
                }
                .tag(Tab.translate)

            RulesView()
                .tabItem {
                    Label("Rules", systemImage: "scroll.fill")
                }
                .tag(Tab.rules)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(Color(hex: "7C6AFF"))
    }
}

enum Tab: String, CaseIterable {
    case home, mirror, translate, rules, profile
}

#Preview {
    ContentView()
        .environmentObject(RuleManager())
        .environmentObject(StatsManager())
}
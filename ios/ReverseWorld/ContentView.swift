import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = ContentView.initialTabFromLaunchArgs()

    static func initialTabFromLaunchArgs() -> Tab {
        let args = CommandLine.arguments
        // Numeric form: -initialTab N (0..4)
        if let i = args.firstIndex(of: "-initialTab"),
           i + 1 < args.count,
           let n = Int(args[i + 1]),
           n >= 0, n < Tab.allCases.count {
            return Tab.allCases[n]
        }
        // Legacy string form: -initialTab home|mirror|...
        if let i = args.firstIndex(of: "-initialTab"),
           i + 1 < args.count,
           let t = Tab(rawValue: args[i + 1]) {
            return t
        }
        return .home
    }

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
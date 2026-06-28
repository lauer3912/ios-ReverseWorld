import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = ContentView.initialTabFromLaunchArgs()
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    static func initialTabFromLaunchArgs() -> Tab {
        let args = CommandLine.arguments
        if let i = args.firstIndex(of: "-initialTab"),
           i + 1 < args.count,
           let n = Int(args[i + 1]),
           n >= 0, n < Tab.allCases.count {
            return Tab.allCases[n]
        }
        if let i = args.firstIndex(of: "-initialTab"),
           i + 1 < args.count,
           let t = Tab(rawValue: args[i + 1]) {
            return t
        }
        return .home
    }

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // X2: iPad gets NavigationSplitView with sidebar instead of TabView
                NavigationSplitView(columnVisibility: $columnVisibility) {
                    List {
                        ForEach(Tab.allCases, id: \.self) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                Label(tab.displayName, systemImage: tab.iconName)
                                    .foregroundColor(Theme.Text.primary)
                            }
                        }
                    }
                    .navigationTitle("ReverseWorldGo")
                    .listStyle(.sidebar)
                } detail: {
                    selectedTab.view
                        .id(selectedTab)
                }
            } else {
                // iPhone keeps TabView
                tabView
            }
        }
        .tint(Theme.Accent.primary)
    }

    private var tabView: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(Tab.home)
            MirrorView()
                .tabItem { Label("Mirror", systemImage: "camera.fill") }
                .tag(Tab.mirror)
            TranslatorView()
                .tabItem { Label("Translate", systemImage: "text.bubble.fill") }
                .tag(Tab.translate)
            RulesView()
                .tabItem { Label("Rules", systemImage: "scroll.fill") }
                .tag(Tab.rules)
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(Tab.profile)
        }
    }
}

enum Tab: String, CaseIterable, Hashable {
    case home, mirror, translate, rules, profile

    var displayName: String {
        switch self {
        case .home: return "Home"
        case .mirror: return "Mirror"
        case .translate: return "Translate"
        case .rules: return "Rules"
        case .profile: return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .mirror: return "camera.fill"
        case .translate: return "text.bubble.fill"
        case .rules: return "scroll.fill"
        case .profile: return "person.fill"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .home: HomeView()
        case .mirror: MirrorView()
        case .translate: TranslatorView()
        case .rules: RulesView()
        case .profile: ProfileView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RuleManager())
        .environmentObject(StatsManager())
        .environmentObject(PremiumManager.shared)
}

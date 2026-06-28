import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = ContentView.initialTabFromLaunchArgs()
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var showProfileSheet = false

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
                    selectedTab.view(onProfileTap: { selectedTab = .profile })
                        .id(selectedTab)
                        .frame(maxWidth: .infinity)
                }
                .navigationSplitViewStyle(.balanced)
                // iPad: HomeView profile button sets selectedTab to .profile (Tab enum case .profile)
                // iPhone: HomeView profile button triggers showProfileSheet via callback
            } else {
                tabView
            }
        }
        .tint(Theme.Accent.primary)
        .sheet(isPresented: $showProfileSheet) {
            ProfileView()
        }
    }

    private var tabView: some View {
        TabView(selection: $selectedTab) {
            HomeView(onProfileTap: { showProfileSheet = true })
                .tabItem { Label(L10n.homeTitle, systemImage: "house.fill") }
                .tag(Tab.home)
            MirrorView()
                .tabItem { Label(L10n.tabMirror, systemImage: "camera.fill") }
                .tag(Tab.mirror)
            DiscoverView()
                .tabItem { Label(L10n.discoverTitle, systemImage: "sparkles") }
                .tag(Tab.discover)
            VoiceInversionView()
                .tabItem { Label(L10n.tabVoice, systemImage: "waveform") }
                .tag(Tab.voice)
            TranslatorView()
                .tabItem { Label(L10n.tabTranslate, systemImage: "text.bubble.fill") }
                .tag(Tab.translate)
            // iPhone: Profile sheet still works (HomeView button → showProfileSheet)
            // iPad: HomeView button → selectedTab = .profile (added to Tab enum)
        }
    }
}

enum Tab: String, CaseIterable, Hashable {
    case home, mirror, discover, voice, translate, profile

    var displayName: String {
        switch self {
        case .home: return L10n.homeTitle
        case .mirror: return L10n.tabMirror
        case .discover: return L10n.discoverTitle
        case .voice: return L10n.tabVoice
        case .translate: return L10n.tabTranslate
        case .profile: return L10n.profileTitle
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .mirror: return "camera.fill"
        case .discover: return "sparkles"
        case .voice: return "waveform"
        case .translate: return "text.bubble.fill"
        case .profile: return "person.crop.circle"
        }
    }

    @ViewBuilder
    func view(onProfileTap: @escaping () -> Void) -> some View {
        switch self {
        case .home: HomeView(onProfileTap: onProfileTap)
        case .mirror: MirrorView()
        case .discover: DiscoverView()
        case .voice: VoiceInversionView()
        case .translate: TranslatorView()
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

import SwiftUI

/// R7: Discover Feed - curated "Real Events of Reversal"
/// Maps to user's request: 真实事件的反转 (real event reversal)
/// Each card has: visual icon, category, title, description, CTA that opens the relevant tool
struct DiscoverView: View {
    private let items: [DiscoverItem] = DiscoverItem.curated

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Layout.sectionSpacing) {
                        header
                        LazyVStack(spacing: 16) {
                            ForEach(items) { item in
                                NavigationLink {
                                    destinationView(for: item)
                                } label: {
                                    DiscoverCard(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(L10n.discoverTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.discoverSubtitle)
                .font(.subheadline)
                .foregroundColor(Theme.Text.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
    }

    @ViewBuilder
    private func destinationView(for item: DiscoverItem) -> some View {
        switch item.targetTab {
        case .mirror: MirrorView()
        case .voice: VoiceInversionView()
        case .text: TranslatorView()
        }
    }
}

struct DiscoverItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let gradient: [Color]
    let category: String
    let title: String
    let description: String
    let fact: String
    let ctaLabel: String
    let targetTab: TargetTab

    enum TargetTab {
        case mirror, voice, text
    }

    static let curated: [DiscoverItem] = [
        // 1. Visual: Real event - Architecture symmetry
        DiscoverItem(
            icon: "building.2",
            gradient: [Color.purple, Color.blue],
            category: "ARCHITECTURE",
            title: "Symmetry in Real Buildings",
            description: "The Taj Mahal, the Pantheon, and your own face — see how reversal reveals hidden harmony.",
            fact: "The human face is 97% symmetrical when measured left-to-right.",
            ctaLabel: "Try Mirror →",
            targetTab: .mirror
        ),
        // 2. Audio: Backward masking in music
        DiscoverItem(
            icon: "music.quarternote.3",
            gradient: [Color.cyan, Color.indigo],
            category: "MUSIC",
            title: "Hidden Messages in Songs",
            description: "Play any song backwards and you might hear what was never meant to be heard.",
            fact: "When The Beatles played 'Revolution 9' backwards, fans claimed to hear 'Turn me on, dead man' — though the band denied it.",
            ctaLabel: "Try Voice Inversion →",
            targetTab: .voice
        ),
        // 3. Text: Palindromes
        DiscoverItem(
            icon: "text.aligncenter",
            gradient: [Color.green, Color.mint],
            category: "LANGUAGE",
            title: "Words That Read The Same Backwards",
            description: "From 'racecar' to 'level' to 'madam' — palindromes are reversals hiding in plain sight.",
            fact: "The longest known palindrome in any language is the Finnish word 'saippuakivikauppias' (a soapstone seller) — 19 letters.",
            ctaLabel: "Try Text Reverse →",
            targetTab: .text
        ),
        // 4. Visual: Mirror in nature
        DiscoverItem(
            icon: "leaf",
            gradient: [Color.teal, Color.green],
            category: "NATURE",
            title: "Why Butterflies Have Symmetric Wings",
            description: "Most animals are bilaterally symmetric — your left hand mirrors your right.",
            fact: "A flounder starts life as a normal fish, then one eye migrates to the other side so both eyes are on the same side. It's nature's most extreme mirror flip.",
            ctaLabel: "Explore Mirror →",
            targetTab: .mirror
        ),
        // 5. Audio: Sound inversion in nature
        DiscoverItem(
            icon: "waveform.path",
            gradient: [Color.pink, Color.purple],
            category: "ACOUSTICS",
            title: "Echolocation and Sound Reversal",
            description: "Bats emit sound and listen to the echo. Some species can hear time-reversed echoes to navigate.",
            fact: "Some bat species process audio at 200 updates per second — 10x faster than humans. They literally hear reality in reverse.",
            ctaLabel: "Try Voice →",
            targetTab: .voice
        ),
        // 6. Text: Genetic code
        DiscoverItem(
            icon: "atom",
            gradient: [Color.orange, Color.red],
            category: "BIOLOGY",
            title: "DNA Reads The Same Both Directions",
            description: "Half of DNA is a 'reverse complement' of the other half. Your genes are literally palindromic.",
            fact: "Some DNA sequences are perfect palindromes — they read identically on both strands. Evolution loves reversals.",
            ctaLabel: "Try Text →",
            targetTab: .text
        )
    ]
}

struct DiscoverCard: View {
    let item: DiscoverItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: item.gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 60, height: 60)
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.category)
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .foregroundColor(item.gradient.first ?? .purple)
                        .tracking(1.5)
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(Theme.Text.primary)
                }

                Spacer()
            }

            Text(item.description)
                .font(.subheadline)
                .foregroundColor(Theme.Text.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // "Did you know" fact box
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.caption)
                    .foregroundColor(Theme.Accent.warning)
                Text(item.fact)
                    .font(.caption)
                    .foregroundColor(Theme.Text.tertiary)
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.Background.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            HStack {
                Spacer()
                Text(item.ctaLabel)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(LinearGradient(colors: item.gradient, startPoint: .leading, endPoint: .trailing))
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(item.gradient.first ?? .purple)
            }
        }
        .padding(Theme.Layout.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                .fill(Theme.Background.card)
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Card.largeRadius)
                        .stroke(LinearGradient(colors: item.gradient.map { $0.opacity(0.3) }, startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                )
        )
    }
}

#Preview {
    DiscoverView()
}

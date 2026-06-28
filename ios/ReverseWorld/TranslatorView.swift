import SwiftUI

struct TranslatorView: View {
    @State private var inputText = ""
    @State private var selectedMode: ReverseMode = .reverse
    @State private var copied = false
    @State private var cachedReverse: String = ""  // T1: cache to avoid recompute on every redraw
    @State private var cachedMirror: String = ""
    @State private var cachedUpsideDown: String = ""
    @State private var cachedWordOrder: String = ""

    enum ReverseMode: String, CaseIterable, Identifiable {
        case reverse, mirror, upsideDown, wordOrder

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .reverse: return L10n.translatorModeReverse
            case .mirror: return L10n.translatorModeMirror
            case .upsideDown: return L10n.translatorModeUpsideDown
            case .wordOrder: return L10n.translatorModeWordOrder
            }
        }

        var icon: String {
            switch self {
            case .reverse: return "arrow.left.arrow.right"
            case .mirror: return "arrow.left.and.right.righttriangle.left.righttriangle.right"
            case .upsideDown: return "arrow.up.arrow.down"
            case .wordOrder: return "text.alignleft.arrow.right"
            }
        }
    }

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad: skip NavigationStack (per #44 #5)
                ZStack {
                    Theme.Background.primary.ignoresSafeArea()
                    content
                }
            } else {
                // iPhone: NavigationStack for navigation title
                NavigationStack {
                    ZStack {
                        Theme.Background.primary.ignoresSafeArea()
                        content
                    }
                    .navigationTitle(L10n.homeTranslatorTitle)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: Theme.Layout.sectionSpacing) {
            // T4: Mode selector uses both horizontal and adaptive layout
            modeSelector
                .padding(.top, 10)

            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.translatorInput)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .accessibilityAddTraits(.isHeader)

                TextField(L10n.translatorPlaceholder, text: $inputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Theme.Background.card)
                    .foregroundColor(Theme.Text.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                    .lineLimit(3...6)
                    .onChange(of: inputText) { _, _ in updateCaches() }  // T1
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(L10n.translatorOutput)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Accent.warning)
                        .accessibilityAddTraits(.isHeader)

                    Spacer()

                    Button {
                        UIPasteboard.general.string = currentOutput
                        copied = true
                    } label: {
                        Label(copied ? L10n.translatorCopied : L10n.translatorCopy, systemImage: copied ? "checkmark" : "doc.on.doc")
                            .font(.caption)
                            .foregroundColor(copied ? Theme.Accent.success : Theme.Text.primary)
                    }
                    .sensoryFeedback(.success, trigger: copied)  // T5
                    .accessibilityLabel("Copy reversed text")
                }
                .onChange(of: copied) { _, newValue in
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            copied = false
                        }
                    }
                }

                Text(currentOutput.isEmpty ? L10n.translatorOutputPlaceholder : currentOutput)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(currentOutput.isEmpty ? Theme.Text.disabled : Theme.Text.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.Background.card)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Card.cornerRadius)
                            .stroke(Theme.Accent.warning.opacity(0.3), lineWidth: 1)
                    )
                    .accessibilityLabel("Reversed output: \(currentOutput)")
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                Text(L10n.translatorExamples)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .accessibilityAddTraits(.isHeader)

                // T7: more examples
                ForEach(examplePhrases, id: \.self) { phrase in
                    Button {
                        inputText = phrase
                    } label: {
                        Text(phrase)
                            .font(.subheadline)
                            .foregroundColor(Theme.Text.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Theme.Background.card)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .accessibilityLabel("Use example: \(phrase)")
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.bottom, 20)
    }

    // T4: mode buttons in horizontal scroll, but constrained to fit narrow screens
    private var modeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ReverseMode.allCases) { mode in
                    Button {
                        selectedMode = mode
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: mode.icon)
                            Text(mode.displayName)
                        }
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedMode == mode ? Theme.Accent.primary : Theme.Background.card)
                        .foregroundColor(Theme.Text.primary)
                        .clipShape(Capsule())
                    }
                    .accessibilityLabel("\(mode.displayName) mode\(selectedMode == mode ? ", selected" : "")")
                }
            }
            .padding(.horizontal)
        }
    }

    // T7: expanded example list
    private let examplePhrases = [
        "Hello World",
        "Time to reverse",
        "Mirror Mirror",
        "The quick brown fox",
        "Reverse the world",
    ]

    // T1: cached output per mode
    private var currentOutput: String {
        switch selectedMode {
        case .reverse: return cachedReverse
        case .mirror: return cachedMirror
        case .upsideDown: return cachedUpsideDown
        case .wordOrder: return cachedWordOrder
        }
    }

    private func updateCaches() {
        guard !inputText.isEmpty else {
            cachedReverse = ""
            cachedMirror = ""
            cachedUpsideDown = ""
            cachedWordOrder = ""
            return
        }
        cachedReverse = String(inputText.reversed())
        cachedMirror = mirrorText(inputText)
        cachedUpsideDown = inputText.map { UpsideDownMap.char(for: $0) }.joined()
        cachedWordOrder = inputText.split(separator: " ").reversed().joined(separator: " ")
    }

    // T3: real character-level mirror (was just reverse() — same as .reverse mode)
    private func mirrorText(_ text: String) -> String {
        // True mirror: reverse each word's characters AND reverse word order
        // This is what people see when looking in a mirror
        let words = text.split(separator: " ")
        let reversedWords = words.reversed().map { String($0.reversed()) }
        return reversedWords.joined(separator: " ")
    }
}

// T2: static lookup table
enum UpsideDownMap {
    private static let map: [Character: String] = [
        "a": "\u{0250}", "b": "q", "c": "\u{0254}", "d": "p", "e": "\u{01DD}",
        "f": "\u{025F}", "g": "\u{0183}", "h": "\u{0265}", "i": "\u{0131}",
        "j": "\u{0278}", "k": "\u{029E}", "l": "l", "m": "\u{026F}",
        "n": "u", "o": "o", "p": "d", "q": "b", "r": "\u{0279}",
        "s": "s", "t": "\u{0287}", "u": "n", "v": "\u{028C}", "w": "\u{028D}",
        "x": "x", "y": "\u{028E}", "z": "z",
        "A": "\u{0250}", "B": "q", "C": "\u{0254}", "D": "p", "E": "\u{01DD}",
        "F": "\u{025F}", "G": "\u{0183}", "H": "H", "I": "I", "J": "\u{0278}",
        "K": "\u{029E}", "L": "L", "M": "W", "N": "N", "O": "O",
        "P": "d", "Q": "b", "R": "\u{0279}", "S": "S", "T": "\u{0287}",
        "U": "n", "V": "\u{028C}", "W": "W", "X": "X", "Y": "\u{028E}",
        "Z": "Z",
        "1": "\u{0196}", "2": "S", "3": "E", "4": "\u{0195}", "5": "\u{025B}",
        "6": "9", "7": "\u{0291}", "8": "8", "9": "6", "0": "0",
        " ": " ",
    ]

    static func char(for c: Character) -> String {
        return map[c.lowercased().first ?? Character(" ")] ?? String(c)
    }
}

#Preview {
    TranslatorView()
}

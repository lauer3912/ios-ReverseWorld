import SwiftUI

struct TranslatorView: View {
    @State private var inputText = ""
    @State private var selectedMode: ReverseMode = .reverse
    @State private var copied = false

    enum ReverseMode: String, CaseIterable {
        case reverse = "Reverse"
        case mirror = "Mirror"
        case upsideDown = "Upside Down"
        case wordOrder = "Word Order"

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
        NavigationStack {
            ZStack {
                Color(hex: "0a0a1a")
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Mode Selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ReverseMode.allCases, id: \.self) { mode in
                                Button {
                                    selectedMode = mode
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: mode.icon)
                                        Text(mode.rawValue)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(selectedMode == mode ? Color.purple : Color(hex: "1a0a2e"))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 10)

                    // Input Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ENTER TEXT")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)

                        TextField("Type something...", text: $inputText, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(hex: "1a0a2e"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .lineLimit(3...6)
                    }
                    .padding(.horizontal)

                    // Result Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("REVERSED OUTPUT")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = reversedText
                                copied = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    copied = false
                                }
                            } label: {
                                Label(copied ? "Copied!" : "Copy", systemImage: copied ? "checkmark" : "doc.on.doc")
                                    .font(.caption)
                                    .foregroundColor(copied ? .green : .white)
                            }
                        }

                        Text(reversedText.isEmpty ? "Your reversed text appears here..." : reversedText)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(reversedText.isEmpty ? .white.opacity(0.4) : .white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(hex: "1a0a2e"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)

                    // Example Phrases
                    VStack(alignment: .leading, spacing: 12) {
                        Text("TRY THESE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.cyan)

                        ForEach(["Hello World", "Time to reverse", "Mirror Mirror"], id: \.self) { phrase in
                            Button {
                                inputText = phrase
                            } label: {
                                Text(phrase)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(hex: "1a0a2e"))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Reverse Translator")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var reversedText: String {
        guard !inputText.isEmpty else { return "" }

        switch selectedMode {
        case .reverse:
            return String(inputText.reversed())
        case .mirror:
            return String(inputText.reversed())
        case .upsideDown:
            return inputText.map { upsideDownChar($0) }.joined()
        case .wordOrder:
            return inputText.split(separator: " ").reversed().joined(separator: " ")
        }
    }

    func upsideDownChar(_ char: Character) -> String {
        let map: [Character: String] = [
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
            " ": " "
        ]
        return map[char] ?? String(char)
    }
}

#Preview {
    TranslatorView()
}
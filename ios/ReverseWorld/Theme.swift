import SwiftUI

/// App-wide design tokens (X3: extract hardcoded hex colors)
enum Theme {
    enum Background {
        static let primary = Color(hex: "0a0a1a")
        static let card = Color(hex: "1a0a2e")
        static let elevated = Color(hex: "3d2a6e")
    }

    enum Accent {
        static let primary = Color(hex: "7C6AFF")     // Tab bar tint, primary CTAs
        static let success = Color(hex: "4CD964")
        static let warning = Color(hex: "FFCC00")
        static let danger = Color(hex: "FF3B30")
    }

    enum Text {
        static let primary = Color.white
        static let secondary = Color.white.opacity(0.7)
        static let tertiary = Color.white.opacity(0.5)
        static let disabled = Color.white.opacity(0.4)
    }

    enum Card {
        static let cornerRadius: CGFloat = 12
        static let largeRadius: CGFloat = 16
        static let pillRadius: CGFloat = 200
    }

    enum Layout {
        static let cardPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 24
    }
}

/// Bundle info helpers (P1: derive version from Bundle.main so it stays in sync with project.yml)
extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var fullVersion: String {
        "\(appVersion) (\(buildNumber))"
    }
}

/// Logging helper (N1: replace print() with OSLog so it doesn't leak to TestFlight console)
import OSLog
enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "ReverseWorldGo"

    static let notification = Logger(subsystem: subsystem, category: "notification")
    static let camera = Logger(subsystem: subsystem, category: "camera")
    static let premium = Logger(subsystem: subsystem, category: "premium")
    static let general = Logger(subsystem: subsystem, category: "general")
}

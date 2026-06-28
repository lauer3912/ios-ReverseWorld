import Foundation

/// Centralized string constants (R5-8)
/// Using `String` rather than `LocalizedStringKey` for simplicity in this initial implementation.
/// Future: convert to `LocalizedStringResource` for proper localization workflow.
enum L10n {
    // App
    static let appName = "ReverseWorldGo"

    // Common
    static let ok = "OK"
    static let cancel = "Cancel"
    static let save = "Save"

    // Home
    static let homeTitle = "REVERSE WORLD"
    static let homeTagline = "Flip Reality. Reverse Rules."
    static let homeMirrorTitle = "Mirror World"
    static let homeMirrorSubtitle = "See yourself reversed"
    static let homeTranslatorTitle = "Reverse Translator"
    static let homeTranslatorSubtitle = "Transform words backwards"
    static let homeTodayRuleLabel = "TODAY'S REVERSE RULE"
    static let homeDidIt = "I Did It!"

    // Stats
    static let statReverseDays = "Reverse Days"
    static let statRulesFound = "Rules Found"
    static let statStartYourFirst = "Start your first"
    static let statCompleteARule = "Complete a rule"

    // Translator
    static let translatorTitle = "Reverse Translator"
    static let translatorInput = "ENTER TEXT"
    static let translatorPlaceholder = "Type something..."
    static let translatorOutput = "REVERSED OUTPUT"
    static let translatorOutputPlaceholder = "Your reversed text appears here..."
    static let translatorExamples = "TRY THESE"
    static let translatorCopy = "Copy"
    static let translatorCopied = "Copied!"
    static let translatorModeReverse = "Reverse"
    static let translatorModeMirror = "Mirror"
    static let translatorModeUpsideDown = "Upside Down"
    static let translatorModeWordOrder = "Word Order"

    // Rules
    static let rulesTodayLabel = "TODAY'S RULE"
    static let rulesCountdownFormat = "%@h %@m until new rule"
    static let rulesDiscoveredLabel = "DISCOVERED RULES"
    static let rulesAllLabel = "ALL REVERSE RULES"
    static let rulesLocked = "Locked"
    static let rulesDiscoveredBadge = "Discovered"
    static let rulesConfirmMarkDone = "Mark this rule as completed?"
    static let rulesConfirmMessage = "Once marked, you can discover it in your collection."

    // Profile
    static let profileTitle = "Profile"
    static let profileSetName = "Set your name"
    static let profileEditNameTitle = "Edit Username"
    static let profileNamePrompt = "Username (3-20 chars)"
    static let profileNameMessage = "Pick a name shown in your profile and shared reverse content."
    static let profileStartReverse = "Reversing starts today"
    static let profileDay1 = "Day 1 of reversing"
    static let profileNDays = "%@ days reversing"
    static let profileAchievements = "ACHIEVEMENTS"
    static let profileAchievementsEmpty = "Complete rules to unlock achievements"
    static let profilePremium = "PREMIUM"
    static let profilePremiumActive = "· ACTIVE"
    static let profilePremiumActiveTitle = "Premium Active"
    static let profilePremiumUnlock = "Unlock Premium"
    static let profilePremiumDescription = "Get 7-day free trial"
    static let profilePremiumDescriptionActive = "All filters, ad-free, unlimited entries"
    static let profileRestorePurchases = "Restore Purchases"
    static let profileSettings = "SETTINGS"
    static let profileDarkMode = "Dark Mode"
    static let profileDailyReminder = "Daily Reminder"
    static let profilePrivacyPolicy = "Privacy Policy"
    static let profileContactUs = "Contact Us"
    static let profileAbout = "About"
    static let profileRulesDone = "Rules Done"
    static let profileMirrorMin = "Mirror Min"

    // Paywall
    static let paywallTitle = "Unlock Premium"
    static let paywallSubtitleFormat = "Get 7-day free trial, then %@/month"
    static let paywallYearly = "Yearly"
    static let paywallYearlyFormat = "Best value • %@/year"
    static let paywallYearlyFallback = "Best value • $29.99/year"
    static let paywallMonthly = "Monthly"
    static let paywallMonthlyFormat = "%@/month"
    static let paywallMonthlyFallback = "$0.99/month"
    static let paywallPopular = "POPULAR"
    static let paywallClose = "Close"
    static let paywallFeatureFilters = "All mirror filters unlocked"
    static let paywallFeatureTranslator = "All reverse translator modes"
    static let paywallFeatureJournal = "Unlimited reverse journal entries"
    static let paywallFeatureRules = "Priority rule updates"
    static let paywallFeatureNoAds = "Ad-free experience"

    // About
    static let aboutTagline = "Flip reality. Reverse rules. Experience the world differently."

    // Mirror
    static let mirrorTipTitle = "Mirror Tip"
    static let mirrorTipBody = "Use your non-dominant hand in mirror to challenge your brain!"
    static let mirrorMirrored = "Mirrored"
    static let mirrorNormal = "Normal"
    static let mirrorFlip = "Flip"
    static let mirrorTapToEnable = "Tap to enable camera"
    static let mirrorSavedTitle = "Saved to Photos"
    static let mirrorSavedMessage = "Your mirror photo has been added to your photo library."
    static let mirrorAuthDeniedTitle = "Camera Access Denied"
    static let mirrorAuthDeniedMessage = "Please enable camera access for ReverseWorldGo in Settings to use the mirror feature."
    static let mirrorAuthDeniedSettings = "Open Settings"
    static let mirrorAuthDeniedError = "Camera access denied. Please enable in Settings."

    // Restore / Purchase
    static let restoreSuccess = "✅ Premium restored successfully"
    static let restoreNotFound = "No previous purchases found for this Apple ID"
    static let restoreFailedFormat = "Restore failed: %@"
    static let purchaseCancelled = "Purchase cancelled"

    // App version
    static func appVersion(_ version: String, _ build: String) -> String {
        "\(appName) v\(version) (\(build))"
    }

    // Countdown
    static func countdownFormat(hours: Int, minutes: Int) -> String {
        "\(hours)h \(minutes)m until new rule"
    }

    // Stats
    static func nDays(_ n: Int) -> String {
        "\(n) days reversing"
    }
}

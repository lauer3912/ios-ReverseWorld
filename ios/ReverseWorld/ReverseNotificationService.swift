import Foundation
import UserNotifications

class ReverseNotificationService {
    static let shared = ReverseNotificationService()

    private init() {}

    /// N1: log via OSLog instead of print() (no more TestFlight console leak)
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                AppLog.notification.error("Authorization error: \(error.localizedDescription, privacy: .public)")
            }
            completion(granted)
        }
    }

    /// N3: query current notification settings to keep App state in sync with iOS Settings
    func currentSettings(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    /// R2-10: async/await version that returns all status info
    @MainActor
    func currentAuthStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }

    /// R2-10: check if notifications should prompt user (covers ephemeral, provisional, notDetermined)
    @MainActor
    func shouldRequestAuthorization() async -> Bool {
        let status = await currentAuthStatus()
        switch status {
        case .notDetermined, .provisional, .ephemeral:
            return true
        case .authorized, .denied:
            return false
        @unknown default:
            return false
        }
    }

    func scheduleDailyRuleReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Today's Reverse Rule 📜"
        content.body = "A new reverse rule has arrived! Are you ready to challenge reality?"
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_rule", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                AppLog.notification.error("Schedule daily rule failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    func scheduleAchievementNotification(achievement: String) {
        let content = UNMutableNotificationContent()
        content.title = "Achievement Unlocked! 🏆"
        content.body = "You've earned: \(achievement)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "achievement_\(UUID().uuidString)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                AppLog.notification.error("Schedule achievement failed: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}

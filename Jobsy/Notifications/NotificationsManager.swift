//
//  NotificationsManager.swift
//  Jobsy
//
//  Created by Lucas West on 27/01/2025.
//

import SwiftUI
import UserNotifications

class NotificationsManager {
    static let shared = NotificationsManager()

    private let notificationCenter: UNUserNotificationCenter

    private init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    func requestAuthorization() async throws -> Bool {
        do {
            return try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("We encountered an issue requesting notification permissions: \(error)")
            throw error
        }
    }

    func checkNotificationStatus() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    func scheduleNotification(_ request: NotificationRequest) async throws {
        // If notification prevents stacking, remove any existing notifications with same identifier
        if request.preventsStackingNotifications {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [request.identifier])
            notificationCenter.removeDeliveredNotifications(withIdentifiers: [request.identifier])
        }

        let content = UNMutableNotificationContent()
        content.title = request.title
        content.body = request.body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: request.timeInterval,
            repeats: request.repeats
        )

        let notification = UNNotificationRequest(
            identifier: request.identifier,
            content: content,
            trigger: trigger
        )

        try await notificationCenter.add(notification)
    }

    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func removeAllDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
    }
}

//
//  MockNotificationsManager.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 28/01/2025.
//

@testable import Jobsy

final class MockNotificationsManager: NotificationsManagerProtocol {
    var notificationStatus: NotificationStatus = .notDetermined
    var scheduledNotifications = [NotificationRequest]()
    var authorizationRequested = false
    var removeAllPendingCalled = false
    var removedIdentifiers = [String]()

    func getNotificationStatus() async -> NotificationStatus { notificationStatus }

    func requestAuthorization() async throws -> Bool {
        authorizationRequested = true
        return notificationStatus == .authorized
    }

    func checkNotificationStatus() async -> Bool { notificationStatus == .authorized }

    func scheduleNotification(_ request: NotificationRequest) async throws {
        if request.preventsStackingNotifications {
            removedIdentifiers.append(request.identifier)
        }
        scheduledNotifications.append(request)
    }

    func removeAllPendingNotifications() {
        removeAllPendingCalled = true
        scheduledNotifications.removeAll()
    }

    func removeAllDeliveredNotifications() {}
}

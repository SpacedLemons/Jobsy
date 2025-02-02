//
//  MockNotificationService.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 02/02/2025.
//

@testable import Jobsy

class MockNotificationService: NotificationServiceProtocol {
    var notificationStatus: NotificationStatus = .notDetermined
    var authorizationRequested = false
    var notificationObserverSetup = false
    var scheduledNotifications: [NotificationRequest] = []
    var fortnightlyNotificationHandler: (() -> Void)?

    func checkAndUpdateStatus() async -> NotificationStatus { notificationStatus }

    func enableNotifications() async throws -> Bool {
        authorizationRequested = true
        if notificationStatus == .authorized {
            scheduledNotifications.append(.fortnightlyCheckNotification)
            return true
        }
        return false
    }
    
    func setupNotificationObserver(fortnightlyHandler: @escaping () -> Void) {
        self.fortnightlyNotificationHandler = fortnightlyHandler
        notificationObserverSetup = true
    }
    
    func removeNotificationObserver() {
        fortnightlyNotificationHandler = nil
        notificationObserverSetup = false
    }

    func simulateFortnightlyNotification() async {
        await MainActor.run {
            fortnightlyNotificationHandler?()
        }
    }
}

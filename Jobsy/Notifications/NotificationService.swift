//
//  NotificationService.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 02/02/2025.
//

import Foundation

protocol NotificationServiceProtocol {
    var notificationStatus: NotificationStatus { get }
    func checkAndUpdateStatus() async -> NotificationStatus
    func setupNotificationObserver(fortnightlyHandler: @escaping () -> Void)
    func removeNotificationObserver()
    func enableNotifications() async throws -> Bool
}

final class NotificationService: NotificationServiceProtocol {
    private let notificationsManager: NotificationsManagerProtocol
    private let notificationCenter: NotificationCenterProtocol
    private var notificationObserver: NSObjectProtocol?

    private(set) var notificationStatus: NotificationStatus = .notDetermined

    init(
        notificationsManager: NotificationsManagerProtocol = NotificationsManager.shared,
        notificationCenter: NotificationCenterProtocol = NotificationCenter.default
    ) {
        self.notificationsManager = notificationsManager
        self.notificationCenter = notificationCenter
    }

    deinit { removeNotificationObserver() }

    func checkAndUpdateStatus() async -> NotificationStatus {
        notificationStatus = await notificationsManager.getNotificationStatus()
        return notificationStatus
    }

    func enableNotifications() async throws -> Bool {
        let granted = try await notificationsManager.requestAuthorization()
        notificationStatus = granted ? .authorized : .denied

        if granted {
            try await notificationsManager.scheduleNotification(.fortnightlyCheckNotification)
        }

        return granted
    }

    func setupNotificationObserver(fortnightlyHandler: @escaping () -> Void) {
        notificationObserver = notificationCenter.addObserver(
            forName: .notificationTapped,
            object: nil,
            queue: .main
        ) { notification in
            guard let identifier = notification.object as? String,
                  identifier == NotificationRequest.fortnightlyCheckNotification.identifier else { return }
            fortnightlyHandler()
        }
    }

    func removeNotificationObserver() {
        if let observer = notificationObserver {
            notificationCenter.removeObserver(observer)
            notificationObserver = nil
        }
    }
}

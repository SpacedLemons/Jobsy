//
//  OnboardingViewModel.swift
//  Jobsy
//
//  Created by Lucas West on 24/01/2025.
//

import Foundation

enum UserRole: String {
    case recruiter
    case candidate
}

enum OnboardingView {
    case welcome
    case notifications
    case uploadCV
    case recruiter
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isFullScreenPresented = false
    @Published var selectedUserRole: UserRole?
    @Published var currentView: OnboardingView = .welcome
    @Published private(set) var notificationStatus: NotificationStatus = .notDetermined

    private let notificationsManager: NotificationsManagerProtocol

    init(notificationsManager: NotificationsManagerProtocol = NotificationsManager.shared) {
        self.notificationsManager = notificationsManager
        Task { await checkNotificationStatus() }
    }

    func selectRole(_ role: UserRole) {
        selectedUserRole = role
        isFullScreenPresented = true
        currentView = role == .candidate ? (notificationStatus == .authorized ? .uploadCV : .notifications) : .recruiter
    }

    @discardableResult
    func checkNotificationStatus() async -> NotificationStatus {
        notificationStatus = await notificationsManager.getNotificationStatus()

        if notificationStatus == .authorized && currentView == .notifications {
            navigateToUploadCV()
        }

        return notificationStatus
    }

    func enableNotifications() async {
        do {
            let granted = try await notificationsManager.requestAuthorization()
            notificationStatus = granted ? .authorized : .denied

            if granted {
                try await notificationsManager.scheduleNotification(.fortnightlyCheckNotification)
                navigateToUploadCV()
            }
        } catch {
            print("Failed to enable notifications: \(error)")
        }
    }

    func navigateToUploadCV() { currentView = .uploadCV }

    func dismiss() {
        selectedUserRole = nil
        isFullScreenPresented = false
        currentView = .welcome
    }
}

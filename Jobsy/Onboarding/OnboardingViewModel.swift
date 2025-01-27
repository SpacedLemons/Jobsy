//
//  OnboardingViewModel.swift
//  Jobsy
//
//  Created by Lucas West on 24/01/2025.
//

import SwiftUI

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
    @Published private(set) var notificationStatus: NotificationsManager.NotificationStatus = .notDetermined

    private let notificationsManager = NotificationsManager.shared

    init() {
        Task { await checkNotificationStatus() }
    }

    func selectRole(_ role: UserRole) {
        selectedUserRole = role
        isFullScreenPresented = true
        currentView = role == .candidate ? (notificationStatus == .authorized ? .uploadCV : .notifications) : .recruiter
    }

    @discardableResult
    func checkNotificationStatus() async -> NotificationsManager.NotificationStatus {
        notificationStatus = await notificationsManager.getNotificationStatus()

        // If notifications are now authorized and we're on the notifications view, advance
        if notificationStatus == .authorized && currentView == .notifications {
            navigateToUploadCV()
        }

        return notificationStatus
    }

    func enableNotifications() async -> Bool {
        do {
            if notificationStatus == .denied {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    await UIApplication.shared.open(settingsUrl)
                }
                return false
            }

            let granted = try await notificationsManager.requestAuthorization()
            notificationStatus = granted ? .authorized : .denied

            if granted {
                try await notificationsManager.scheduleNotification(.fortnightlyCheckNotification)
                navigateToUploadCV()
            }

            return granted
        } catch {
            print("Failed to enable notifications: \(error)")
            return false
        }
    }

    func navigateToUploadCV() { currentView = .uploadCV }

    func dismiss() {
        selectedUserRole = nil
        isFullScreenPresented = false
        currentView = .welcome
    }
}

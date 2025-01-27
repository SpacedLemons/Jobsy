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
    @Published var isNotificationsEnabled = false
    @Published var selectedUserRole: UserRole?
    @Published var currentView: OnboardingView = .welcome

    private let notificationsManager = NotificationsManager.shared

    init() { Task { await checkNotificationStatus() } }

    func selectRole(_ role: UserRole) {
        selectedUserRole = role
        isFullScreenPresented = true
        currentView = role == .candidate ? (isNotificationsEnabled ? .uploadCV : .notifications) : .recruiter
    }

    func navigateToUploadCV() { currentView = .uploadCV }

    func dismiss() {
        selectedUserRole = nil
        isFullScreenPresented = false
        currentView = .welcome
    }

    func checkNotificationStatus() async {
        isNotificationsEnabled = await notificationsManager.checkNotificationStatus()
    }

    func enableNotifications() async -> Bool {
        do {
            let granted = try await notificationsManager.requestAuthorization()
            isNotificationsEnabled = granted
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
}

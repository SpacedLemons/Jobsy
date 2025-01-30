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
    case cvExtensionConfirmation
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isNotificationsPresented = false
    @Published var isFullScreenPresented = false
    @Published var selectedUserRole: UserRole?
    @Published var currentView: OnboardingView = .welcome
    @Published private(set) var notificationStatus: NotificationStatus = .notDetermined

    private var notificationObserver: NSObjectProtocol?
    private let notificationsManager: NotificationsManagerProtocol
    private let notificationCenter: NotificationCenterProtocol

    init(
        notificationsManager: NotificationsManagerProtocol = NotificationsManager.shared,
        notificationCenter: NotificationCenterProtocol = NotificationCenter.default
    ) {
        self.notificationsManager = notificationsManager
        self.notificationCenter = notificationCenter
        Task { await checkNotificationStatus() }
        setupNotificationObserver()
    }

    deinit {
        if let observer = notificationObserver {
            notificationCenter.removeObserver(observer)
        }
    }

    func selectRole(_ role: UserRole) {
        selectedUserRole = role
        isFullScreenPresented = true
        currentView = role == .candidate ? (notificationStatus == .authorized ? .uploadCV : .notifications) : .recruiter
    }

    func navigateToUploadCV() { currentView = .uploadCV }

    func dismiss() {
        selectedUserRole = nil
        isFullScreenPresented = false
        currentView = .welcome
    }

    // MARK: Notifications

    private func setupNotificationObserver() {
        notificationObserver = notificationCenter.addObserver(
            forName: .notificationTapped,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let identifier = notification.object as? String,
                  identifier == NotificationRequest.fortnightlyCheckNotification.identifier else { return }
            Task { @MainActor [weak self] in
                self?.handleFortnightlyNotification()
            }
        }
    }

    private func handleFortnightlyNotification() {
        print("✅ CV Extension automatically confirmed via notification click")
        currentView = .cvExtensionConfirmation
        isFullScreenPresented = true
    }

    func confirmCVExtension() { print("CV Extension button pressed") }

    func closeApp() { exit(0) }

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
            print("❌ Failed to enable notifications: \(error)")
        }
    }
}

//
//  OnboardingViewModel.swift
//  Jobsy
//
//  Created by Lucas West on 24/01/2025.
//

import Foundation
import UniformTypeIdentifiers

enum UserRole: String {
    case recruiter
    case candidate
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var isNotificationsPresented = false
    @Published var isFullScreenPresented = false
    @Published var isPresentingFilePicker = false
    @Published var isCVSubmitted = false
    @Published var currentMessageIndex = 0
    @Published var selectedUserRole: UserRole?
    @Published var currentView: OnboardingViewTracker = .welcome
    @Published var selectedFileURL: URL?
    @Published var fileSelectionError: String?
    @Published private(set) var notificationStatus: NotificationStatus = .notDetermined

    private var timer: Timer?
    private var notificationObserver: NSObjectProtocol?

    var allowedContentTypes: [UTType] { UTType.cvTypes }

    private let notificationsManager: NotificationsManagerProtocol
    private let notificationCenter: NotificationCenterProtocol

    let loadingMessages = [
        "Scanning your CV...",
        "This shouldn't take too long.",
        "Analyzing fonts and styles...",
        "Counting the number of pages...",
        "Decoding your career story...",
        "Searching for typos (we won't judge)..."
    ]

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
        isCVSubmitted = false
        isFullScreenPresented = true
        currentView = role == .candidate
        ? (notificationStatus == .authorized ? .uploadCV : .notifications)
        : .recruiter
    }

    func navigateToUploadCV() { currentView = .uploadCV }

    func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            selectedFileURL = url
            fileSelectionError = nil
        case .failure(let error):
            fileSelectionError = error.localizedDescription
            selectedFileURL = nil
        }
    }

    func clearFileSelection() { selectedFileURL = nil }

    func submitCV() { isCVSubmitted = true }

    func startMessageLoop() {
        currentMessageIndex = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.currentMessageIndex = (self.currentMessageIndex + 1) % self.loadingMessages.count
            }
        }
    }

    func stopMessageLoop() {
        timer?.invalidate()
        timer = nil
    }

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

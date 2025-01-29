//
//  OnboardingViewModelTests.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 28/01/2025.
//


@testable import Jobsy
import XCTest

@MainActor
class OnboardingViewModelTests: XCTestCase {
    var mockNotifications: MockNotificationsManager!
    var viewModel: OnboardingViewModel!

    @MainActor
    override func setUp() {
        super.setUp()
        mockNotifications = MockNotificationsManager()
        viewModel = OnboardingViewModel(notificationsManager: mockNotifications)
    }

    func testCandidateSelectionWithAuthorizedNotifications() async {
        // Given
        mockNotifications.notificationStatus = .authorized

        // When
        viewModel.selectRole(.candidate)
        try? await Task.sleep(nanoseconds: 100_000)

        // Then
        XCTAssertEqual(viewModel.currentView, .uploadCV)
    }

    func testEnableNotificationsFlow() async {
        // Given
        mockNotifications.notificationStatus = .notDetermined

        // When
        mockNotifications.notificationStatus = .authorized
        await viewModel.enableNotifications()

        // Then
        XCTAssertTrue(mockNotifications.authorizationRequested)
        await MainActor.run {
            XCTAssertEqual(viewModel.currentView, .uploadCV)
            XCTAssertEqual(viewModel.notificationStatus, .authorized)
        }
    }

    func testSelectRoleNavigatesToNotificationsWhenNotAuthorized() async {
        // Given
        mockNotifications.notificationStatus = .notDetermined

        // When
        viewModel.selectRole(.candidate)

        // Then
        XCTAssertEqual(viewModel.currentView, .notifications)
    }

    func testDismissResetsState() async {
        // Given
        viewModel.selectRole(.candidate)
        viewModel.currentView = .uploadCV

        // When
        viewModel.dismiss()

        // Then
        XCTAssertNil(viewModel.selectedUserRole)
        XCTAssertFalse(viewModel.isFullScreenPresented)
        XCTAssertEqual(viewModel.currentView, .welcome)
    }

    func testCheckNotificationStatusUpdatesState() async {
        // Given
        mockNotifications.notificationStatus = .authorized
        viewModel.currentView = .notifications

        // When
        await viewModel.checkNotificationStatus()

        // Then
        XCTAssertEqual(viewModel.notificationStatus, .authorized)
        XCTAssertEqual(viewModel.currentView, .uploadCV)
    }

    func testEnableNotificationsSchedulesNotification() async {
        // Given
        mockNotifications.notificationStatus = .authorized

        // When
        _ = await viewModel.enableNotifications()

        // Then
        XCTAssertEqual(mockNotifications.scheduledNotifications.count, 1)
        XCTAssertEqual(mockNotifications.scheduledNotifications.first, .fortnightlyCheckNotification)
    }
}

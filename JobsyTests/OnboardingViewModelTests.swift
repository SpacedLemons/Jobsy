//
//  OnboardingViewModelTests.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 28/01/2025.
//

@testable import Jobsy
import XCTest

@MainActor
final class OnboardingViewModelTests: XCTestCase {
    var mockNotificationService: MockNotificationService!
    var viewModel: OnboardingViewModel!

    @MainActor
    override func setUp() {
        super.setUp()
        mockNotificationService = MockNotificationService()
        viewModel = OnboardingViewModel(notificationService: mockNotificationService)
    }

    func testCandidateSelectionWithAuthorizedNotifications() async {
        // Given
        mockNotificationService.notificationStatus = .authorized
        await viewModel.checkNotificationStatus()

        // When
        viewModel.selectRole(.candidate)

        // Then
        XCTAssertEqual(viewModel.currentView, .uploadCV)
    }

    func testEnableNotificationsFlow() async {
        // Given
        mockNotificationService.notificationStatus = .notDetermined

        // When
        mockNotificationService.notificationStatus = .authorized
        await viewModel.enableNotifications()

        // Then
        XCTAssertTrue(mockNotificationService.authorizationRequested)
        await MainActor.run {
            XCTAssertEqual(viewModel.currentView, .uploadCV)
            XCTAssertEqual(viewModel.notificationStatus, .authorized)
        }
    }

    func testSelectRoleNavigatesToNotificationsWhenNotAuthorized() async {
        // Given
        mockNotificationService.notificationStatus = .notDetermined

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
        mockNotificationService.notificationStatus = .authorized
        viewModel.currentView = .notifications

        // When
        await viewModel.checkNotificationStatus()

        // Then
        XCTAssertEqual(viewModel.notificationStatus, .authorized)
        XCTAssertEqual(viewModel.currentView, .uploadCV)
    }

    func testEnableNotificationsSchedulesNotification() async {
        // Given
        mockNotificationService.notificationStatus = .authorized

        // When
        await viewModel.enableNotifications()

        // Then
        XCTAssertEqual(mockNotificationService.scheduledNotifications.count, 1)
        XCTAssertEqual(mockNotificationService.scheduledNotifications.first, .fortnightlyCheckNotification)
    }

    func testNotificationObserverSetup() {
        // Then
        XCTAssertTrue(mockNotificationService.notificationObserverSetup)
    }

    func testFortnightlyNotificationHandling() async {
        // When
        await mockNotificationService.simulateFortnightlyNotification()

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.currentView, .cvExtensionConfirmation)
            XCTAssertTrue(viewModel.isFullScreenPresented)
        }
    }
}

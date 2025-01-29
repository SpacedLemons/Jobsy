//
//  OnboardingViewModelTests.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 28/01/2025.
//


@testable import Jobsy
import XCTest

@MainActor // Add this to the class declaration
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
        try? await Task.sleep(nanoseconds: 100_000) // Small delay instead of fulfillment

        // Then
        XCTAssertEqual(viewModel.currentView, .uploadCV)
    }

    func testEnableNotificationsFlow() async {
        // Given
        mockNotifications.notificationStatus = .notDetermined

        // When
        mockNotifications.notificationStatus = .authorized
        let result = await viewModel.enableNotifications()

        // Then
        XCTAssertTrue(result)
        XCTAssertTrue(mockNotifications.authorizationRequested)
        await MainActor.run {
            XCTAssertEqual(viewModel.currentView, .uploadCV)
        }
    }
}

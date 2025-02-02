//
//  EnableNotificationsViewTests.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 29/01/2025.
//

import SwiftUI
import XCTest
@testable import Jobsy

@MainActor
final class EnableNotificationsViewTests: XCTestCase {
    var mockNotificationService: MockNotificationService!
    var mockApplication: MockApplicationService!
    var viewModel: OnboardingViewModel!

    @MainActor
    override func setUp() {
        super.setUp()
        mockNotificationService = MockNotificationService()
        mockApplication = MockApplicationService()
        viewModel = OnboardingViewModel(notificationService: mockNotificationService)
    }

    func testOpenSettingsWhenDenied() async {
        // Given
        let view = EnableNotificationsView(viewModel: viewModel)

        mockNotificationService.notificationStatus = .denied
        await viewModel.checkNotificationStatus()

        // When
        view.viewModel.isNotificationsPresented = true
        _ = await mockApplication.open(URL(string: UIApplication.openSettingsURLString)!)

        // Then
        XCTAssertEqual(mockApplication.urlsOpened.count, 1)
        XCTAssertEqual(mockApplication.urlsOpened.first?.absoluteString, UIApplication.openSettingsURLString)
    }

    func testEnableNotificationsWhenNotDetermined() async {
        // Given
        let view = EnableNotificationsView(viewModel: viewModel)

        mockNotificationService.notificationStatus = .notDetermined
        await viewModel.checkNotificationStatus()

        // When
        view.viewModel.isNotificationsPresented = true
        await viewModel.enableNotifications()

        // Then
        XCTAssertTrue(mockNotificationService.authorizationRequested)
    }

    func testNavigateToUploadCVWhenReturningFromSettings() async {
        // Given
        let _ = EnableNotificationsView(viewModel: viewModel)

        mockNotificationService.notificationStatus = .denied
        await viewModel.checkNotificationStatus()
        viewModel.selectRole(.candidate)

        // When
        mockNotificationService.notificationStatus = .authorized
        mockApplication.simulateDidBecomeActive()
        await viewModel.checkNotificationStatus()

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.currentView, .uploadCV)
        }
    }
}

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
    var mockNotifications: MockNotificationsManager!
    var mockApplication: MockApplicationService!
    var viewModel: OnboardingViewModel!

    @MainActor
    override func setUp() {
        super.setUp()
        mockNotifications = MockNotificationsManager()
        mockApplication = MockApplicationService()
        viewModel = OnboardingViewModel(notificationsManager: mockNotifications)
    }

    func testOpenSettingsWhenDenied() async {
        // Given
        let view = EnableNotificationsView(viewModel: viewModel)

        mockNotifications.notificationStatus = .denied
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

        mockNotifications.notificationStatus = .notDetermined
        await viewModel.checkNotificationStatus()

        // When
        view.viewModel.isNotificationsPresented = true
        await viewModel.enableNotifications()

        // Then
        XCTAssertTrue(mockNotifications.authorizationRequested)
    }

    func testNavigateToUploadCVWhenReturningFromSettings() async {
        // Given
        let _ = EnableNotificationsView(viewModel: viewModel)

        mockNotifications.notificationStatus = .denied
        await viewModel.checkNotificationStatus()
        viewModel.selectRole(.candidate)

        // When
        mockNotifications.notificationStatus = .authorized
        mockApplication.simulateDidBecomeActive()
        await viewModel.checkNotificationStatus()

        // Then
        await MainActor.run {
            XCTAssertEqual(viewModel.currentView, .uploadCV)
        }
    }
}

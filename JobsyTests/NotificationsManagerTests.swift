//
//  NotificationsManagerTests.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 28/01/2025.
//

@testable import Jobsy
import XCTest

class NotificationsManagerTests: XCTestCase {
    var manager: MockNotificationsManager!

    override func setUp() {
        super.setUp()
        manager = MockNotificationsManager()
    }

    // MARK: - Authorization Tests

    func testGetAuthorizedStatus() async {
        manager.notificationStatus = .authorized
        let status = await manager.getNotificationStatus()
        XCTAssertEqual(status, .authorized)
    }

    func testRequestAuthorizationSuccess() async throws {
        manager.notificationStatus = .authorized
        let granted = try await manager.requestAuthorization()
        XCTAssertTrue(granted)
        XCTAssertTrue(manager.authorizationRequested)
    }

    // MARK: - Notification Scheduling

    func testScheduleNotificationRemovesExisting() async throws {
        let request = NotificationRequest(
            identifier: "test",
            title: "Test",
            body: "Body",
            timeInterval: 10,
            repeats: false,
            preventsStackingNotifications: true
        )

        try await manager.scheduleNotification(request)

        XCTAssertEqual(manager.removedIdentifiers, ["test"])
        XCTAssertEqual(manager.scheduledNotifications.count, 1)
        XCTAssertEqual(manager.scheduledNotifications.first?.identifier, "test")
    }
}

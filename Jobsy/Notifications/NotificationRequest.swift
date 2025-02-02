//
//  NotificationRequest.swift
//  Jobsy
//
//  Created by Lucas West on 27/01/2025.
//

import SwiftUI

struct NotificationRequest: Equatable {
    let identifier: String
    let title: String
    let body: String
    let timeInterval: TimeInterval
    let repeats: Bool
    let preventsStackingNotifications: Bool
}

extension NotificationRequest {
    static let fortnightlyCheckNotification = NotificationRequest(
        identifier: "fortnightlyCheck",
        title: "Job Market Status Check",
        body: "Please confirm if you're still actively looking for opportunities",
        timeInterval: 14 * 24 * 60 * 60,
        repeats: true,
        preventsStackingNotifications: true
    )
}

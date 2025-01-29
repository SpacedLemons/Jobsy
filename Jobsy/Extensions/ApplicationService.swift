//
//  ApplicationService.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 29/01/2025.
//

import SwiftUI

@MainActor
protocol ApplicationService {
    var didBecomeActivePublisher: NotificationCenter.Publisher { get }
    func open(_ url: URL) async -> Bool
}

protocol NotificationPublishing {
    func publisher(for name: Notification.Name, object: AnyObject?) -> NotificationCenter.Publisher
}

protocol ApplicationProtocol { func open(_ url: URL) async -> Bool }

class UIApplicationService: ApplicationService {

    private let notificationCenter: NotificationPublishing
    private let application: ApplicationProtocol

    init(
        notificationCenter: NotificationPublishing = NotificationCenter.default,
        application: ApplicationProtocol = UIApplication.shared
    ) {
        self.notificationCenter = notificationCenter
        self.application = application
    }

    var didBecomeActivePublisher: NotificationCenter.Publisher {
        notificationCenter.publisher(
            for: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    func open(_ url: URL) async -> Bool {
        await application.open(url)
    }
}

extension UIApplication: ApplicationProtocol {
    func open(_ url: URL) async -> Bool {
        return await withCheckedContinuation { continuation in
            self.open(url, options: [:]) { success in
                continuation.resume(returning: success)
            }
        }
    }
}

extension NotificationCenter: NotificationPublishing {}

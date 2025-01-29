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

class UIApplicationService: ApplicationService {
    static let shared = UIApplicationService()

    var didBecomeActivePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
    }

    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}

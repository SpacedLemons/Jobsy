//
//  MockApplicationService.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 29/01/2025.
//

import SwiftUI
@testable import Jobsy

class MockApplicationService: ApplicationService {
    var didBecomeActivePublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: Notification.Name("MockDidBecomeActive"))
    }

    var urlsOpened: [URL] = []
    var didBecomeActiveCallback: (() -> Void)?

    func open(_ url: URL) async -> Bool {
        urlsOpened.append(url)
        return true
    }

    func simulateDidBecomeActive() {
        NotificationCenter.default.post(name: Notification.Name("MockDidBecomeActive"), object: nil)
    }
}

//
//  NotificationCenterProtocol.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 30/01/2025.
//

import Foundation

protocol NotificationCenterProtocol {
    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping @Sendable (Notification) -> Void) -> NSObjectProtocol
    func removeObserver(_ observer: Any)
    func post(name: NSNotification.Name, object: Any?)
}

extension NotificationCenter: NotificationCenterProtocol {}

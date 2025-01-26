//
//  OnboardingViewModel.swift
//  Jobsy
//
//  Created by Lucas West on 24/01/2025.
//

import SwiftUI

enum UserRole: String {
    case recruiter
    case candidate
}

final class OnboardingViewModel: ObservableObject {
    @Published var isFullScreenPresented = false
    @Published var selectedUserRole: UserRole?

    func selectRole(_ role: UserRole) {
        selectedUserRole = role
        isFullScreenPresented = true
    }

    func dismiss() {
        selectedUserRole = nil
        isFullScreenPresented = false
    }
}

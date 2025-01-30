//
//  OnboardingBackButton.swift.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 30/01/2025.
//

import SwiftUI

struct OnboardingBackButton: View {
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(buttonTitle)
        }
        .buttonStyle(.backStyle())
    }
}

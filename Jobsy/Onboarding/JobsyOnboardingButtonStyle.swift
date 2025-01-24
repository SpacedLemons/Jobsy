//
//  JobsyOnboardingButtonStyle.swift
//  Jobsy
//
//  Created by Lucas West on 24/01/2025.
//

import SwiftUI

extension ButtonStyle where Self == JobsyOnboardingButtonStyle {
    static func onboardingStyle() -> JobsyOnboardingButtonStyle {
        JobsyOnboardingButtonStyle()
    }
}

struct JobsyOnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

//
//  JobsyOnboardingButtonStyle.swift
//  Jobsy
//
//  Created by Lucas West on 24/01/2025.
//

import SwiftUI

extension ButtonStyle where Self == JobsyOnboardingButtonStyle {
    static func onboardingStyle(backgroundColor: Color) -> JobsyOnboardingButtonStyle {
        JobsyOnboardingButtonStyle(backgroundColor: backgroundColor)
    }
}

struct JobsyOnboardingButtonStyle: ButtonStyle {
    let backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview { WelcomeView() }

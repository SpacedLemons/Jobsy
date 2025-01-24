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
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview  { WelcomeView() }

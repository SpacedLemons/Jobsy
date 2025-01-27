//
//  EnableNotificationsView.swift
//  Jobsy
//
//  Created by Lucas West on 26/01/2025.
//

import SwiftUI

struct EnableNotificationsView: View {
    @StateObject var viewModel: OnboardingViewModel
    @State private var presentNotifications = false

    private let notificationDetailsText = """
This is so we can keep recruiters updated.

You will receive notifications every 2 weeks asking to confirm your position in the job market.
"""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Before we start...")
                .font(.title).bold()

            VStack(spacing: 20) {
                Text("We require you to enable notifications")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(notificationDetailsText)
                    .font(.footnote).bold()
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Button(action: { presentNotifications = true }, label: {
                    Text("Enable notifications")
                })
                .buttonStyle(.onboardingStyle())
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .padding(.horizontal)
        .task(id: presentNotifications) {
            guard presentNotifications else { return }
            _ = await viewModel.enableNotifications()
            presentNotifications = false
        }
    }
}

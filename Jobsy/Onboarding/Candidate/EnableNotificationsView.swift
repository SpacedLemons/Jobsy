//
//  EnableNotificationsView.swift
//  Jobsy
//
//  Created by Lucas West on 26/01/2025.
//

import SwiftUI

struct EnableNotificationsView: View {
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

                Button(action: {
                    print("Enable notifications button pressed")
                }, label: {
                    Text("Enable notifications")
                })
                .buttonStyle(.onboardingStyle())
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview { EnableNotificationsView() }

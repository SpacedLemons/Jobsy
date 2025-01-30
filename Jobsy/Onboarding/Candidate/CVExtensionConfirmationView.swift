//
//  CVExtensionConfirmationView.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 30/01/2025.
//

import SwiftUI

struct CVExtensionConfirmationView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Thank You!")
                .font(.largeTitle)
                .bold()

            Text("Your CV has been extended in our database for an additional 2 weeks.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { viewModel.closeApp() }, label: {
                Text("Close App")
            })
            .buttonStyle(.onboardingStyle())
            .padding(.horizontal, 50)
            Spacer()
        }
    }
}

#Preview { CVExtensionConfirmationView(viewModel: .init()) }

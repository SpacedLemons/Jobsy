//
//  UploadCVView.swift
//  Jobsy
//
//  Created by Lucas West on 26/01/2025.
//

import SwiftUI

struct UploadCVView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                OnboardingBackButton(
                    buttonTitle: "Back to selection",
                    action: viewModel.dismiss
                )
            }

            Spacer()

            VStack(spacing: 16) {
                Text("Thank you for choosing to use Jobsy!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text("All we need to start is your CV:")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 15) {
                Text("Click the button below to get started")
                    .font(.footnote)

                Button(action: { print("CV Uploaded Button Pressed") }, label: {
                    Text("Upload your CV")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.onboardingStyle())
                .frame(maxWidth: 300, minHeight: 50)
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding(.horizontal, 20)

            Text("We do not store your data or any personal information about you")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer(minLength: 16)
        }

    }
}

#Preview { UploadCVView(viewModel: .init()) }

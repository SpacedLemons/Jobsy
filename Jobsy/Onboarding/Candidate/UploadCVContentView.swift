//
//  UploadCVContentView.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 31/01/2025.
//

import SwiftUI

struct UploadCVContentView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var selectedFile = "Selected_File_That_Truncates_..."
    @State private var showSubmitButton = false

    var body: some View {
        VStack(spacing: 10) {
            Spacer()

            Text("Thank you for choosing to use Jobsy!")
                .font(.title2)
                .multilineTextAlignment(.center)

            Text("All we need to start is your CV:")
                .font(.title3)
                .foregroundStyle(.secondary)

            fileUploadSection

            disclaimerText

            Spacer()
        }
    }

    private var fileUploadSection: some View {
        VStack(spacing: 15) {
            if showSubmitButton {
                Text("Selected File: \(selectedFile)")
                    .font(.footnote)
                    .foregroundStyle(.primary)

                Text("Is this the CV you want to upload?")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button(action: { viewModel.isCVSubmitted.toggle() }, label: {
                    Text("Submit CV")
                })
                .buttonStyle(.onboardingStyle(backgroundColor: Color.green))
            } else {
                Text("Click the button below to get started")
                    .font(.footnote)
            }
            // Temporary toggle
            Button(action: { showSubmitButton.toggle() }, label: {
                Text("Upload Your CV")
            })
            .buttonStyle(.onboardingStyle(backgroundColor: Color.blue))
        }
        .padding(15)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal, 20)
    }

    private var disclaimerText: some View {
        Text("We do not store any of your personal data")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
    }
}

#Preview { UploadCVContentView(viewModel: .init()) }

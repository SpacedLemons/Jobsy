//
//  UploadCVContentView.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 31/01/2025.
//

import SwiftUI

struct UploadCVContentView: View {
    @ObservedObject var viewModel: OnboardingViewModel

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
        .fileImporter(
            isPresented: $viewModel.isPresentingFilePicker,
            allowedContentTypes: viewModel.allowedContentTypes,
            allowsMultipleSelection: false
        ) { result in
            viewModel.handleFileSelection(result: result)
        }
        .alert("File Selection Error",
               isPresented: .constant(viewModel.fileSelectionError != nil),
               presenting: viewModel.fileSelectionError) { _ in
            Button("OK", role: .cancel) { viewModel.fileSelectionError = nil }
        } message: { error in
            Text(error)
        }
    }

    private var fileUploadSection: some View {
        VStack(spacing: 15) {
            if let fileURL = viewModel.selectedFileURL {
                Text("Selected File: \(fileURL.lastPathComponent)")
                    .font(.footnote)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Text("Is this the CV you want to upload?")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Button(action: { viewModel.submitCV() }, label: {
                    Text("Submit CV")
                })
                .buttonStyle(.onboardingStyle(backgroundColor: .green))
            }

            if viewModel.selectedFileURL == nil {
                Text("Click the button below to get started")
                    .font(.footnote)
            }

            Button(action: { viewModel.isPresentingFilePicker = true }, label: {
                Text(viewModel.selectedFileURL == nil ?
                     "Upload Your CV" :
                        "Upload a different CV"
                )
            })
            .buttonStyle(.onboardingStyle(backgroundColor: .blue))
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

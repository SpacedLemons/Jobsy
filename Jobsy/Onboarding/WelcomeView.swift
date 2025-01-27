//
//  WelcomeView.swift
//  Jobsy
//
//  Created by Lucas West on 19/01/2025.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Jobsy")
                .font(.title).bold()
                .padding(.bottom, 20)

            Text("Which of these applies to you?")
                .font(.title2)
                .padding(.bottom, 20)

            VStack(spacing: 20) {
                Button(action: { viewModel.selectRole(.recruiter) }, label: {
                    Text("Recruiter")
                })
                .accessibilityLabel("Select Recruiter Role")
                .buttonStyle(.onboardingStyle())
                Button(action: { viewModel.selectRole(.candidate) }, label: {
                    Text("Candidate")
                })
                .buttonStyle(.onboardingStyle())
                .accessibilityLabel("Select Candidate Role")
            }
            .padding(.horizontal, 60)

            Text("Hint: A candidate is someone applying for jobs")
                .font(.footnote)
                .foregroundStyle(.gray)
                .padding(.top, 20)
            Spacer()
        }
        .padding()
        .fullScreenCover(
            isPresented: $viewModel.isFullScreenPresented,
            onDismiss: { viewModel.dismiss() },
            content: {
                Group {
                    switch viewModel.currentView {
                    case .notifications: EnableNotificationsView(viewModel: viewModel)
                    case .uploadCV: UploadCVView(viewModel: viewModel)
                    case .recruiter:
                        if let userRole = viewModel.selectedUserRole {
                            TempRecruiterView(viewModel: viewModel, userRole: userRole)
                        }
                    case .welcome: EmptyView()
                    }
                }
            }
        )
    }
}

#Preview { WelcomeView() }

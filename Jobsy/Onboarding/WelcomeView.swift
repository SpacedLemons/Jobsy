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
                .padding(.bottom, 40)

            VStack(spacing: 20) {
                Button(action: { viewModel.selectRole(.recruiter) }, label: {
                    Text("Recruiter")
                })
                .buttonStyle(.onboardingStyle())
                
                Button(action: { viewModel.selectRole(.candidate) }, label: {
                    Text("Candidate")
                })
                .buttonStyle(.onboardingStyle())
            }
            .padding(.horizontal, 60)
            
            Spacer()
        }
        .padding()
        .fullScreenCover(
            isPresented: $viewModel.isFullScreenPresented,
            onDismiss: { viewModel.dismiss() },
            content: {
                if let userRole = viewModel.selectedUserRole {
                    UserOnboardingView(userRole: userRole)
                }
            }
        )
    }
}

#Preview { WelcomeView() }

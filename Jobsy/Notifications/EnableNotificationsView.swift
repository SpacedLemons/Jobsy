//
//  EnableNotificationsView.swift
//  Jobsy
//
//  Created by Lucas West on 26/01/2025.
//

import SwiftUI

    struct EnableNotificationsView: View {
        @ObservedObject var viewModel: OnboardingViewModel
        @State var presentNotifications = false

        init(
            viewModel: OnboardingViewModel,
            application: ApplicationService = UIApplicationService.shared
        ) {
            self.viewModel = viewModel
            self.application = application
        }

        private var notificationButtonText: String {
            viewModel.notificationStatus == .denied ? "Open Settings to Enable Notifications" : "Enable Notifications"
        }

        private let application: ApplicationService
        private let notificationDetailsText = """
        We do this to ensure you're still looking for roles.

        You will receive notifications every 2 weeks asking to confirm your position in the job market.
        """

        var body: some View {
            VStack(spacing: 20) {
                Spacer()

                Text("Before we start...")
                    .font(.title).bold()

                VStack(spacing: 20) {
                    Text("To keep you up to date, we suggest enabling notifications")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Text(notificationDetailsText)
                        .font(.footnote).bold()
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Button(action: { presentNotifications = true }, label: {
                        Text(notificationButtonText)
                    })
                    .buttonStyle(.onboardingStyle())
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .padding(.horizontal)
            .task(id: presentNotifications) {
                guard presentNotifications else { return }
                if viewModel.notificationStatus == .denied {
                    openSettings()
                } else {
                    await viewModel.enableNotifications()
                }
                presentNotifications = false
            }
            .onReceive(application.didBecomeActivePublisher) { _ in
                Task {
                    await viewModel.checkNotificationStatus()
                }
            }
        }

        private func openSettings() {
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                Task {
                    await application.open(settingsUrl)
                }
            }
        }
    }

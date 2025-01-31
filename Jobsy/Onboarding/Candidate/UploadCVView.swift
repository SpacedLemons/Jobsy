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
        VStack {
            OnboardingBackButton(
                buttonTitle: "Back to Selection",
                action: viewModel.dismiss
            )
            if viewModel.isCVSubmitted {
                ScanningCVView(viewModel: viewModel)
            } else {
                UploadCVContentView(viewModel: viewModel)
            }
        }
    }
}
#Preview { UploadCVView(viewModel: .init()) }

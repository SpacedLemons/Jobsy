//
//  ScanningCVView.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 31/01/2025.
//

import SwiftUI

struct ScanningCVView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Scanning your CV")
                .font(.title).bold()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .padding()

            Text(viewModel.loadingMessages[viewModel.currentMessageIndex])
                .font(.headline)
                .lineLimit(1)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentMessageIndex)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { viewModel.startMessageLoop() }
        .onDisappear { viewModel.stopMessageLoop() }
    }
}

#Preview { ScanningCVView(viewModel: .init()) }

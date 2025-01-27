//
//  UploadCVView.swift
//  Jobsy
//
//  Created by Lucas West on 26/01/2025.
//

import SwiftUI

struct UploadCVView: View {
    @ObservedObject var viewModel = OnboardingViewModel()

    var body: some View {
        Button(action: { viewModel.dismiss() }, label: {
            HStack {
                Image(systemName: "arrow.backward")
                Text("Debug dismiss")
            }
        })
    }
}

#Preview { UploadCVView() }

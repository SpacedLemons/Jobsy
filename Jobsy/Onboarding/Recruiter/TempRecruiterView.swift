//
//  TempRecruiterView.swift
//  Jobsy
//
//  Created by Lucas West on 19/01/2025.
//

import SwiftUI

struct TempRecruiterView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let userRole: UserRole

    var body: some View {
        VStack {
            Button(action: { viewModel.dismiss() }, label: {
                HStack {
                    Image(systemName: "arrow.backward")
                    Text("Not a recruiter?")
                }
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.leading)
            })
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Text("You selected: \(userRole.rawValue.capitalized)")
                .font(.title2)
                .foregroundStyle(.gray)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    @Previewable var viewModel = OnboardingViewModel()
    TempRecruiterView(viewModel: viewModel, userRole: .recruiter)
}

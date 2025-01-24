//
//  UserOnboardingView.swift
//  Jobsy
//
//  Created by Lucas West on 19/01/2025.
//

import SwiftUI

struct UserOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    let userRole: UserRole

    var body: some View {
        VStack {
            Text("You selected: \(userRole.rawValue.capitalized)")
                .font(.title2)
                .foregroundStyle(.gray)

            Button(action: { dismiss() }, label: {
                Text("Candidate")
            })
            .buttonStyle(.onboardingStyle())

            Spacer()
        }
        .padding()
    }
}
#Preview {
    UserOnboardingView(userRole: .candidate)
    UserOnboardingView(userRole: .recruiter)
}

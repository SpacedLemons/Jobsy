//
//  BackButtonStyle.swift
//  Jobsy
//
//  Created by Lucas West-Rogers on 30/01/2025.
//

import SwiftUI

extension ButtonStyle where Self == BackButtonStyle {
    static func backStyle() -> BackButtonStyle {
        BackButtonStyle()
    }
}

struct BackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: "arrow.backward")
            configuration.label
        }
        .font(.headline)
        .foregroundStyle(.blue)
        .padding(.leading)
        .opacity(configuration.isPressed ? 0.9 : 1.0)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

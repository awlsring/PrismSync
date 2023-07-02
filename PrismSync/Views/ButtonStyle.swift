//
//  ButtonStyle.swift
//  PrismSync
//
//  Created by Matthew Rawlings on 7/1/23.
//
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(10)
            .frame(minWidth: 200, maxWidth: .infinity)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

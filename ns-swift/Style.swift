//
//  Style.swift
//  ns-swift
//
//  Created by John Costik on 3/2/21.
//
import SwiftUI

struct StandardButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(8)
            .background(configuration.isPressed ? Color.orange : .clear)
            .font(.callout)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.primary, lineWidth: 1)
            )
    }
}

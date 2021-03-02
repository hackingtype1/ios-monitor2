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
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.gray : .orange)
            .font(.callout)
        .cornerRadius(30)
    }
}

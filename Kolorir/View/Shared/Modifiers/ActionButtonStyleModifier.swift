//
//  ActionButtonStyleModifier.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 31/10/23.
//

import Foundation
import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    var width: CGFloat = 100
    var height: CGFloat = 50
    var color: Color = Color.background
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .background(
                Group {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 3, y: 3)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: -2, y: -2)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 2, y: 2)
                            .shadow(color: Color.white.opacity(0.7), radius: 2, x: -2, y: -2)
                    }
                }
            )
    }
}

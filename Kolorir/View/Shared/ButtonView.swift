//
//  ButtonView.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 30/10/23.
//

import SwiftUI

struct ButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "camera.fill")
                .foregroundColor(Color.theme)
                .padding()
        }
        .buttonStyle(ActionButtonStyle())
    }
}

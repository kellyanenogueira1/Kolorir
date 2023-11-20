//
//  BottomSheetView.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 31/10/23.
//

import Foundation
import SwiftUI

struct BottomSheetButton {
    let title: String
    let action: () -> Void
}

struct BottomSheetView: View {
    
    // MARK: CONSTANTS
    
    private enum Constants {
        static let buttonWidth: CGFloat = 200
        
        enum Index {
            static let first = 0
            static let second = 1
        }
    }
    
    // MARK: PROPERTYES
    
    var title: String = ""
    var buttons: [BottomSheetButton]
    
    @Binding var showSheet: Bool
    
    // MARK: UI
    
    var body: some View {
        ZStack {
            VStack(alignment: .trailing) {
                Button(action: {
                    showSheet = false
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.theme)
                })
                .padding(8)
                .buttonStyle(ActionButtonStyle(width: 50, height: 25))
                
                VStack(alignment: .center, spacing: 8) {
                    Text(title)
                    Button(
                        buttons[Constants.Index.first].title,
                        action: buttons[Constants.Index.first].action
                    ).buttonStyle(ActionButtonStyle(width: Constants.buttonWidth))
                    
                    Button(
                        buttons[Constants.Index.second].title,
                        action: buttons[Constants.Index.second].action
                    ).buttonStyle(ActionButtonStyle(width: Constants.buttonWidth))
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 24)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.background)
                    .shadow(color: Color.black.opacity(0.2), radius: 2)
            )

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

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
    
    // MARK: PROPERTYES
    
    var title: String = ""
    var buttons: [BottomSheetButton]
    
    // MARK: UI
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
            Button(buttons[0].title, action: buttons[0].action)
                .buttonStyle(ActionButtonStyle())
            
            Button(buttons[1].title, action: buttons[1].action)
                .buttonStyle(ActionButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

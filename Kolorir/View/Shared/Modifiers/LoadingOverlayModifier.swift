//
//  LoadingOverlayModifier.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 14/11/23.
//

import Foundation
import SwiftUI

struct LoadingOverlayModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ProgressLoadingView(isLoading: $isLoading)
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}

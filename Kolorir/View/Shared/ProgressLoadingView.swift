//
//  ProgressLoadingView.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 01/11/23.
//

import SwiftUI

struct ProgressLoadingView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ZStack {
                ProgressView("Carregando...")
                    .tint(Color.theme)
                    .foregroundColor(Color.theme)
                    .background(Color.clear)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        } else {
            EmptyView()
        }
    }
}

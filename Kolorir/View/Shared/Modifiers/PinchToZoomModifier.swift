//
//  PinchToZoomModifier.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 17/11/23.
//

import SwiftUI

struct PinchToZoomModifier: ViewModifier {
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    private var minScale: CGFloat {
        return min(scale, 1.0)
    }
    
    private var maxScale: CGFloat {
        return max(scale, 5.0)
    }

    var magnification: some Gesture {
        if #available(iOS 17.0, *) {
            return MagnifyGesture()
                .onChanged { value in
                    let delta =  value.magnification / lastScale
                    scale *= delta
                    lastScale = value.magnification
                }
                .onEnded { _ in
//                    withAnimation {
//                        scale = minScale
//                        scale = maxScale
//                    }
                    lastScale = 1.0
                }
        } else {
           return MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastScale
                    scale *= delta
                    lastScale = value
                }
                .onEnded { _ in
//                    withAnimation {
//                        scale = minScale
//                        scale = maxScale
//                    }
                    lastScale = 1.0
                }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: .center)
            .gesture(magnification)
    }
}

extension View {
    func pinchToZoom() -> some View {
        self.modifier(PinchToZoomModifier())
    }
}

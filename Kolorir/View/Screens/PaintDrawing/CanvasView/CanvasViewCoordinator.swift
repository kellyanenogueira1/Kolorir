//
//  CanvasViewCoordinator.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 01/11/23.
//

import SwiftUI
import PencilKit

class CanvasViewCoordinator: NSObject {
    
    // MARK: PROPERTYES
    
    @Binding var canvasView: PKCanvasView
    let onSaved: () -> Void
    
    // MARK: INITIALIZATION
    
    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        _canvasView = canvasView
        self.onSaved = onSaved
    }
}

// MARK: DELEATE

extension CanvasViewCoordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}

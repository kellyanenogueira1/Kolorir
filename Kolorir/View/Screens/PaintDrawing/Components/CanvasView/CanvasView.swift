//
//  CanvasView.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 01/11/23.
//
import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    
    // MARK: PROPERTYES
    
    @Binding var canvasView: PKCanvasView
//    @Binding var image: UIImage?
    @State var tool = PKToolPicker()
    let onSaved: () -> Void
    
    // MARK: METHODS
    
    func makeCoordinator() -> CanvasViewCoordinator {
        CanvasViewCoordinator(canvasView: $canvasView, onSaved: onSaved)
    }
    
    func makeUIView(context: Context) -> some UIView {
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
        canvasView.minimumZoomScale = 0.2
        canvasView.maximumZoomScale = 4.0
        
        // TODO: Zoom na imagem
        
//        let imageView = UIImageView(image: image ?? UIImage())
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        
//        let contentView = canvasView.subviews[0]
//        contentView.addSubview(imageView)
//        contentView.sendSubviewToBack(imageView)
//    
        canvasView.delegate = context.coordinator
       
        #if targetEnvironment(simulator)
        canvasView.drawingPolicy = .anyInput
        #endif
        
        showTools()
        return canvasView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    private func showTools() {
        tool.setVisible(true, forFirstResponder: canvasView)
        tool.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }
}

//
//  PaintDrawingView.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 01/11/23.
//

import SwiftUI
import PencilKit

struct PaintDrawingView: View {
    
    // MARK: PROPERTYES
    
    @StateObject var viewModel = PaintDrawingViewModel()
    @Binding var image: UIImage?
    @State private var canvasView = PKCanvasView()
    @State private var previewDrawing: PKDrawing? = nil
   
    // MARK: UI
 
    var body: some View {
        VStack {
            CanvasView(
                canvasView: $canvasView,
                image: $image,
                onSaved: onSaved
            )
        }
        .padding(8)
        .environmentObject(viewModel)
        .navigationTitle("Kolorir")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: { onClearTapped()}) { Image(systemName: "trash.fill") }
            Button(action: { onUndoTapped()}) { Image(systemName: "trash.slash.fill") }
            Button(action: { saveOnPhotosAlbum()}) { Image(systemName: "bookmark.fill") }
        }
    }
    
    // MARK: PRIVATE METHODS
    
    private func onClearTapped() {
        canvasView.drawing = PKDrawing()
    }
    
    private func onUndoTapped() {
        if let preview = previewDrawing {
            canvasView.drawing = preview
        }
    }
    
    private func saveOnPhotosAlbum() {
        guard let image = image, let previewDrawing = previewDrawing else { return }
        
        if let imagePainting = matchImages(baseImage: image, drawing: previewDrawing) {
            UIImageWriteToSavedPhotosAlbum(imagePainting, nil, nil, nil)
        }
    }
    
    private func matchImages(baseImage: UIImage, drawing: PKDrawing) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(baseImage.size, false, 0.0)
        baseImage.draw(in: CGRect(origin: CGPoint.zero, size: baseImage.size))
        let drawingImage = drawing.image(from: drawing.bounds, scale: UIScreen.main.scale)
        drawingImage.draw(in: CGRect(origin: CGPoint.zero, size: baseImage.size))
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
    }
    
    // MARK: INTERNAL METHODS
    
    func onSaved() {
        previewDrawing = canvasView.drawing
    }
}

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
    @State private var shouldClear = true
    @State private var showAlert = false
    
    // MARK: UI
    
    var body: some View {
       
        VStack {
            if let image = image {
                CanvasView(
                    canvasView: $canvasView,
                    image: Binding.constant(image),
                    onSaved: onSaved
                )
                .frame(width: image.size.width, height: image.size.height)
                .scaleEffect(
                    min(
                        UIScreen.main.bounds.width / (image.size.width),
                        UIScreen.main.bounds.height / (image.size.height)
                    )
                )
            }
        }
        .environmentObject(viewModel)
        .navigationTitle("Kolorir")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            let isEmptyDrawing = previewDrawing == nil
        
            Button(action: { clearIfNeeded()}) {
                let iconName = shouldClear ? "clear.fill" : "arrowshape.turn.up.left.circle.fill"
                Image(systemName: iconName)
            }.disabled(isEmptyDrawing)
            
            Button(action: { saveOnPhotosAlbum() }) {
                Image(systemName: "photo.badge.checkmark.fill")
            }.disabled(isEmptyDrawing)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Salvo na galeria ☑️"),
                dismissButton: .default(Text("Ok")) {
                    showAlert = false
                }
            )
        }
    }
    // MARK: PRIVATE METHODS
    
    private func clearIfNeeded() {
        if !shouldClear {
            onUndoTapped()
        } else {
            onClearTapped()
        }
        shouldClear.toggle()
    }
    
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
        
        if let imagePainting = viewModel.matchImages(
            baseImage: image,
            drawing: previewDrawing,
            canvasTransform: canvasView.transform
        ) {
            UIImageWriteToSavedPhotosAlbum(imagePainting, nil, nil, nil)
            showAlert = true
        }
    }
    
    // MARK: INTERNAL METHODS
    
    func onSaved() {
        previewDrawing = canvasView.drawing
    }
}

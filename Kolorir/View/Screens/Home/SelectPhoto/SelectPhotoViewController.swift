//
//  ImagePickerViewController.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 26/10/23.
//

import Foundation
import SwiftUI

struct SelectPhotoViewController: UIViewControllerRepresentable {
    
    // MARK: ALIAS
    
    typealias Coordinator = SelectPhotoCoordinator
    
    // MARK: PROPERTYES
    
    @ObservedObject var viewModel: HomeViewModel
    @Binding var isShown: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    
    // MARK: METHODS
    
    func makeCoordinator() -> SelectPhotoViewController.Coordinator {
        return SelectPhotoCoordinator(
            isShown: $isShown,
            viewModel: viewModel
        )
    }
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SelectPhotoViewController>
    ) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        
        if sourceType == .camera { picker.cameraFlashMode = .off }
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<SelectPhotoViewController>
    ) {
    }
}


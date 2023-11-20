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
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    // MARK: METHODS
    
    func makeCoordinator() -> SelectPhotoViewController.Coordinator {
        return SelectPhotoCoordinator(image: $image, isShown: $isShown)
    }
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SelectPhotoViewController>
    ) -> UIImagePickerController {
        let picker = UIImagePickerController()
//        picker.cameraFlashMode = .off
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<SelectPhotoViewController>
    ) {
    }
}


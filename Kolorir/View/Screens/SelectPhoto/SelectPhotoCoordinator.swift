//
//  SelectPhotoCoordinator.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 01/11/23.
//

import Foundation
import SwiftUI

class SelectPhotoCoordinator: NSObject {
    
    // MARK: PROPERTYES
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    
    // MARK: INITIALIZATION
    
    init(image: Binding<UIImage?>, isShown: Binding<Bool>) {
        _image = image
        _isShown = isShown
    }
   
}

// MARK: DELEGATE

extension SelectPhotoCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiimage
//            isShown = false
        }
        
        picker.pushViewController(
            UIHostingController(rootView: PaintDrawingView(image: image)),
            animated: false
        )
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

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

    @Binding var isShown: Bool
    var homeViewModel: HomeViewModel
    
    // MARK: INITIALIZATION
    
    init(
        isShown: Binding<Bool>,
        viewModel: HomeViewModel
    ) {
        _isShown = isShown
        self.homeViewModel = viewModel
    }
   
}

// MARK: DELEGATE

extension SelectPhotoCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            Task {
                isShown = false
                homeViewModel.isLoading = true
                await homeViewModel.processImage(uiimage)
            }
        } else {
            homeViewModel.showAlert = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

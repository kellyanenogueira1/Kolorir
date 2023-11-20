//
//  HomeView.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: PROPERTYES
    
    @StateObject var viewModel = HomeViewModel()
    @State var showImagePicker = false
    @State var showSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State private var inputImage: UIImage?
    
    // MARK: UI
    
    var body: some View {
        
        VStack {
            Image(systemName: "camera")
                .resizable()
                .frame(width: 300, height: 200)
                .padding(10)
            
            ButtonView(action: { showSheet = true })
            
            SelectPhotoPopUpView()
                .offset(y: showSheet ? .zero : UIScreen.main.bounds.height)
                .animation(.spring())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationTitle("Home")
        .environmentObject(viewModel)
        .fullScreenCover(isPresented: $showImagePicker) {
            SelectPhotoViewController(
                image: $inputImage,
                isShown: $showImagePicker,
                sourceType: self.sourceType
            )
        }
        
    }
    
    // MARK: VIEW BUILDERS
    
    @ViewBuilder
    private func SelectPhotoPopUpView() -> some View {
        BottomSheetView(
            title: "Selecione uma foto:",
            buttons: [
                BottomSheetButton(title: "Câmera", action: {
                    showSheet = false
                    showImagePicker = true
                    sourceType = .camera
                }),
                BottomSheetButton(title: "Galeria", action: {
                    showSheet = false
                    showImagePicker = true
                    sourceType = .photoLibrary
                })
            ],
            showSheet: $showSheet
        )
    }
}

// MARK: PREVIEWS

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

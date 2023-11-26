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
    
    @State private var isImagePickerPresented = false
    @State private var isSheetPresented = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    // MARK: UI
    
    var body: some View {
        
        VStack {
            Image(systemName: "camera") // TODO: Inserir logotipo
                .resizable()
                .frame(width: 300, height: 200)
                .padding(10)
            
            TakePhotoButtonView()

            NavigationLink(
                destination: PaintDrawingView(image: $viewModel.processedImage),
                isActive: $viewModel.isActiveLink,
                label: { EmptyView() }
            )
        }
        .loadingOverlay(isLoading: $viewModel.isLoading)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .environmentObject(viewModel)
        .sheet(isPresented: $isImagePickerPresented) {
            SelectPhotoViewController(
                viewModel: viewModel,
                isShown: $isImagePickerPresented,
                sourceType: $sourceType
            )
        }
    }
    
    // MARK: VIEW BUILDERS
    
    @ViewBuilder
    private func SelectPhotoPopUpView() -> some View {
        BottomSheetView(
            buttons: [
                BottomSheetButton(title: "Câmera", action: {
                    sourceType = .camera
                    isSheetPresented = false
                    isImagePickerPresented = true
                }),
                BottomSheetButton(title: "Galeria", action: {
                    sourceType = .photoLibrary
                    isSheetPresented = false
                    isImagePickerPresented = true
                    
                })
            ]
        )
    }
    
    @ViewBuilder
    private func TakePhotoButtonView() -> some View {
        Button(action: { isSheetPresented = true }) {
            HStack {
                Text("Escolher foto")
                Image(systemName: "camera.fill")
            }
            .foregroundColor(Color.theme)
        }
        .sheet(isPresented: $isSheetPresented) {
            SelectPhotoPopUpView()
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(40)
        }.buttonStyle(ActionButtonStyle())
    }
}

// MARK: PREVIEWS

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

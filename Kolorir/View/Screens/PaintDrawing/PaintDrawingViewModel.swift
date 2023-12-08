//
//  PaintDrawingViewModel.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 09/11/23.
//

import Foundation
import PencilKit
import SwiftUI

final class PaintDrawingViewModel: ObservableObject {
    // MARK: PROPERTYES
    
    // MARK: METHODS
    
    func matchImages(
        baseImage: UIImage, drawing: PKDrawing, canvasTransform: CGAffineTransform
    ) -> UIImage? {
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(baseImage.size, false, scale)
        baseImage.draw(in: CGRect(origin: CGPoint.zero, size: baseImage.size))
        
        let drawingTransform = canvasTransform.inverted()
        let transformedBounds = drawing.bounds.applying(drawingTransform)
        
        let drawingImage = drawing.image(from: transformedBounds, scale: scale)
        drawingImage.draw(in: transformedBounds)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }
}

//
//  PaintDrawingViewModel.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 09/11/23.
//

import CoreML
import Foundation
import SwiftUI

class PaintDrawingViewModel: ObservableObject {
    private var processedImage: UIImage? = nil
    @Published var isLoading: Bool = true
    
    func imageToDraw(_ inputImage: UIImage?) -> UIImage? {
        
        configureLoading { [weak self] in
            
            guard let self = self, let processedImage = applyStyleImage(inputImage) else {
                return
            }
            
            self.processedImage = processedImage
        }
        return processedImage
    }
    
    private func applyStyleImage(_ inputImage: UIImage?) -> UIImage? {
        guard let inputImage = inputImage else { return nil }
        let imageSize = CGSize(width: inputImage.size.width, height: inputImage.size.height)
        
        guard let stylezedImage = predictStyleTransfer(with: inputImage),
              let edgeHighlightingImage = edgeHighlighting(with: stylezedImage),
              let thresholdingImage = thresholding(with: edgeHighlightingImage),
              let outputImage = resizeImage(thresholdingImage, to: imageSize)
        else { return nil }
        
        return outputImage
    }
    
    private func configureLoading(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            completion()
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    // MARK: PREDIÇÃO
    
    private func predictStyleTransfer(with image: UIImage) -> UIImage? {
        let targetSize = CGSize(width: 512, height: 512)
        guard let resizedImage = resizeImage(image, to: targetSize) else { return nil }
        guard let styleTransferModel = try? DrawingML(configuration: MLModelConfiguration()) else { return nil }
        guard let inputPixelBuffer = convertToPixelBuffer(resizedImage) else { return nil }
        
        do {
            let prediction = try styleTransferModel.prediction(image: inputPixelBuffer)
            let outputPixelBuffer = prediction.stylizedImage
            guard let outputImage = convertToUIImage(outputPixelBuffer) else { return nil }
            
            return outputImage
        } catch {
            debugPrint("Erro durante a predição: \(error)")
            return nil
        }
    }
    
    private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    private func convertToPixelBuffer(_ image: UIImage) -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(image.size.width),
            Int(image.size.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess else { return nil }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: pixelData,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        
        guard let cgImage = image.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    private func convertToUIImage(_ pixelBuffer: CVPixelBuffer) -> UIImage? {
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
        
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        let context = CGContext(
            data: baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        
        guard let cgImage = context?.makeImage() else {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
            return nil
        }
        
        let image = UIImage(cgImage: cgImage)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
        
        return image
    }
    
    // MARK: DETECÇÃO DE BORDAS
    
    private func edgeHighlighting(with image: UIImage) -> UIImage? {
        guard let imageCI = CIImage(image: image),
              let filter = CIFilter(name: "CIEdges") else { return nil }
        
        filter.setValue(imageCI, forKey: kCIInputImageKey)
        
        guard let imageWithFilter = filter.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(imageWithFilter, from: imageWithFilter.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    // MARK: LIMIARIZAÇÃO
    
    private func thresholding(with image: UIImage) -> UIImage? {
        guard let imageCG = image.cgImage else { return nil }
        
        let width = imageCG.width
        let heigth = imageCG.height
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerLine = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: heigth, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerLine, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.draw(imageCG, in: CGRect(x: 0, y: 0, width: width, height: heigth))
        
        guard let data = context.data else { return nil }
        
        let pointer = data.bindMemory(to: UInt8.self, capacity: width * heigth * bytesPerPixel)
        
        for i in 0..<(width * heigth) {
            let index = i * bytesPerPixel
            let pixelValue = CGFloat(pointer[index]) / 255.0
            
            if pixelValue > 0.45 { // valor limiar
                pointer[index] = 55
                pointer[index + 1] = 55
                pointer[index + 2] = 55
            } else {
                pointer[index] = 255
                pointer[index + 1] = 255
                pointer[index + 2] = 255
            }
        }
        
        guard let imageCGModified = context.makeImage() else { return nil }
        
        let imageModified = UIImage(cgImage: imageCGModified)
        return imageModified
    }
}

//
    //  ImageUtitlities.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import Foundation
import UIKit
import CoreImage
import Photos
import CoreImage.CIFilterBuiltins

class ImageUtilities: ObservableObject {
    var images: [UIImage] = []
    func gaussianBlur(image: UIImage, blurRadius: CGFloat) -> UIImage {
        guard var ciImage =  CIImage(image: image), let ciFilter = CIFilter(name: "CIGaussianBlur") else {
            return image
        }
            /// crop out empty edges
        ciImage = ciImage.cropped(to: ciImage.extent.insetBy(dx: 4 * blurRadius, dy: 4 * blurRadius))
        
        ciFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        let outputImage = ciImage.applyingGaussianBlur(sigma: blurRadius)
        
        let context = CIContext(options: nil)
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    func zoomImage() {
    }
    func removeBlurEffect(image: UIImage) -> UIImage {
            // Reverses the effect of the gaussianBlur function by applying a blank CIFilter
        guard let ciImage = CIImage(image: image),
              let ciFilter = CIFilter(name: "CIAffineTransform") else {
            return image
        }
        
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = ciFilter.outputImage else {
            return image
        }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        
        return UIImage(cgImage: cgImage)
    }
    func rotateImage(image: UIImage, rotation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        let imageSize = CGSize(width: image.size.width, height: image.size.height)
        let imageRect = CGRect(origin: .zero, size: imageSize)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        context.draw(cgImage, in: imageRect)
        guard let newCGImage = context.makeImage() else {
            return nil
        }
        let newImage = UIImage(cgImage: newCGImage, scale: image.scale, orientation: rotation)
        return newImage
    }
}

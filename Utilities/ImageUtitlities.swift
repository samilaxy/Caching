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

    //class ImageUtilities: ObservableObject {
    //
    //    func gaussianBlur(image: UIImage, blurRadius: CGFloat) -> UIImage {
    //        guard var ciImage =  CIImage(image: image), let ciFilter = CIFilter(name: "CIGaussianBlur") else {
    //            return image
    //        }
    //            /// crop out empty edges
    //        ciImage = ciImage.cropped(to: ciImage.extent.insetBy(dx: 4 * blurRadius, dy: 4 * blurRadius))
    //
    //        ciFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
    //        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
    //
    //        let outputImage = ciImage.applyingGaussianBlur(sigma: blurRadius)
    //
    //        let context = CIContext(options: nil)
    //
    //        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
    //            return image
    //        }
    //
    //        return UIImage(cgImage: cgImage)
    //    }
    //    func zoomImage(image: UIImage, scale: CGFloat) -> UIImage? {
    //        guard let ciImage = CIImage(image: image) else { return nil }
    //
    //        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
    //        let filteredImage = ciImage.transformed(by: scaleTransform)
    //
    //        let context = CIContext(options: nil)
    //        guard let outputImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return nil }
    //
    //        return UIImage(cgImage: outputImage)
    //    }
    //    func removeBlurEffect(image: UIImage) -> UIImage {
    //            // Reverses the effect of the gaussianBlur function by applying a blank CIFilter
    //        guard let ciImage = CIImage(image: image),
    //              let ciFilter = CIFilter(name: "CIAffineTransform") else {
    //            return image
    //        }
    //
    //        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
    //
    //        guard let outputImage = ciFilter.outputImage else {
    //            return image
    //        }
    //
    //        let context = CIContext(options: nil)
    //        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
    //            return image
    //        }
    //
    //        return UIImage(cgImage: cgImage)
    //    }
    //    func rotateImage(image: UIImage, rotation: UIImage.Orientation) -> UIImage? {
    //        guard let cgImage = image.cgImage else {
    //            return nil
    //        }
    //        let imageSize = CGSize(width: image.size.width, height: image.size.height)
    //        let imageRect = CGRect(origin: .zero, size: imageSize)
    //        let colorSpace = CGColorSpaceCreateDeviceRGB()
    //        guard let context = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
    //            return nil
    //        }
    //        context.draw(cgImage, in: imageRect)
    //        guard let newCGImage = context.makeImage() else {
    //            return nil
    //        }
    //        let newImage = UIImage(cgImage: newCGImage, scale: image.scale, orientation: rotation)
    //        return newImage
    //    }
    //
    //}


import UIKit
import CoreImage

struct ImageUtilities {
    func gaussianBlur(image: UIImage, blurRadius: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = ciImage
        filter.radius = Float(blurRadius)
        guard let outputImage = filter.outputImage else { return nil }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    func zoomImage(image: UIImage, scale: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
        let filteredImage = ciImage.transformed(by: scaleTransform)
        
        let context = CIContext(options: nil)
        guard let outputImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return nil }
        
        return UIImage(cgImage: outputImage)
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
    
    func getImageDimensions(image: UIImage) -> (width: CGFloat, height: CGFloat)? {
        let imageSize = image.size
        let scale = image.scale
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return (width, height)
    }
    
    func addImageFrame(to frameImage: UIImage, image: UIImage) -> UIImage? {
        let imageSize = image.size
        var width = 0.0
        var height = 0.0
        if let size = getImageDimensions(image: image) {
            width = size.width
            height = size.height
        }
        let frameSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, image.scale)
            // Draw the original image
        image.draw(in: CGRect(origin: .zero, size: imageSize))
            // Calculate the frame position and size
        let frameOrigin = CGPoint(x: (imageSize.width - frameSize.width) / 2, y: (imageSize.height - frameSize.height) / 2)
        let frameRect = CGRect(origin: frameOrigin, size: frameSize)
            // Draw the frame image
        frameImage.draw(in: frameRect)
            // Retrieve the merged image
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return mergedImage
    }
    
    func frameImage(item: ButtonItem, image: UIImage) -> UIImage {
        var selectedFrame: UIImage = UIImage(systemName: "photo")!
        var returnedImg: UIImage = UIImage(systemName: "photo")!
        switch (item.id) {
            case 1 :
                if let frame =  UIImage(named: item.icon){
                    selectedFrame = frame
                }
            case 2 :
                if let frame =  UIImage(named: item.icon){
                    selectedFrame = frame
                }
            case 3 :
                if let frame =  UIImage(named: item.icon){
                    selectedFrame = frame
                }
            case 4 :
                if let frame =  UIImage(named: item.icon){
                    selectedFrame = frame
                }
            case 5 :
				if let frame =  UIImage(named: ""){
					selectedFrame = frame
				}
            default : break
        }
        
        if let unwrappedImage = addImageFrame(to: selectedFrame, image: image) {
            returnedImg = unwrappedImage
        }
        return returnedImg
    }
}

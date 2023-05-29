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

class ImageUtilities: ObservableObject {
    var images: [UIImage] = []
    func gaussianBlur(image: UIImage, blurRadius: CGFloat) -> UIImage {
        guard let ciImage =  CIImage(image: image), let ciFilter = CIFilter(name: "CIGaussianBlur") else {
            return image
        }
        
        ciFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        let outputImage = ciImage.applyingGaussianBlur(sigma: blurRadius)
        
        let context = CIContext(options: nil)
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage)
    }
    
    
}

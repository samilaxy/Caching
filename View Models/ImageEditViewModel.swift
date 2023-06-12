//
//  ImageEditViewModel.swift
//  Caching
//
//  Created by Noye Samuel on 06/06/2023.
//

import Foundation
import SwiftUI
import CoreData


class ImageEditViewModel: ObservableObject {
    @Published var image: UIImage = UIImage(systemName: "photo")!
    @Published var isProgress = false
    @Published var isDone = false
	@Published var index = 0
    @Published var isBlur = false
    @Published var showAlert = false
    @Published var isMenuOpen = false
    @Published var selectedButton: ButtonItem?
    @Published var rotateValue = 0
    @Published var orientation: UIImage.Orientation = .right
    @Published var zoomScale: CGFloat = 1.0
	@Published var isframed: Bool = false
	@Published var frameImg = ""
    @Environment(\.colorScheme) var colorScheme
    let menuItems = [
        ButtonItem(id: 1, name: "Black Frame", icon: "BlackFrame"),
        ButtonItem(id: 2, name: "Dark Wood Frame", icon: "DarkWoodFrame"),
        ButtonItem(id: 3, name: "Gold Frame", icon: "GoldFrame"),
        ButtonItem(id: 4, name: "Light Wood Frame", icon: "LightWoodFrame"),
        ButtonItem(id: 5, name: "None", icon: "")
    ]
    let buttons = [
        ButtonItem(id: 1, name: "Blur", icon: "button.programmable.square.fill"),
        ButtonItem(id: 2, name: "Frame", icon: "photo.artframe"),
        ButtonItem(id: 3, name: "Zoom", icon: "plus.magnifyingglass"),
        ButtonItem(id: 4, name: "Rotate", icon: "gobackward"),
        ButtonItem(id: 5, name: "Revert", icon: "clear"),
        ButtonItem(id: 6, name: "Save", icon: "square.and.arrow.down.fill")
    ]
    @Environment(\.presentationMode) var presentationMode
    var imgUitility = ImageUtilities()
    var originalImg: UIImage?
    
    func blurImage() {
        isProgress = true
        DispatchQueue.global().async { [self] in
            if let img = self.originalImg {
                if let blurredImage = imgUitility.gaussianBlur(image: img, blurRadius: 5.0) {
                    
                    DispatchQueue.main.async {
                        self.image = blurredImage
                        self.isProgress = false
                        self.isBlur = true
                    }
                }
            }
        }
    }
     
    func revertImage() {
        if let img = originalImg {
            image = img
            rotateValue = 0
            zoomScale = 1.0
            orientation = .right
        }
    }
    
    func frameImage(item: ButtonItem) {
     //   if let img = image {
            image = imgUitility.frameImage(item: item, image: image)
		frameImg = item.icon
     //   }
    }
    
    func editOption(item: ButtonItem) {
        switch item.id {
            case 1:
                blurImage()
            case 2:
                isMenuOpen = true
            case 3:
                isMenuOpen = false
            case 4:
                rotateValue += 1
                rotateImage()
            case 5:
                revertImage()
            default:
                break
        }
    }
    func rotateImage() {
        rotateValue = (rotateValue % 4) + 1
        let orientations: [UIImage.Orientation] = [.right, .down, .left, .up]
        orientation = orientations[rotateValue - 1]
        image = imgUitility.rotateImage(image: image, rotation: orientation) ?? originalImg!
    }
}

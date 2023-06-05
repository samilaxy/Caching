    //
    //  ImageEditView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI
import UIKit
struct ImageEditView: View {
    @State var image: UIImage = UIImage(systemName: "photo")!
    @State var isProgress = false
    @State var isDone = false
    @State var isBlur = false
    @State private var isMenuOpen = false
    @State private var selectedButton: ButtonItem?
    let menuItems = [ButtonItem(id: 1, name: "Black Frame", icon: "BlackFrame"),
                     ButtonItem(id: 2, name: "Dark Wood Frame", icon: "DarkWoodFrame"),
                     ButtonItem(id: 3, name: "Gold Frame", icon: "GoldFrame"),
                     ButtonItem(id: 4, name: "Light Wood Frame", icon: "LightWoodFrame")]
    var buttons = [ButtonItem(id: 1, name: "Blur", icon: "button.programmable.square.fill"),
                   ButtonItem(id: 2, name: "Frame", icon: "photo.artframe"),
                   ButtonItem(id: 3, name: "Zoom", icon: "plus.magnifyingglass"),
                   ButtonItem(id: 4, name: "Rotate", icon: "rotate.left"),
                   ButtonItem(id: 5, name: "Revert", icon: "clear"),
                   ButtonItem(id: 6, name: "Done", icon: "square.and.arrow.down.fill")
    ]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    var imgUitility = ImageUtilities()
    @State var originalImg: UIImage?
    var body: some View {
        
        VStack {
            if !isProgress {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 400)
                    .padding()
                    .onAppear {
                        if originalImg == nil {
                            originalImg = image
                        }
                    }
                    ////
                VStack {
                    HStack(spacing: 10) {
                        Spacer()
                        ForEach(buttons, id: \.id) { button in
                            if button.id == 2 {
                                Button {
                                    isMenuOpen.toggle()
                                } label: {
                                    VStack {
                                        Image(systemName: button.icon)
                                            .font(.system(size: 15))
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(button.id == 6 ? Color.gray : Color.blue)
                                            .clipShape(Circle())
                                        Text(button.name)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color.gray)
                                    }
                                }
                                
                            } else {
                                Button {
                                    DispatchQueue.main.async {
                                        editOption(item: button)
                                    }
                                } label: {
                                    VStack {
                                        Image(systemName: button.icon)
                                            .font(.system(size: 15))
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(button.id == 6 ? Color.gray : Color.blue)
                                            .clipShape(Circle())
                                        Text(button.name)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color.gray)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                } .overlay(
                    menuOverlay
                        .opacity(isMenuOpen ? 1 : 0)
                        .animation(.easeInOut, value: 2)
                )
                
                Spacer()
                
            } else {
                ProgressView()
            }
        }
        .navigationBarTitle("Edit Image", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
        })
    }
    
    @ViewBuilder
    private var menuOverlay: some View {
        if isMenuOpen {
            Color.clear
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isMenuOpen = false
                }
                .overlay(
                    VStack(alignment: .leading , spacing: 10) {
                        ForEach(menuItems, id: \.id) { item in
                            Button(action: {
                                    // Handle menu item action
                                isMenuOpen = false
                                frameImage(item: item)
                                    // Perform action for menu item
                            }) {
                                HStack {
                                        // Image(item.icon)
                                    Text(item.name)
                                }
                                .foregroundColor(.black.opacity(0.7))
                            }
                            Divider()
                        }
                    }.frame(width: 200)
                        .padding()
                        .background(Color.gray.opacity(1))
                        .cornerRadius(10)
                        .padding(30)
                )
        }
    }
    
    func saveImage() {
            // Create a new Image entity
        let newImage = ImageData(context: moc)
        newImage.img = originalImg
        newImage.blur = image
        newImage.createAt = Date()
        
        do {
            try self.moc.save() // Save the changes to Core Data
            print("image saved..")
        } catch {
                // Handle the error
            print("Failed to save image: \(error)")
        }
    }
    func blurImage() {
        isProgress = true
            //  originalImg = image
        DispatchQueue.global().async {
            if let img = originalImg {
                let blurredImage = imgUitility.gaussianBlur(image: img, blurRadius: 5.0)
                
                DispatchQueue.main.async {
                    image = blurredImage
                    isProgress = false
                    isBlur = true
                }
            }
        }
    }
    
    func applyZoomEffect(image: UIImage, zoomScale: CGFloat) -> UIImage? {
        let newSize = CGSize(width: image.size.width * zoomScale, height: image.size.height * zoomScale)
        let newRect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: newRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func getImageDimensions(image: UIImage) -> (width: CGFloat, height: CGFloat)? {
        let imageSize = image.size
        let scale = image.scale
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return (width, height)
    }
    func addImageFrame(to frameImage: UIImage) -> UIImage? {
        let imageSize = image.size
        var width = 0.0
        var height = 0.0
        if let size = getImageDimensions(image: image) {
            width = size.width
            height = size.height
        }else{
            
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
    func frameImage(item: ButtonItem) {
        var selectedFrame:UIImage = UIImage(systemName: "photo")!
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
            default : break
        }
        
        if let unwrappedImage = addImageFrame(to: selectedFrame) {
            image = unwrappedImage
            print(unwrappedImage)
        }
    }
    
    func zoomImage() {
        
    }
    func rotateImage() {
        
    }
    func revertImage() {
        if let img = originalImg {
            image = img
        }
    }
    func editOption(item: ButtonItem) {
        switch (item.id) {
            case 1 :
                    //blur
                blurImage()
                print(item.name)
            case 2 :
                    //  isMenuOpen = true
                withAnimation {
                    isMenuOpen.toggle()
                }
                print(item.name)
            case 3 :
                    //zoom
                
                print(item.name)
            case 4 :
                print(item.name)
            case 5 :
                revertImage()
                print(image)
                print(item.name)
            case 6 :
                print(item.name)
            default : break
        }
    }
}
struct ImageEditView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditView()
    }
}

struct ButtonItem: Identifiable {
    var id: Int
    var name: String
    var icon: String
}


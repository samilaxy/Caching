    //
    //  ImageEditView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI

struct ImageEditView: View {
    @State var image: UIImage = UIImage(systemName: "photo")!
    @State var isProgress = false
    @State var isBlur = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    var imgUitility = ImageUtilities()
    @State var originalImg: UIImage = UIImage(systemName: "photo")!
    var body: some View {
        NavigationView {
            VStack {
                if !isProgress {
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        if !isBlur {
                            Button("Blur") {
                                isProgress = true
                                originalImg = image
                                DispatchQueue.global().async {
                                    let blurredImage = imgUitility.gaussianBlur(image: image, blurRadius: 10.0)
                                    
                                    DispatchQueue.main.async {
                                        image = blurredImage
                                        isProgress = false
                                        isBlur = true
                                    }
                                }
                            }
                        } else {
                            Button("Save") {
                                isProgress = true
                                DispatchQueue.global().async {
                                    saveImage()
                                    DispatchQueue.main.async {
                                        isProgress = false
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }
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
}
struct ImageEditView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditView()
    }
}


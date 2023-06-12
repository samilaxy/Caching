//
//  ImageView.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import SwiftUI
import Combine

//    struct ImageView: View {
//
//        @StateObject var imageLoader: ImageLoaderVM
//        @StateObject var stateManager: ImageViewStateManager
//        @Environment(\.managedObjectContext) var moc
//        init(imageUrl: String, key: String) {
//            _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
//            _stateManager = StateObject(wrappedValue: ImageViewStateManager(url: URL(string: imageUrl), key: key))
//        }
//
//        var body: some View {
//            VStack {
//                if imageLoader.isLoading {
//                    ProgressView()
//                } else {
//                    Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
//                        .resizable()
//                        .onAppear {
//                            self.saveImage()
//                        }
//                 }
//            }
//            .frame(height: 200)
//            .padding(.all, 4)
//            .onDisappear {
//                    // Save state
//                stateManager.url = imageLoader.url
//                stateManager.key = imageLoader.imgKey
//            }
//        }
//        private func saveImage() {
//                // Create a new Image entity
//            if let img = imageLoader.image {
//                let newImage = ImageData(context: moc)
//                newImage.img = img
//                newImage.blur = img
//                newImage.createAt = Date()
//                do {
//                    try self.moc.save() // Save the changes to Core Data
//                    print("saved to core data")
//                } catch {
//                        // Handle the error
//                    print("Failed to save image: \(error)")
//                }
//            }
//        }
//    }


//
//  ViewModel.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine
import UIKit
import CoreData

class ViewModel: ObservableObject {
    @Published var images: [UnsplashImage] = []
    @Published var isLoading = true
    var networkManager = NetworkManager()
    
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.getImages()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func getImages() {
        self.isLoading = true
        guard images.isEmpty else { return }
        networkManager.getImages()
            .sink { _ in
                self.isLoading = false
            } receiveValue: { [weak self] returnedImages in
                self?.images.append(contentsOf: returnedImages)
            //    self?.saveImagesToCoreData(returnedImages) // Save images to Core Data
            }
            .store(in: &cancellables)
    }
    
    private func saveImagesToCoreData(_ images: [UnsplashImage]) {
        for image in images {
            guard let imageURL = URL(string: image.urls.regular) else {
                print("Invalid image URL: \(image.urls.regular)")
                continue
            }
            
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Failed to load image: \(error)")
                    return
                }
                
                guard let data = data, let uiImage = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }
                
                let imageEntity = ImageData(context: self.viewContext)
                imageEntity.img = uiImage
                imageEntity.blur = uiImage
                imageEntity.createAt = Date()
                
                    // Save any other properties you want to store
                print("Save image to Core Data: \(uiImage)")
                do {
                    try self.viewContext.save()
                } catch {
                        // Handle the error gracefully
                    print("Failed to save image to Core Data: \(error)")
                }
                
            }.resume()
            
        }
    }

}


//
//  ViewModel.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine
import UIKit

class ViewModel: ObservableObject {
    
    private let cache = ImageCache.shared
    private let cacheManager = CacheManager.shared
    @Published var images: [UnsplashImage] = []
    var networkManager = NetworkManager()
    
    init(dataService: NetworkManager) {
        self.networkManager = dataService
        self.getImages()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func getImages(){
        
        guard images.isEmpty else { return }
        networkManager.getImages()
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedimages in
                self?.images = returnedimages
                self?.saveToChache(images: returnedimages)
            }
            .store(in: &cancellables)
    }
    
    func saveToChache(images: [UnsplashImage]) {
        var temImage: UIImage? = nil
       
        for image in images {
            temImage = UIImage(named: image.urls.regular)
            CacheManager.shared.addToCache(image: temImage, name: image.id)
        }
    }
}

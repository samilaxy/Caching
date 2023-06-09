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
    
    @Published var images: [UnsplashImage] = []
    @Published var isLoading = true
    var networkManager = NetworkManager()
    
    init() {
        self.getImages()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func getImages() {
      //  guard images.count == 200 else { return }
        self.isLoading = true
        guard images.isEmpty else { return }
        networkManager.getImages()
            .sink { _ in
                self.isLoading = false
            }  receiveValue: { [weak self] returnedimages in
                self?.images.append(contentsOf: returnedimages)
            }
            .store(in: &cancellables)
    }
    func getMoreImages() {
        self.isLoading = true
        networkManager.getImages()
            .sink { _ in
                self.isLoading = false
            }  receiveValue: { [weak self] returnedImages in
                self?.images.append(contentsOf: returnedImages)
            }
            .store(in: &cancellables)
    }
}

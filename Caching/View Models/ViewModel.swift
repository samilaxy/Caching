//
//  ViewModel.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    private let cache = ImageCache.shared
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
            }
            .store(in: &cancellables)
    }
}

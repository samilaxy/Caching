//
//  File.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine
import UIKit

class ImageLoaderVM: ObservableObject {
    @Published var image: UIImage?
    
    private let url: URL
    private var cancellable: AnyCancellable?
    let cache = ImageCache.shared
    
    init(url: URL) {
        self.url = url
        self.load()
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        if let image = cache["\(url)"] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                if let image = image {
                    self?.cache["\(String(describing: self?.url))" ] = image
                }
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

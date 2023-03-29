//
//  ImageView.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import SwiftUI
import Combine

    struct ImageView: View {
    
        @StateObject var imageLoader: ImageLoader
        
        init(imageUrl: String) {
            _imageLoader = StateObject(wrappedValue: ImageLoader(url: URL(string: imageUrl)!))
        }
        
        var body: some View {
            VStack {
                Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .frame(height: 200)
                    .onAppear {
                        imageLoader.load()
                    }
            }.padding(.all, 4)
        }
    }
    
    struct ImageDetailView: View {
        @StateObject var imageLoader: ImageLoader
        
        init(imageUrl: String) {
            _imageLoader = StateObject(wrappedValue: ImageLoader(url: URL(string: imageUrl)!))
        }
        
        var body: some View {
            Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
                .resizable()
                .onAppear {
                    imageLoader.load()
                }
        }
    }


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private let url: URL
    private var cancellable: AnyCancellable?
    private let cache = ImageCache.shared
    
    init(url: URL) {
        self.url = url
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


class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    subscript(_ key: String) -> UIImage? {
        get { cache.object(forKey: NSString(string: key)) }
        set { newValue == nil ? cache.removeObject(forKey: NSString(string: key)) : cache.setObject(newValue!, forKey: NSString(string: key)) }
    }
}

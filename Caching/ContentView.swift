//
//  ContentView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    static let dataService = NetworkManager()
    var body: some View {
        NavigationView {
            ImageGridView(dataService: ContentView.dataService)
                .navigationBarTitle("Unsplash Images")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UnsplashImage: Decodable {
    let id: String
    let urls: UnsplashImageUrls
}

struct UnsplashImageUrls: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}



class ImageLoaderVM: ObservableObject {
    
    @Published var images: [UnsplashImage] = []
    var networkManager = NetworkManager()
    
    init(dataService: NetworkManager) {
        self.networkManager = dataService
        self.getImages()
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func getImages(){
        networkManager.getImages()
            .sink { _ in
                
            }  receiveValue: { [weak self] returnedimages in
                self?.images = returnedimages
            }.store(in: &cancellables)
        print("imagesqwer",images)
    }
}

class NetworkManager {
    
    func getImages() -> AnyPublisher<[UnsplashImage], Error> {
        var request =  URLRequest(url: URL(string: "https://api.unsplash.com/photos/random?count=10")!)
        let apiKey = "dixtqIxMkkn0gBKvye_yGfKHH3dUxemwT_QwBFwYW04"
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: [UnsplashImage].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

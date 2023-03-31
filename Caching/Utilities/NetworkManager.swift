//
//  NetworkManager.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine

class NetworkManager {
    
    func getImages() -> AnyPublisher<[UnsplashImage], Error> {
        var request =  URLRequest(url: URL(string: "https://api.unsplash.com/photos/random?count=100")!)
        let apiKey = "dixtqIxMkkn0gBKvye_yGfKHH3dUxemwT_QwBFwYW04"
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: [UnsplashImage].self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

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

        guard let requestURL =   URL(string: fetchSecret(secret: .BaseURL)) else {
            return Fail(error: URLError.wrongURL).eraseToAnyPublisher()
        }
        var request = URLRequest(url: requestURL)
        let apiKey = fetchSecret(secret: .ApiKey)
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: [UnsplashImage].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func fetchSecret(secret: Secrets) -> String{
        let fetchedLink = Bundle.main.object(forInfoDictionaryKey: secret.rawValue) as? String
        guard let secretURL = fetchedLink, !(secretURL.isEmpty ) else {
            fatalError("URL is empty")
        }
        return secret == .BaseURL ? "https://\(secretURL)": secretURL
    }
    enum Secrets: String {
        case BaseURL
        case ApiKey
    }
    enum URLError: Error {
        case wrongURL
    }
}



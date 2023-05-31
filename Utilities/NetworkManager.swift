//
//  NetworkManager.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import Combine

class NetworkManager {
    
    func getImages() -> AnyPublisher<[UnsplashImage], APIError> {

        let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as! String
        print("apiKey", apiKey)
       let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String 
        print("baseUrl", baseUrl)
        guard let url = URL(string: "https://\(baseUrl)count=20")  else {
            return Fail(error: .badUrl).eraseToAnyPublisher()
        }
        print("url:",url)
        var request =  URLRequest(url: url)
        
        request.setValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        
        return  URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: [UnsplashImage].self, decoder: JSONDecoder())
            .mapError { APIError.decodingError(error: $0)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum APIError: Error {
    case badUrl
    case decodingError(error: Error)
}

extension APIError {
    var detail: String {
        switch self {
        case .badUrl:
                return "fdfjkndk"
        case .decodingError(error: let error):
                return error.localizedDescription
        }
    }
}

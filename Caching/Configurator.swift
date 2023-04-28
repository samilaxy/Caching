//
//  Configurator.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 28/04/2023.
//

import Foundation
final class Configurator {
    let shared = Configurator()
    func fetchBaseURL() -> String{
        let fetchedLink = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String
        guard let secretURL = fetchedLink, !(secretURL.isEmpty ) else {
            fatalError("URL is empty")
        }
        return "https://\(secretURL)"
    }
    func fetchApiKey() -> String{
        let fetchedLink = Bundle.main.object(forInfoDictionaryKey: "apiKey") as? String
        guard let secretKey = fetchedLink, !(secretKey.isEmpty ) else {
            fatalError("API Key is empty")
        }
        return secretKey
    }
}

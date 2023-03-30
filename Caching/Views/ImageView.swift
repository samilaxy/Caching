//
//  ImageView.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import SwiftUI
import Combine

    struct ImageView: View {
    
        @StateObject var imageLoader: ImageLoaderVM
        
        init(imageUrl: String) {
            _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!))
        }
        
        var body: some View {
            VStack {
                Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .frame(height: 200)
            }.padding(.all, 4)
        }
    }
    
    struct ImageDetailView: View {
        @StateObject var imageLoader: ImageLoaderVM
        
        init(imageUrl: String) {
            _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!))
        }
        
        var body: some View {
            Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
                .onAppear {
                    imageLoader.load()
                }
        }
    }


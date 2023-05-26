//
//  ImageDetailView.swift
//  Caching
//
//  Created by Noye Samuel on 25/05/2023.
//

import SwiftUI

struct ImageDetailView: View {
    @StateObject var imageLoader: ImageLoaderVM
    @State private var route = false
    init(imageUrl: String, key: String) {
        _imageLoader = StateObject(wrappedValue: ImageLoaderVM(url: URL(string: imageUrl)!, key: key))
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: imageLoader.image ?? UIImage(systemName: "photo")!)
                .resizable()
                .navigationBarTitle("Image View", displayMode: .inline)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Spacer()
        }.sheet(isPresented: $route) {
            imageLoader.image.map {ImageEditView(image: $0) }
        }.navigationBarItems(trailing: Button(action: {
                route = true
            }){
                Image(systemName: "square.and.pencil")
            })
    }
}

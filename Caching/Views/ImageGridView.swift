//
//  ImageGridView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI

struct ImageGridView: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(dataService: NetworkManager) {
        _viewModel = StateObject(wrappedValue: ViewModel(dataService: dataService))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                    //ForEach(viewModel.images) { image in
                        ForEach((0..<viewModel.images.count), id: \.self) { index in
                            NavigationLink(destination: ImageDetailView(imageUrl: viewModel.images[index].urls.thumb)) {
                                ImageView(imageUrl: viewModel.images[index].urls.regular)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Unsplash Images")
        }
        .onAppear {
                //  viewModel.loadImages()
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static let dataService = NetworkManager()
    static var previews: some View {
        ImageGridView(dataService: dataService)
    }
}

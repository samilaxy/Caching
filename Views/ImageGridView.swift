//
//  ImageGridView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI


struct ImageGridView: View {
    @StateObject var viewModel: ViewModel
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    @State var currentPage = 1
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                    ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                        ForEach(viewModel.images.indices, id: \.self) { index in
                            NavigationLink(destination: ImageDetailView(images: viewModel.images, selectedIndex: index)) {
                                ImageView(imageUrl: viewModel.images[index].urls.thumb, key: viewModel.images[index].id)
                                    .onAppear {
                                        if viewModel.images.count == index + 1 {
                                            DispatchQueue.main.async {
                                                viewModel.getMoreImages()
                                            } 
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(.leading, 4)
                .padding(.trailing, 4)
                .navigationBarTitle("Image FX")
            }
        }
    }
}


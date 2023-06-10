    //
    //  ImageDetailView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI
import Combine

struct ImageDetailView: View {
        @StateObject var imageEditViewModel = ImageEditViewModel()
        var images: [ImageData]
            //  var selectedIndex: Int
        @State var currentIndex: Int = 0
        @State private var route = false
        @State private var image: UIImage? = nil // Add default value
        
        var body: some View {
            VStack {
                Spacer()
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        if let uiImage = images[index].img {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(height: 400)
                                .tag(index)
                                .onAppear {
                                    currentIndex = index
                                    image = uiImage
                                }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .navigationDestination(isPresented: $route) {
                    image.map {    ImageEditView(editViewModel: imageEditViewModel, image: $0) }
                }
                Spacer()
            }
            .padding(.bottom, 40)
            .navigationBarItems(trailing: Button(action: {
                if currentIndex < images.count {
                    image.map {  imageEditViewModel.image = $0 }
                    route = true
                }
            }) {
                Image(systemName: "square.and.pencil")
            })
        }
    }


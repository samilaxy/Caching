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
    
    
    var body: some View {
        VStack {
            Spacer()
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    if let uiImage = images[index].img {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(height: 450)
                            .tag(index)
                            .onAppear {
                                currentIndex = index
                            }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .navigationDestination(isPresented: $route) {
                ImageEditView(editViewModel: imageEditViewModel)
            }
            Spacer()
        }
        .padding(.bottom, 40)
        .navigationBarItems(trailing: Button(action: {
            if currentIndex < images.count {
                imageEditViewModel.image = images[currentIndex].img!
                route = true
            }
        }) {
            Image(systemName: "square.and.pencil")
        })
    }
}

struct ImageLoader: View {
    let url: URL
    let imageLoaded: (UIImage?) -> Void
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(height: 500)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadImage(from: url)
        }
    }
    
    @State private var image: UIImage?
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }

            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    image = loadedImage
                    imageLoaded(loadedImage)
                }
            }
        }
        .resume()
    }
}


extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}


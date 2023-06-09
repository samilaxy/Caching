    //
    //  ImageDetailView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI
import Combine

    //struct ImageDetailView: View {
    //    var images: [UnsplashImage]
    //    @Environment(\.managedObjectContext) var managedObjectContext
    //    @StateObject var imageEditViewModel = ImageEditViewModel()
    //
    //    @State private var route = false
    //    var selectedIndex: Int
    //    @State private var currentIndex: Int = 0
    //    @State private var image: UIImage?
    //    @Environment(\.colorScheme) var colorScheme
    //
    //    var body: some View {
    //
    //        VStack {
    //            Spacer()
    //            if let img = image {
    //                Image(uiImage: img)
    //                    .resizable()
    //                    .frame(height: 400)
    //                    .clipShape(RoundedRectangle(cornerRadius: 15))
    //                    .padding()
    //                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
    //            } else {
    //                ProgressView()
    //            }
    //            HStack(spacing: 10) {
    //                Spacer()
    //                Button(action: {
    //                    if currentIndex > 0 {
    //                        currentIndex -= 1
    //                        loadImage()
    //                    }
    //                }) {
    //                    Image(systemName: "arrow.backward.circle.fill")
    //                        .renderingMode(.template)
    //                        .font(.system(size: 40))
    //                }
    //                .disabled(currentIndex == 0)
    //
    //                Button(action: {
    //                    if currentIndex < images.count - 1 {
    //                        currentIndex += 1
    //                        loadImage()
    //                    }
    //                }) {
    //                    Image(systemName: "arrow.forward.circle.fill")
    //                        .renderingMode(.template)
    //                        .font(.system(size: 40))
    //                }
    //                .disabled(currentIndex == images.count - 1)
    //                Spacer()
    //            }
    //            Spacer()
    //        }
    //        .padding(.bottom, 30)
    //        .onAppear {
    //            currentIndex = selectedIndex
    //            loadImage()
    //        }
    //        .gesture(
    //            DragGesture()
    //                .onEnded { gesture in
    //                    let swipeThreshold: CGFloat = 100
    //
    //                    if gesture.translation.width > swipeThreshold {
    //                        if currentIndex > 0 {
    //                            currentIndex -= 1
    //                            loadImage()
    //                        }
    //                    } else if gesture.translation.width < -swipeThreshold {
    //                        if currentIndex < images.count - 1 {
    //                            currentIndex += 1
    //                            loadImage()
    //                        }
    //                    }
    //                }
    //        )
    //        .navigationDestination(isPresented: $route, destination: {
    //            ImageEditView(editViewModel: imageEditViewModel)
    //        })
    //        .navigationBarItems(trailing: Button(action: {
    //            if let image = image {
    //                imageEditViewModel.image = image
    //                route = true
    //            }
    //        }){
    //            Image(systemName: "square.and.pencil")
    //        })
    //    }
    //    private func loadImage() {
    //        let urlString = images[currentIndex].urls.regular
    //        guard let url = URL(string: urlString) else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, _, _ in
    //            guard let data = data, let loadedImage = UIImage(data: data) else { return }
    //
    //            DispatchQueue.main.async {
    //                image = loadedImage
    //            }
    //        }.resume()
    //    }
    //}

struct ImageDetailView: View {
    var images: [UnsplashImage]
    @Environment(\.managedObjectContext) var managedObjectContext
    @StateObject var imageEditViewModel = ImageEditViewModel()
    
    @State private var route = false
    var selectedIndex: Int
    @State private var currentIndex: Int = 0
    @State private var image: UIImage? = nil // Add default value
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()

            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    loadImage(at: index)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
        }
        .padding(.bottom, 30)
        .onAppear {
            currentIndex = selectedIndex
            loadImage(at: currentIndex)
        }
        .navigationDestination(isPresented: $route, destination: {
            ImageEditView(editViewModel: imageEditViewModel)
        })
        .navigationBarItems(trailing: Button(action: {
            if let image = image {
                imageEditViewModel.image = image
                route = true
            }
        }){
            Image(systemName: "square.and.pencil")
        })
    }
    
    func loadImage(at index: Int) -> some View {
        let urlString = images[index].urls.regular
        guard let url = URL(string: urlString) else { return AnyView(EmptyView()) }
        
        return ImageLoader(url: url) { image in
            self.image = image
        }
        .eraseToAnyView()
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
                    .frame(height: 400)
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


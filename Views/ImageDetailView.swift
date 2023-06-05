//
//  ImageDetailView.swift
//  Caching
//
//  Created by Noye Samuel on 25/05/2023.
//

import SwiftUI

struct ImageDetailView: View {
    var images: [UnsplashImage]
    @State private var route = false
    var selectedIndex: Int
    @State private var currentIndex: Int = 0
    @State private var image: UIImage?
    
    var body: some View {
    //    NavigationStack {
            VStack {
                Spacer()
                Image(uiImage: image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                            loadImage()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .padding()
                    .disabled(currentIndex == 0)
                    
                    Spacer()
                    
                    Button(action: {
                        if currentIndex < images.count - 1 {
                            currentIndex += 1
                            loadImage()
                        }
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .disabled(currentIndex == images.count - 1)
                    Spacer()
                }
                Spacer()
            }
            .onAppear {
                currentIndex = selectedIndex
                loadImage()
            }
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        let swipeThreshold: CGFloat = 100
                        
                        if gesture.translation.width > swipeThreshold {
                            if currentIndex > 0 {
                                currentIndex -= 1
                                loadImage()
                            }
                        } else if gesture.translation.width < -swipeThreshold {
                            if currentIndex < images.count - 1 {
                                currentIndex += 1
                                loadImage()
                            }
                        }
                    }
            )
            .navigationDestination(isPresented: $route, destination: {
                image.map {ImageEditView(image: $0)}
            })
            .navigationBarItems(trailing: Button(action: {
                route = true
                print(route)
            }){
                Image(systemName: "square.and.pencil")
            })
        }
  //  }
    private func loadImage() {
        let urlString = images[currentIndex].urls.regular
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let loadedImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                image = loadedImage
            }
        }.resume()
    }
}

                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                


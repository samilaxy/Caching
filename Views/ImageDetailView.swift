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
	@State var index: Int = 0
    @State private var route = false
    @State var image: UIImage? = nil
    
    var body: some View {
        VStack {
            Spacer()
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    if let uiImage = images[index].img {
                        Image(uiImage: uiImage)
                            .resizable()
                          //  .frame(width: UIScreen.main.bounds.width, height: nil)
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .onAppear {
								self.index = index
                                image = uiImage
                            }
                            .tag(index)
                    }
				}.onAppear {
					currentIndex = index
				}
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .navigationDestination(isPresented: $route) {
                ImageEditView(editViewModel: imageEditViewModel)
            }
            Spacer()
        }
        .padding(.bottom, 40)
        .navigationBarItems(trailing:
                                Button(action: {
            if currentIndex < images.count {
                image.map { imageEditViewModel.image = $0
                    route = true }
            }
        }) {
            Image(systemName: "square.and.pencil")
        })
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                    // Additional animations or actions when the view appears
            }
        }
    }
}


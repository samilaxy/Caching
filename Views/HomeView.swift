//
//  HomeView.swift
//  Caching
//
//  Created by Noye Samuel on 09/06/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var route = false
    @State private var gridLayout: [GridItem] = [GridItem(.flexible())]
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: ImageData.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ImageData.createAt, ascending: false)],
        animation: .default
    ) private var images: FetchedResults<ImageData>
    
    @State private var selectedImageIndex: Int = 0
    @State private var isShowDelete = false
    @State private var isShowingImageDetail = false
    @State private var imageArray: [ImageData] = []
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                    ForEach(images.indices, id: \.self) { index in
                        if let uiImage = images[index].blur {
                            ZStack(alignment: .bottomTrailing) {
                                Image(uiImage: uiImage as! UIImage)
                                    .resizable()
                                    .frame(height: 200)
                                    .padding(.all, 4)
                                    .onTapGesture {
                                        selectedImageIndex = index
                                        isShowingImageDetail = true
                                        imageArray = Array(images)
                                    }
                                
                                Color.black.opacity(0.2)
                                    .frame(height: 200)
                                    .padding(.all, 4)
                                    .opacity(isShowDelete ? 1 : 0)
                                VStack {
                                    Button {
                                        if selectedImageIndex < images.count {
                                            let image = images[selectedImageIndex]
                                            if isShowDelete {
                                                deleteImage(image)
                                            } else {
                                                
                                            }
                                        }
                                    } label: {
                                        Image(systemName: isShowDelete ? "trash.circle.fill" : "heart.circle.fill")
                                            .foregroundColor(.red)
                                            .padding()
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
            .navigationBarItems(trailing: Button(action: {
                isShowDelete.toggle()
            }) {
                Image(systemName: isShowDelete ? "list.bullet.circle.fill" : "list.bullet.circle")
            })
            .navigationDestination(isPresented: $isShowingImageDetail) {
                ImageDetailView(images: imageArray, currentIndex: selectedImageIndex)
            }
        }
    }
    
    private func deleteImage(_ image: ImageData) {
        viewContext.delete(image)
        
        do {
            try viewContext.save()
        } catch {
                // Handle the error gracefully
            print("Failed to delete image: \(error)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct ImageDetailView1: View {
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


    //
    //  SavedImagesView.swift
    //  CachingTests
    //
    //  Created by Noye Samuel on 26/05/2023.
    //

import SwiftUI

struct SavedImagesView: View {
    @State private var route = false
    @State private var gridLayout: [GridItem] = [ GridItem(.flexible()) ]
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: ImageData.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ImageData.createAt, ascending: false)],
				  predicate: NSPredicate(format: "favorite == true"),
                  animation: .default)
    private var images: FetchedResults<ImageData>
    @State private var imageArray: [ImageData] = []
    @State var selectedImage: ImageData = ImageData()
    @State private var isShowingImageDetail = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: gridLayout.count % 3 + 1), alignment: .center, spacing: 10) {
                    ForEach(images, id: \.self) { imageEntity in
                        if let uiImage = imageEntity.blur {
                            Image(uiImage: uiImage as! UIImage)
                                .resizable()
                                .frame(height: 200)
                                .padding(.all, 4)
                                .onTapGesture {
                                    selectedImage = imageEntity
                                    isShowingImageDetail = true
                                    imageArray = Array(images)
                                }
                        }
                    }
                }
            }
            .padding(.leading, 4)
            .padding(.trailing, 4)
            .navigationBarTitle("Favorites", displayMode: .inline)
            .sheet(isPresented: $isShowingImageDetail) {
                SavedImageView(image: $selectedImage, images: $imageArray)
            }
        }
    }
}


struct SavedImagesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedImagesView()
    }
}

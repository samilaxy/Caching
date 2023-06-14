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
	@Environment(\.managedObjectContext) private var viewContext
	var images: FetchedResults<ImageData>
		//var selectedIndex: Int
	@State var currentIndex: Int = 0
	@State var index: Int = 0
	@State private var route = false
	@State var image: ImageData?
	@State var selectedImg: UIImage? = nil
	
	var body: some View {
		VStack {
			Spacer()
			TabView(selection: $currentIndex) {
				ForEach(images.indices, id: \.self) { index in
					if let uiImage = images[index].blur {
						Image(uiImage: uiImage as! UIImage)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.padding(5)
							.onAppear {
								DispatchQueue.main.async {
									self.index = index
									UserDefaults.standard.set(index, forKey: "Index")
								print(	UserDefaults.standard.integer(forKey: "Index"))
								}
							}
							.tag(index)
					}
				}.onAppear {
					DispatchQueue.main.async {
						currentIndex = index
					}
				}
				.onDisappear{
					currentIndex = index
				//	image.map { imageEditViewModel.image = $0 }
				}
			}
			.onChange(of: index) { newIndex in
				if let uiImage = images[newIndex].img {
				//	image = uiImage
				//	image.map { imageEditViewModel.image = $0 }
				// imageEditViewModel.index = index
					print("onChange:",newIndex)
				}
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			.navigationBarItems(trailing:
									HStack {
				Button(action: {
					if currentIndex < images.count {
						images[currentIndex].favorite.toggle()
						updateFavorite(for: images[currentIndex], isFavorite: images[currentIndex].favorite)
					}
				}) {
					Image(systemName: "heart.fill")
						.foregroundColor(images[currentIndex].favorite ? .red : .gray)
				}
				Button(action: {
					if currentIndex < images.count {
						images[currentIndex].blur.map { imageEditViewModel.image = $0 as! UIImage }
						route = true
						image = images[currentIndex]
						print("navigationBarItems:",currentIndex)
					}
				}) {
					Image(systemName: "square.and.pencil")
				}
			}
			)
		}
		.padding(.bottom, 40)
		.navigationBarTitleDisplayMode(.inline)
		.navigationDestination(isPresented: $route) {
			image.map{	 ImageEditView(editViewModel: imageEditViewModel, image: $0) }
		}
	}
	private func updateFavorite(for imageEntity: ImageData, isFavorite: Bool) {
			// Update the favorite property of the ImageData object
		imageEntity.favorite = isFavorite
		
			// Save the changes to Core Data
		do {
			try viewContext.save()
		} catch {
				// Handle the error gracefully
			print("Failed to update favorite status: \(error)")
		}
	}
}





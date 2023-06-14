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
	@State private var imageArray: [ImageData] = []
	private let widthSize = UIScreen.main.bounds.width * 0.24
	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), alignment: .center, spacing: 0) {
					ForEach(images.indices, id: \.self) { index in
						if let uiImage = images[index].blur {
							ZStack(alignment: .bottomTrailing) {
								Image(uiImage: uiImage as! UIImage)
									.resizable()
									.frame(width: widthSize, height: widthSize)
									.padding(.all, 2)
									.onTapGesture {
										selectedImageIndex = index
										route = true
									}
									.onAppear {
										print("count:",images.count)
									}
								
								Color.black.opacity(0.2)
									.frame(height: widthSize)
									.padding(.all, 2)
									.opacity(isShowDelete ? 1 : 0)
								
								VStack {
									Button {
										if index < images.count {
											let image = images[index]
											if isShowDelete {
												deleteImage(image)
											} else {
												images[index].favorite.toggle()
												updateFavorite(for: image, isFavorite: images[index].favorite)
											}
										}
									} label: {
										if isShowDelete {
											Image(systemName: "trash.circle.fill")
												.font(.system(size: 15))
												.foregroundColor(.red)
												.padding(8)
										} else {
											Image(systemName: "heart.circle.fill")
												.font(.system(size: 15))
												.foregroundColor(images[index].favorite ? .red : .gray)
												.padding(8)
										}
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
			.navigationDestination(isPresented: $route) {
				ImageDetailView(images: images, currentIndex: selectedImageIndex)
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

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}


//struct ImageDetailView1: View {
//	@StateObject var imageEditViewModel = ImageEditViewModel()
//	var images: [ImageData]
//		//  var selectedIndex: Int
//	@State var currentIndex: Int = 0
//	@State private var route = false
//
//
//	var body: some View {
//		VStack {
//			Spacer()
//			TabView(selection: $currentIndex) {
//				ForEach(images.indices, id: \.self) { index in
//					if let uiImage = images[index].img {
//						Image(uiImage: uiImage)
//							.resizable()
//							.frame(height: 450)
//							.tag(index)
//							.onAppear {
//								currentIndex = index
//							}
//					}
//				}
//			}
//			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//			.navigationDestination(isPresented: $route) {
//				ImageEditView(editViewModel: imageEditViewModel, image: <#ImageData#>)
//			}
//			Spacer()
//		}
//		.padding(.bottom, 40)
//		.navigationBarItems(trailing: Button(action: {
//			if currentIndex < images.count {
//				imageEditViewModel.image = images[currentIndex].img!
//				route = true
//			}
//		}) {
//			Image(systemName: "square.and.pencil")
//		})
//	}
//}


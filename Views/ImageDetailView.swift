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
		//var selectedIndex: Int
	@State var currentIndex: Int = 0
	@State var index: Int = 0
	@State private var route = false
	@State var image: UIImage? = nil
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
									//self.index = index
									image = uiImage as? UIImage
								}
								print("ForEach:",index)
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
					image = uiImage
					image.map { imageEditViewModel.image = $0 }
					imageEditViewModel.index = index
					print("onChange:",currentIndex)
				}
			}
			.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
			.navigationBarItems(trailing:
									Button(action: {
				if currentIndex < images.count {
					image = images[currentIndex].img
					image.map { imageEditViewModel.image = $0 }
					route = true
					print("navigationBarItems:",currentIndex)
				}
			}) {
				Image(systemName: "square.and.pencil")
			}
			)
		}
		.padding(.bottom, 40)
		.navigationBarTitleDisplayMode(.inline)
		.navigationDestination(isPresented: $route) {
			image.map { ImageEditView(editViewModel: imageEditViewModel, image: $0) }
		}
	}
}





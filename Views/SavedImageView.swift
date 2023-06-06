    //
    //  SavedImageView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 28/05/2023.
    //

import SwiftUI


struct SavedImageView: View {
    @Binding var image: ImageData
    @Binding var images: [ImageData]
    @State private var showBlurredImage = true
    @State var index: Int = 0
    @State var selectImg: UIImage?
    @State private var offset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                if let img = selectImg {
                    Image(uiImage: img)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                        .offset(x: offset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = gesture.translation.width
                                }
                                .onEnded { gesture in
                                    if gesture.translation.width < 0 {
                                        handleSwipeRight(num: 1)
                                    } else if gesture.translation.width > 0 {
                                        handleSwipeRight(num: -1)
                                    }
                                    offset = 0
                                }
                        )
                } else {
                    ProgressView()
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        if index > 0 {
                            index = index - 1
                            setImage()
                        }
                    },label: {
                        Image(systemName: "arrow.backward.circle.fill")
                            .renderingMode(.template)
                            .font(.system(size: 40))
                    }).disabled(index == 0)
                    
                    Button( action: {
                        if index < images.count - 1 {
                            index = index + 1
                            setImage()
                        }
                    },label: {
                        Image(systemName: "arrow.forward.circle.fill")
                            .renderingMode(.template)
                            .font(.system(size: 40))
                    }).disabled(index == images.count - 1)
                }
                .onAppear {
                    for(index, item) in images.enumerated() {
                        if image.id == item.id {
                            self.index = index
                            setImage()
                        }
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
            }
            .navigationBarTitle("Image", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
    func handleSwipeRight(num: Int) {
        if index > 0 && num < 0 {
            index = index + num
            setImage()
        } else if (index < images.count - 1) && num > 0 {
                index = index + num
                setImage()
            }
        }
        

    func setImage() {
        DispatchQueue.main.async {
            if let img = images[index].blur {
                selectImg = img as? UIImage
            }
        }
    }
}

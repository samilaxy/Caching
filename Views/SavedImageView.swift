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
                        ).animation(.easeOut(duration: 0.5))
                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        if index > 0 {
                            index = index - 1
                            setImage()
                        }
                    },label: {
                        Image(systemName: "arrow.backward.circle.fill")
                            .font(.system(size: 30))
                    })
                    Button( action: {
                        if index < images.count - 1 {
                            index = index + 1
                            setImage()
                        }
                    },label: {
                        Image(systemName: "arrow.forward.circle.fill")
                            .font(.system(size: 30))
                    })
                    
                }
                .onAppear {
                    for(index, item) in images.enumerated() {
                        if image.id == item.id {
                            self.index = index
                            setImage()
                        }
                    }
                    print("images:", images)
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
            }
            .padding()
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
            if let img = images[index].img {
                selectImg = img
            }
        }
    }
}

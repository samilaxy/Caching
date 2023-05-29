    //
    //  SavedImageView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 28/05/2023.
    //

import SwiftUI


struct SavedImageView: View {
    @Binding var image: ImageData
    @State private var showBlurredImage = true
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                if showBlurredImage {
                    Image(uiImage: (image.blur as? UIImage) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                } else {
                    Image(uiImage:  (image.img) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                }
                
                Button(action: {
                    showBlurredImage.toggle()
                }) {
                    Text(showBlurredImage ? "Show Original" : "Show Blurred")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
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
}





    //struct SavedImageView: View {
    //        @State var image: ImageData
    //        @Environment(\.presentationMode) var presentationMode
    //        @State var isBlurred = false
    //        var imgUitility = ImageUtilities()
    //    @State var originalImg: UIImage = (image.blur ?? UIImage(systemName: "photo"))
    //        var body: some View {
    //            NavigationView {
    //                VStack {
    //
    //                        Spacer()
    //                    Image(uiImage: originalImg )
    //                            .resizable()
    //                            .clipShape(RoundedRectangle(cornerRadius: 15))
    //                            .frame(height: 400)
    //                            .padding()
    //
    //                        Spacer()
    //
    //                        HStack(spacing: 30) {
    //                            Button("Blur") {
    //                                isBlurred = true
    //
    //                                DispatchQueue.global().async {
    //
    //                                    DispatchQueue.main.async {
    //                                        originalImg = image.blur as! UIImage
    //                                        isBlurred = false
    //                                    }
    //                                }
    //                            }
    //                            Button("Original") {
    //                                isBlurred = true
    //                                DispatchQueue.global().async {
    //                                   //originalImg
    //                                    DispatchQueue.main.async {
    //                                        isBlurred = false
    //                                        originalImg = image.img!
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                .navigationBarTitle("Image", displayMode: .inline)
    //                .navigationBarItems(trailing: Button(action: {
    //                    presentationMode.wrappedValue.dismiss()
    //                }) {
    //                    Image(systemName: "xmark")
    //                })
    //            }
    //        }
    //
    //    }

    //struct SavedImageView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        SavedImageView(image: UIImage(systemName: "photo")!)
    //    }
    //}

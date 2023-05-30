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
               
                Image(uiImage: (showBlurredImage ? image.img : image.blur) as! UIImage )
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
    
                Toggle(isOn: $showBlurredImage) {
                    Text(showBlurredImage ? "Show Blurred" : "Show Original")
                        .font(.headline)
                        .foregroundColor(.primary)
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
}


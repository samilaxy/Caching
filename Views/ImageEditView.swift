    //
    //  ImageEditView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI

struct ImageEditView: View {
    @State var image: UIImage = UIImage(systemName: "photo")!
    var imgUitility = ImageUtilities()
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: image)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(height: 400)
                .padding()
            Spacer()
            Button("Blur") {
                image =  imgUitility.gaussianBlur(image: image, blurRadius: 20.0)
            }
        }.navigationTitle("Edit Image")
    }
}


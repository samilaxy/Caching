    //
    //  ImageEditView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI

struct ImageEditView: View {
    @State var image: UIImage = UIImage(systemName: "photo")!
    @State var isProgress = false
    @Environment(\.presentationMode) var presentationMode
    var imgUitility = ImageUtilities()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                if !isProgress {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(height: 400)
                        .padding()
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        Button("Blur") {
                            isProgress = true
                            
                            DispatchQueue.global().async {
                                let blurredImage = imgUitility.gaussianBlur(image: image, blurRadius: 20.0)
                                
                                DispatchQueue.main.async {
                                    image = blurredImage
                                    isProgress = false
                                }
                            }
                        }
                        Button("Save") {
                            isProgress = true
                            
                            DispatchQueue.global().async {

                                DispatchQueue.main.async {
                                    isProgress = false
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(MyProgressViewStyle(color: .red))
                }
            }
            .navigationBarTitle("Edit Image", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
}
struct ImageEditView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditView()
    }
}

struct MyProgressViewStyle: ProgressViewStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(color)
    }
}

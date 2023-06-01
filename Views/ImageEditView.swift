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
    @State var isDone = false
    @State var isBlur = false
    @State private var isMenuOpen = false
    @State private var selectedButton: ButtonItem?
    let menuItems = [ButtonItem(id: 1, name: "Black Frame", icon: "BlackFrame"),
                     ButtonItem(id: 2, name: "Dark Wood Frame", icon: "DarkWoodFrame"),
                     ButtonItem(id: 3, name: "Gold Frame", icon: "GoldFrame"),
                     ButtonItem(id: 4, name: "Light Wood Frame", icon: "LightWoodFrame")]
    var buttons = [ButtonItem(id: 1, name: "Blur", icon: "button.programmable.square.fill"),
                   ButtonItem(id: 2, name: "Frame", icon: "photo.artframe"),
                   ButtonItem(id: 3, name: "Zoom", icon: "plus.magnifyingglass"),
                   ButtonItem(id: 4, name: "Rotate", icon: "rotate.left"),
                   ButtonItem(id: 5, name: "Revert", icon: "clear"),
                   ButtonItem(id: 6, name: "Done", icon: "square.and.arrow.down.fill")
    ]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    var imgUitility = ImageUtilities()
    @State var originalImg: UIImage = UIImage(systemName: "photo")!
    var body: some View {
        
        VStack {
            if !isProgress {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(height: 400)
                    .padding()
                ////
                VStack {
                    HStack(spacing: 10) {
                        Spacer()
                        ForEach(buttons, id: \.id) { button in
                            if button.id == 2 {
                                Button {
                                    isMenuOpen.toggle()
                                } label: {
                                    VStack {
                                        Image(systemName: button.icon)
                                            .font(.system(size: 15))
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(button.id == 6 ? Color.gray : Color.blue)
                                            .clipShape(Circle())
                                        Text(button.name)
                                            .font(.system(size: 10))
                                            .foregroundColor(button.id == 6 ? Color.gray : Color.white)
                                    }
                                }
                                
                            } else {
                                Button {
                                    editOption(item: button)
                                } label: {
                                    VStack {
                                        Image(systemName: button.icon)
                                            .font(.system(size: 15))
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(button.id == 6 ? Color.gray : Color.blue)
                                            .clipShape(Circle())
                                        Text(button.name)
                                            .font(.system(size: 10))
                                            .foregroundColor(button.id == 6 ? Color.gray : Color.white)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }.overlay(
                        menuOverlay
                    )
                }
            ////
                Spacer()
                
            } else {
                ProgressView()
            }
        }
        .navigationBarTitle("Edit Image", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
        })
    }
    
    @ViewBuilder
    private var menuOverlay: some View {
        if isMenuOpen {
            GeometryReader { geometry in
                VStack {
                        Spacer()
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                                ForEach(menuItems, id: \.id){ item in
                                   
                                    Button(action: {
                                            // Action for menu item 1
                                        isMenuOpen.toggle()
                                    }) {
                                        Text(item.name)
                                            .font(.system(size: 12))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Divider()
                                }
                            }.padding(.horizontal, 8)
                        }
                        .padding(.vertical, 8)
                        .frame(width: 120, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                }
            }
        }
    }

func saveImage() {
        // Create a new Image entity
    let newImage = ImageData(context: moc)
    newImage.img = originalImg
    newImage.blur = image
    newImage.createAt = Date()
    
    do {
        try self.moc.save() // Save the changes to Core Data
        print("image saved..")
    } catch {
            // Handle the error
        print("Failed to save image: \(error)")
    }
}
func blurImage() {
    isProgress = true
    originalImg = image
    DispatchQueue.global().async {
        let blurredImage = imgUitility.gaussianBlur(image: image, blurRadius: 1.0)
        
        DispatchQueue.main.async {
            image = blurredImage
            isProgress = false
            isBlur = true
        }
    }
}
func frameImage() {
    
}
func zoomImage() {
    
}
func rotateImage() {
    
}
func revertImage() {
    
}
func editOption(item: ButtonItem) {
    switch (item.id) {
        case 1 :
            print(item.name)
        case 2 :
                //  isMenuOpen = true
            withAnimation {
                isMenuOpen.toggle()
            }
            print(item.name)
        case 3 :
            print(item.name)
        case 4 :
            print(item.name)
        case 5 :
            print(item.name)
        case 6 :
            print(item.name)
        default : break
    }
}
}
struct ImageEditView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditView()
    }
}

struct ButtonItem: Identifiable {
    var id: Int
    var name: String
    var icon: String
}

struct MenuView: View {
    var body: some View {
        VStack {
            Button(action: {
                    // Action for menu item 1
            }) {
                HStack(alignment: .firstTextBaseline){
                    Text("Black Frame")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image("BlackFrame")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .trailing)
                }
            }
            Divider()
            Button(action: {
                    // Action for menu item 2
            }) {
                Text("Dark Wood Frame")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image("DarkWoodFrame")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .trailing)
                
            }
            Divider()
            Button(action: {
                    // Action for menu item 3
            }) {
                Text("Gold Frame")
                    .font(.headline)
                Spacer()
                Image("GoldFrame")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .trailing)
            }
            Divider()
            Button(action: {
                    // Action for menu item 3
            }) {
                Text("Light Wood Frame")
                    .font(.headline)
                    .padding()
                    .multilineTextAlignment(.leading)
                Spacer()
                Image("LightWoodFrame")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .trailing)
            }
        }
        .padding()
    }
}

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
    let menuItems = [ButtonItems(id: 1, name: "Black Frame", icon: "BlackFrame"),
                     ButtonItems(id: 2, name: "Dark Wood Frame", icon: "DarkWoodFrame"),
                     ButtonItems(id: 3, name: "Gold Frame", icon: "GoldFrame"),
                     ButtonItems(id: 4, name: "Light Wood Frame", icon: "LightWoodFrame")]
    var buttons = [ButtonItems(id: 1, name: "Blur", icon: "button.programmable.square.fill"),
                   ButtonItems(id: 2, name: "Frame", icon: "photo.artframe"),
                   ButtonItems(id: 3, name: "Zoom", icon: "plus.magnifyingglass"),
                   ButtonItems(id: 4, name: "Rotate", icon: "rotate.left"),
                   ButtonItems(id: 5, name: "Revert", icon: "clear"),
                   ButtonItems(id: 6, name: "Done", icon: "square.and.arrow.down.fill")
    ]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    var imgUitility = ImageUtilities()
    @State var originalImg: UIImage = UIImage(systemName: "photo")!
    var body: some View {
            ZStack {
                VStack {
                    if !isProgress {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(height: 400)
                            .padding()
                        
                        HStack(spacing: 10) {
                            Spacer()
                            ForEach(buttons, id: \.id) { button in
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
                                        /*@START_MENU_TOKEN@*/Text(button.name)/*@END_MENU_TOKEN@*/
                                            .font(.system(size: 10))
                                            .foregroundColor(button.id == 6 ? Color.gray : Color.white)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .alignmentGuide(HorizontalAlignment.center) { _ in
                            UIScreen.main.bounds.width / 2
                                //  }
                            
                        }.frame(maxWidth: .infinity)
                        
                        Spacer()
                        HStack(spacing: 30) {
                            
                            if !isBlur {
                                Button("Blur") {
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
                            } else {
                                Button("Save") {
                                    isProgress = true
                                    DispatchQueue.global().async {
                                        saveImage()
                                        DispatchQueue.main.async {
                                            isProgress = false
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                if isMenuOpen {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            VStack(spacing: 10) {
                                ForEach(menuItems, id: \.id) { item in
                                    Button(action: {
                                            // Action for menu item
                                        isMenuOpen = false
                                    }) {
                                        HStack(alignment: .firstTextBaseline){
                                            Text(item.name)
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                            Spacer()
                                            Image(item.icon)
                                                .resizable()
                                                .frame(width: 30, height: 30, alignment: .trailing)
                                        }
                                    }
                                    Divider()
                                }
                            }.padding(16)
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.3)
                            .background(Color.white)
                            .cornerRadius(10)
                            .transition(.move(edge: .bottom))
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.black.opacity(0.5))
                }
                   
            }
                .navigationBarTitle("Edit Image", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                })
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
    func editOption(item: ButtonItems) {
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

struct ButtonItems: Identifiable {
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

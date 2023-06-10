    //
    //  ImageEditView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 25/05/2023.
    //

import SwiftUI

struct ImageEditView: View {
    @StateObject var editViewModel: ImageEditViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var height = 400
    @State var image: UIImage = UIImage(systemName: "photo")!
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Image(uiImage: editViewModel.image)
                    .resizable()
                    .frame(height: 400)
                    .padding()
                    .scaleEffect(editViewModel.zoomScale)
                    .gesture(MagnificationGesture()
                        .onChanged { value in
                            editViewModel.zoomScale = value.magnitude
                        }
                    )
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                    .onAppear {
                        if editViewModel.originalImg == nil {
                            editViewModel.originalImg = editViewModel.image
                        }
                    }
            }
            VStack {
                HStack(spacing: 10) {
                    Spacer()
                    ForEach(editViewModel.buttons, id: \.id) { button in
                        if button.id == 2 {
                            Button {
                                editViewModel.isMenuOpen.toggle()
                            } label: {
                                VStack {
                                    Image(systemName: button.icon)
                                        .font(.system(size: 15))
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(button.id == 6 ? Color.gray : Color.blue)
                                        .clipShape(Circle())
                                    Text(button.name)
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.gray)
                                }
                            }
                        } else {
                            Button {
                                DispatchQueue.main.async {
                                        //  image = viewModel.image
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        button.id == 6 ? saveImage() : editViewModel.editOption(item: button)
                                    }
                                }
                            } label: {
                                VStack {
                                    Image(systemName: button.icon)
                                        .font(.system(size: 15))
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(button.id == 6 ? Color.gray : Color.blue)
                                        .clipShape(Circle())
                                    Text(button.name)
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.gray)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .overlay(
                menuOverlay()
                    .opacity(editViewModel.isMenuOpen ? 1 : 0)
                    .animation(.easeInOut, value: 2)
            )
            .alert(isPresented: $editViewModel.showAlert) {
                Alert(
                    title: Text("Image Saved"),
                    message: Text("The image has been saved successfully."),
                    dismissButton: .default(Text("OK"))
                )
            }
            Spacer()
        }
        .padding(.bottom, 20)
        .navigationBarTitle("Edit Image", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
        })
    }
    
    private func menuOverlay() -> some View {
        if editViewModel.isMenuOpen {
            return AnyView(
                Color.clear
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        editViewModel.isMenuOpen = false
                    }
                    .overlay(
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(editViewModel.menuItems) { item in
                                Button(action: {
                                    editViewModel.isMenuOpen = false
                                    if item.id == 5 {
                                        editViewModel.isMenuOpen = false
                                    } else {
                                        editViewModel.frameImage(item: item)
                                    }
                                }) {
                                    HStack {
                                        Text(item.name)
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                Divider()
                            }
                        }
                            .frame(width: 200)
                            .padding()
                            .background(Color("PopMenuColor"))
                            .cornerRadius(10)
                            .padding(30)
                    )
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    private func saveImage() {
            // Create a new Image entity
        let newImage = ImageData(context: moc)
        newImage.img = editViewModel.originalImg
        newImage.blur = editViewModel.image
        newImage.createAt = Date()
        image = editViewModel.image
        do {
            try self.moc.save() // Save the changes to Core Data
            editViewModel.showAlert = true
            presentationMode.wrappedValue.dismiss()
        } catch {
                // Handle the error
            print("Failed to save image: \(error)")
        }
    }
}


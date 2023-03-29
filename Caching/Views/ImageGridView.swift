//
//  ImageGridView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI

struct ImageGridView: View {
    
    @StateObject private var viewModel: ImageLoaderVM
    
    init(dataService: NetworkManager) {
        _viewModel = StateObject(wrappedValue: ImageLoaderVM(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach((0..<viewModel.images.count), id: \.self) { index in
                    Image("\(viewModel.images[index]) ")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                }
            }
            .padding()
        }
    }
}

//struct ImageGridView_Previews: PreviewProvider {
//    var
//    static var previews: some View {
//        ImageGridView()
//    }
//}

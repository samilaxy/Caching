//
//  ImageGridView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI

struct ImageGridView: View {
    
    @StateObject private var vm: ImageLoaderVM
    
    init(dataService: NetworkManager) {
        _vm = StateObject(wrappedValue: ImageLoaderVM(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach((0..<vm.images.count), id: \.self) { index in
                    AsyncImage(url: URL(string: vm.images[index].urls.raw), content: { image in
                        image.resizable()
                    }, placeholder: {
                        ProgressView()
                    })
                    .frame(width: 100, height: 100)
                }
            }
            .padding()
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static let dataService = NetworkManager()
    static var previews: some View {
        ImageGridView(dataService: dataService)
    }
}

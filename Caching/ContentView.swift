//
//  ContentView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
   
 let viewModel = ViewModel(dataService: NetworkManager() )
    
    var body: some View {
        ImageGridView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

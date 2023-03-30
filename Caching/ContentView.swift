//
//  ContentView.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI
import Combine

struct ContentView: View {
   
    static let dataservice = NetworkManager()
    
    var body: some View {
        ImageGridView(dataService: ContentView.dataservice)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







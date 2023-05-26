    //
    //  ContentView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 28/03/2023.
    //

import SwiftUI
import Combine

struct ContentView: View {
    
    let viewModel = ViewModel(dataService: NetworkManager())
    @State var selection = 0
    
    var body: some View {
        
        
        TabView(selection: $selection) {
                //NavigationView {
            ImageGridView(viewModel: viewModel)
                //}
                .tabItem {
                    Image(systemName: "house.circle")
                    Text("Home")
                }
                .tag(0)
            
            ImageGridView(viewModel: viewModel)
                .navigationTitle("Saved")
                .tabItem {
                    Image(systemName: "text.below.photo.fill")
                    Text("Saved")
                }
                .tag(1)
        }
        .background(Color(.secondarySystemBackground))
        .tabViewStyle(DefaultTabViewStyle())
        .onAppear {

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


    //
    //  ContentView.swift
    //  Caching
    //
    //  Created by Noye Samuel on 28/03/2023.
    //

import SwiftUI
import Combine

struct ContentView: View {
    
 
    @State var selection = 0
    
    var body: some View {
        
        
        TabView(selection: $selection) {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.circle")
                    Text("Home")
                }
                .tag(0)
            
            SavedImagesView()
                .tabItem {
                    Image(systemName: "text.below.photo.fill")
                    Text("Fovarites")
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


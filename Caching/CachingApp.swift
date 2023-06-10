//
//  CachingApp.swift
//  Caching
//
//  Created by Noye Samuel on 28/03/2023.
//

import SwiftUI
import CoreData

@main
struct CachingApp: App {
    let persistenceController = PersistenceController.shared
    let viewContext = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, viewContext)
               .environmentObject(ViewModel(viewContext: viewContext))
        }
    }
}

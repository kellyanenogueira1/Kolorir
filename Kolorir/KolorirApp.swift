//
//  KolorirApp.swift
//  Kolorir
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 24/10/23.
//

import SwiftUI

@main
struct KolorirApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


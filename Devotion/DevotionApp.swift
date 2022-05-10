//
//  DevotionApp.swift
//  Devotion
//
//  Created by adam janusewski on 5/10/22.
//

import SwiftUI

@main
struct DevotionApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

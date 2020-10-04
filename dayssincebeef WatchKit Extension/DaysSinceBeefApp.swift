//
//  dayssincebeefApp.swift
//  dayssincebeef WatchKit Extension
//
//  Created by Andrew Nguonly on 10/3/20.
//

import SwiftUI

@main
struct DaysSinceBeefApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

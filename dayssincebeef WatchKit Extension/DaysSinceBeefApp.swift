//
//  dayssincebeefApp.swift
//  dayssincebeef WatchKit Extension
//
//  Created by Andrew Nguonly on 10/3/20.
//

import SwiftUI
import UserNotifications

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

        WKNotificationScene(controller: NotificationController.self, category: "ActionCheck")
    }
    
    init() {
        registerNotifications()
    }
    
    func registerNotifications() {
        requestNotificationAuthorization()
        registerNotificationCategories()
        registerActionCheckNotification()
    }
    
    func requestNotificationAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("App authorized for notifications")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func registerNotificationCategories() {
        
        let confirmAction = UNNotificationAction(identifier: "ConfirmAction",
                                                 title: "👍",
                                                 options: [.foreground])
        
        let denyAction = UNNotificationAction(identifier: "DenyAction",
                                              title: "👎",
                                              options: [.foreground])
        
        let actionCheckCategory = UNNotificationCategory(identifier: "ActionCheck",
                                                         actions: [confirmAction, denyAction],
                                                         intentIdentifiers: [],
                                                         options: [])
        
        let categories: Set<UNNotificationCategory> = [actionCheckCategory]
        UNUserNotificationCenter.current().setNotificationCategories(categories)
    }
    
    func registerActionCheckNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "🥩 Check"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "ActionCheck"

        // show this notification at 4AM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 4
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

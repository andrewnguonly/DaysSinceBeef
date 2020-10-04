//
//  ContentView.swift
//  dayssincebeef WatchKit Extension
//
//  Created by Andrew Nguonly on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @FetchRequest(
        entity: AppState.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AppState.lastActionDate, ascending: true)]
    ) var appStates: FetchedResults<AppState>
    
    @State var showThumbsUpAlert = false
    @State var showThumbsDownAlert = false
    @State var daysSinceAction = 0

    var body: some View {
        VStack {
            Text("Days Since 🥩")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.red)
                .padding()
            
            Text(String(daysSinceAction))
                .font(.title)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
            
            Spacer()
            
            HStack {
                Text("🥩 today?")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    self.showThumbsUpAlert = true
                    updateLastActionDate(date: Date())
                    computeDaysSinceAction()
                }) {
                    Text("👍")
                }
                .alert(isPresented: $showThumbsUpAlert) {
                    Alert(title: Text("smh..."), message: Text("🌎🔥"))
                }
                
                Button(action: {
                    self.showThumbsDownAlert = true
                }) {
                    Text("👎")
                }
                .alert(isPresented: $showThumbsDownAlert) {
                    Alert(title: Text("Woohoo!"), message: Text("Keep the streak going! 🌳"))
                }
            }
        }
        .onAppear(perform: createAppState)
        .onAppear(perform: computeDaysSinceAction)
    }
    
    private func createAppState() {
        if self.appStates.isEmpty {
            let newAppState = AppState(context: self.viewContext)
            newAppState.lastActionDate = Date()
            saveViewContext()
            print("Successfully initialized app state")
        } else {
            print("App state already created")
            let appState = getAppState()
            print("Last action date: \(appState.lastActionDate!)")
        }
    }
    
    private func getAppState() -> AppState {
        self.appStates[0]
    }
    
    private func updateLastActionDate(date: Date) {
        let appState = getAppState()
        appState.lastActionDate = date
        saveViewContext()
        print("Successfully updated lastActionDate")
    }
    
    private func saveViewContext() {
        do {
            try self.viewContext.save()
            print("Successfully saved view context")
        } catch {
            print("Unable to save view context: \(error), \(error.localizedDescription)")
        }
    }
    
    private func computeDaysSinceAction() {
        print("Computing days since action")
        let appState = getAppState()
        let calendar = Calendar.current
        
        let lastActionDate = appState.lastActionDate
        print("Last action date: \(appState.lastActionDate!)")
        
        let currentDate = Date()
        print("Current date: \(currentDate)")
        
        let components = calendar.dateComponents([.day], from: lastActionDate!, to: currentDate)
        
        // update view
        self.daysSinceAction = components.day!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

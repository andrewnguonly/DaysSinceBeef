//
//  ContentView.swift
//  dayssincebeef WatchKit Extension
//
//  Created by Andrew Nguonly on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

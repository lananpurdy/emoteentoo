//
//  ContentView.swift
//  emoteen8
//
//  Created by Lana Purdy on 2/21/20.
//  Copyright © 2020 Lana Purdy. All rights reserved.
//

import SwiftUI
import QGrid
import Files

struct ContentView: View {
    
    @State private var selection = 0
    
    var body: some View
    {
        TabView(selection: $selection)
        {
            NavigationView {
                QGrid(Meditation.load(), columns: 2)
                {
                    meditation in
                    
                    NavigationLink(destination: MeditationDetailView(meditation: meditation))
                    {
                        VStack {
                            MeditationView(meditation: meditation)
                            Spacer()
                        }
                    }
                    
                }
                .navigationBarTitle("Meditations", displayMode: .inline)
            }
            .tabItem {
                VStack {
                    Image(systemName: "heart")
                    Text("Meditation")
                }
            }
            .tag(0)
            
            NavigationView
                {
                    List(Journal.load()) {
                        
                        journal in
                        
                        NavigationLink(destination: JournalView(journal))
                        {
                            Text(journal.Title)
                        }
                    }
                    .navigationBarTitle("Activity", displayMode: .inline)
                    .navigationBarItems(trailing:
                        NavigationLink(destination: JournalView(Journal(Date().emoDate + ".emo","")))
                        {
                            Image(systemName: "square.and.pencil")
                    })
            }
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "list.dash")
                    Text("Activity")
                }
            }
            .tag(1)
            
            Text("Profile")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

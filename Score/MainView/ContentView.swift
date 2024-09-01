//
//  ContentView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var data = Data()

    var body: some View {
        TabView {
            CardGamesView()
                .tabItem {
                    Label("Card Games", systemImage: "greetingcard.fill")
                }
            
            DiceGamesView()
                .tabItem {
                    Label("Dice Games", systemImage: "dice.fill")
                }
            
            BasicGamesView()
                .tabItem {
                    Label("Basic Games", systemImage: "number")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .environment(data)
    }
}

#Preview {
    ContentView()
}

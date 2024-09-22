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
                    Label(getText(forKey: "cardGamesTitle", forLanguage: data.languages), systemImage: "greetingcard.fill")
                }
            
            DiceGamesView()
                .tabItem {
                    Label(getText(forKey: "diceGamesTitle", forLanguage: data.languages), systemImage: "dice.fill")
                }
            
            BasicGamesView()
                .tabItem {
                    Label(getText(forKey: "basicGamesTitle", forLanguage: data.languages), systemImage: "number")
                }
            
            SettingsView()
                .tabItem {
                    Label(getText(forKey: "settingsTitle", forLanguage: data.languages), systemImage: "gearshape.fill")
                }
        }
        .environment(data)
    }
}

#Preview {
    ContentView()
}

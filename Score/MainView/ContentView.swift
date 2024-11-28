//
//  ContentView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI
import AppTrackingTransparency


struct ContentView: View {
    @State private var data = Data()

    var body: some View {
        Button("ad") {
            Interstitial.shared.loadInterstitial()
            Interstitial.shared.showInterstitialAds()
        }
        TabView {
            CardGamesView()
                .tabItem {
                    Label(getText(forKey: "cardGamesTitle", forLanguage: data.languages), systemImage: "greetingcard.fill")
                }
            
            DiceGamesView()
                .tabItem {
                    Label(getText(forKey: "diceGamesTitle", forLanguage: data.languages), systemImage: "dice.fill")
                }
            
            CustomSettingsView()
                .tabItem {
                    Label(getText(forKey: "customGamesTitle", forLanguage: data.languages), systemImage: "number")
                }
            
            SettingsView()
                .tabItem {
                    Label(getText(forKey: "settingsTitle", forLanguage: data.languages), systemImage: "gearshape.fill")
                }
        }
        .environment(data)
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
        }
    }
}

#Preview {
    ContentView()
}

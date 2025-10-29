//
//  ContentView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import AppTrackingTransparency
import SwiftUI

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject private var data = Data()

    var body: some View {
        TabView {
            CardGamesView()
                .tabItem {
                    Label(
                        getText(
                            forKey: "cardGamesTitle",
                            forLanguage: data.languages
                        ),
                        systemImage: "greetingcard.fill"
                    )
                }

            DiceGamesView()
                .tabItem {
                    Label(
                        getText(
                            forKey: "diceGamesTitle",
                            forLanguage: data.languages
                        ),
                        systemImage: "dice.fill"
                    )
                }

            CustomSettingsView()
                .tabItem {
                    Label(
                        getText(
                            forKey: "customGamesTitle",
                            forLanguage: data.languages
                        ),
                        systemImage: "number"
                    )
                }

            SettingsView()
                .tabItem {
                    Label(
                        getText(
                            forKey: "settingsTitle",
                            forLanguage: data.languages
                        ),
                        systemImage: "gearshape.fill"
                    )
                }
        }
        .onChange(of: data.reviewCount) {
            if data.reviewCount % 5 == 1 {
                requestReview()
            }
        }
        .tint(.white)
        .environmentObject(data)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

//
//  UtilsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI

@ViewBuilder
func getGameView(for game: String) -> some View {
    switch game {
    case "Skyjo":
        SkyjoSettingsView()
    case "Uno":
        UnoSettingsView()
    case "Yam":
        YamSettingsView()
    default:
        Text("View not available")
    }
}


func getText(forKey key: String, forLanguage language: Languages) -> String {
    return texts[key]?[language] ?? (language == .en ? "Data unavailable" : "Données indisponibles")
}

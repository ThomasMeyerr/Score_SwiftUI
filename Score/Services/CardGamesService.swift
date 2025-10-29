//
//  CardGamesService.swift
//  Score
//
//  Created by Leviatan on 29/10/2025.
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
    case "SeaSaltPaper":
        SeaSaltPaperSettingsView()
    case "Take6":
        Take6SettingsView()
    case "Belote":
        BeloteSettingsView()
    default:
        Text("View not available")
    }
}

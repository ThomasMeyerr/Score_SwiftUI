//
//  Data.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import Foundation


enum Languages {
    case fr, en
}


@Observable
class Data {
    var languages: Languages
    static let cardGames = ["Skyjo", "Uno"]
    static let diceGames = ["Yam"]
    
    init(languages: Languages = .en) {
        self.languages = languages
    }
}


struct LanguagesText {
    func getText(forKey key: String, forLanguage language: Languages) -> String {
        return texts[key]?[language] ?? (language == .en ? "Data unavailable" : "Données indisponibles")
    }
    
    private let texts: [String: [Languages: String]] = [
        // SettingsView
        "settingsPicker": [
            .fr: "Choisissez votre langue",
            .en: "Choose your language"
        ],
        "settingsReset": [
            .fr: "Restaurer les paramètres",
            .en: "Reset settings"
        ],
        "settingsAlert": [
            .fr: "Êtes-vous sûr ?",
            .en: "Are you sure?"
        ],
        "settingsButtonCancel": [
            .fr: "Annuler",
            .en: "Cancel"
        ],
        "settingsButtonAdds": [
            .fr: "Enlever les publicités",
            .en: "Remove adds"
        ],
        "settingsButtonAddsPrice": [
            .fr: "3,99€",
            .en: "3.99$"
        ],
        
        // CardGamesView
        "CardGamesTitle": [
            .fr: "Jeux de Cartes",
            .en: "Card Games"
        ],
        
        // DiceGamesView
        "DiceGamesTitle": [
            .fr: "Jeux de Dés",
            .en: "Dice Games"
        ]
        // BasicGamesView
    ]
}

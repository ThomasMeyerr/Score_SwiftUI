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
    
    init(languages: Languages = .en) {
        self.languages = languages
    }
}


let texts: [String: [Languages: String]] = [
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
    
    // GameSettingsView
    "Rules": [
        .fr: "Règles",
        .en: "Rules"
    ],
    "ShowMore": [
        .fr: "Voir plus...",
        .en: "Show more..."
    ],
    
    // CardGamesView
    "CardGamesTitle": [
        .fr: "Jeux de Cartes",
        .en: "Card Games"
    ],
    "SkyjoSettingsTitle": [
        .fr: "Paramètres du Skyjo",
        .en: "Skyjo Settings"
    ],
    "UnoSettingsTitle": [
        .fr: "Paramètres du Uno",
        .en: "Uno Settings"
    ],
    
    // DiceGamesView
    "DiceGamesTitle": [
        .fr: "Jeux de Dés",
        .en: "Dice Games"
    ],
    "YamSettingsTitle": [
        .fr: "Paramètres du Yam",
        .en: "Yam Settings"
    ],
    // BasicGamesView
]


// All games handle in app
let cardGames = ["Skyjo", "Uno"]
let diceGames = ["Yam"]

// List of rules
let rules: [String: [Languages: String]] = [
    // CardGamesView
    "Skyjo": [
        .fr: "Skyjo est un jeu de cartes où les joueurs tentent de réduire leur score en échangeant ou retournant des cartes dans une grille de 12 cartes. Le but est de terminer la partie avec le moins de points possible",
        .en: "Skyjo is a card game where players try to reduce their score by swapping or flipping cards in a 12-card grid. The goal is to finish the game with the lowest possible score"
    ],
    "Uno": [
        .fr: "Uno est un jeu de cartes où les joueurs doivent se débarrasser de toutes leurs cartes en faisant correspondre la couleur ou le numéro de la carte précédente. Des cartes spéciales ajoutent des rebondissements stratégiques. Le premier à n'avoir plus de cartes gagne",
        .en: "Uno is a card game where players try to get rid of all their cards by matching the color or number of the previous card. Special cards add strategic twists. The first player with no cards left wins"
    ],
    
    // DiceGamesView
    "Yam": [
        .fr: "Yam (ou Yahtzee) est un jeu de dés où les joueurs lancent cinq dés pour obtenir des combinaisons spécifiques, comme des brelans ou des suites. Le but est de marquer le plus de points en optimisant ses lancers sur plusieurs tours",
        .en: "Yam (or Yahtzee) is a dice game where players roll five dice to achieve specific combinations, such as three of a kind or straights. The goal is to score the most points by optimizing rolls over several turns"
    ]
    // BasicGamesView
]

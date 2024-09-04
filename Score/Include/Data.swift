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
    "ShowLess": [
        .fr: "Voir moins...",
        .en: "Show less..."
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
        .fr: "Objectif : Avoir le moins de points possible. La partie se termine lorsqu'un joueur atteint 100 points, et le joueur avec le score le plus bas gagne.\n\nMise en place : Chaque joueur dispose 12 cartes face cachée (3x4). Ils retournent 2 cartes. Le reste des cartes forme une pioche et une défausse.\n\nTour de jeu : Piochez une carte et remplacez-la par une carte de votre grille, ou défaussez-la et retournez une carte. Le but est de réduire votre total de points./n\nFin de manche : Quand un joueur révèle toutes ses cartes, les points sont comptés. Les cartes en double dans une colonne s'annulent.\n\nFin de partie : La partie se termine quand un joueur atteint 100 points. Le joueur avec le score le plus bas gagne.",
        .en: "Objective: Have the lowest score possible. The game ends when a player reaches 100 points, and the player with the lowest score wins.\n\nSetup: Each player arranges 12 cards face down (3x4). They flip 2 cards. The rest forms a draw pile and a discard pile.\n\nTurn: Draw a card and replace it with one in your grid, or discard it and flip a card. The goal is to lower your point total.\n\nEnd of round: When a player reveals all cards, points are counted. Duplicate cards in a column cancel out.\n\nEnd of game: The game ends when a player reaches 100 points. The player with the lowest score wins."
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

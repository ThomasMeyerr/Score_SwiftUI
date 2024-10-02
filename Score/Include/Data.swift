//
//  Data.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import Foundation


enum Languages: Codable {
    case fr, en
}


@Observable
class Data {
    var languages: Languages {
        didSet {
            if let encodedLanguages = try? JSONEncoder().encode(languages) {
                UserDefaults.standard.set(encodedLanguages, forKey: "Languages")
            }
        }
    }
    
    init() {
        self.languages = .en

        if let data = UserDefaults.standard.data(forKey: "Languages") {
            if let decodedLanguages = try? JSONDecoder().decode(Languages.self, from: data) {
                self.languages = decodedLanguages
            }
        }
    }
}


let texts: [String: [Languages: String]] = [
    // SettingsView
    "settingsTitle": [
        .fr: "Paramètres",
        .en: "Settings"
    ],
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
    "rules": [
        .fr: "Règles",
        .en: "Rules"
    ],
    "settings": [
        .fr: "Paramètres de la Partie",
        .en: "Game Settings"
    ],
    "showMore": [
        .fr: "Voir plus...",
        .en: "Show more..."
    ],
    "showLess": [
        .fr: "Voir moins...",
        .en: "Show less..."
    ],
    "numberOfPlayers": [
        .fr: "Nombres de joueurs",
        .en: "Number of players"
    ],
    "pseudo": [
        .fr: "Entrer votre nom",
        .en: "Enter your name"
    ],
    "launch": [
        .fr: "Lancer la partie",
        .en: "Launch game"
    ],
    "players": [
        .fr: "Joueurs",
        .en: "Players"
    ],
    "maxScore": [
        .fr: "Score maximum",
        .en: "Max score"
    ],
    "finishRound": [
        .fr: "Finir le tour",
        .en: "Finish round"
    ],
    "cancelGame": [
        .fr: "Annuler la partie",
        .en: "Cancel game"
    ],
    "alertTitle": [
        .fr: "Noms en double",
        .en: "Duplicate names"
    ],
    "alertMessage": [
        .fr: "S'il vous plaît, entrez un nom unique pour chaque joueur",
        .en: "Please enter unique names for all players"
    ],
    "alertWinner": [
        .fr: "Le gagnant est ",
        .en: "The winner is "
    ],
    "alertLooser": [
        .fr: "Et le perdant est ",
        .en: "And the looser is "
    ],
    "continue": [
        .fr: "Reprendre",
        .en: "Continue"
    ],
    
    // CardGamesView
    "cardGamesTitle": [
        .fr: "Jeux de Cartes",
        .en: "Card Games"
    ],
    
    // DiceGamesView
    "diceGamesTitle": [
        .fr: "Jeux de Dés",
        .en: "Dice Games"
    ],
    
    // BasicGamesView
    "basicGamesTitle": [
        .fr: "Jeux Normaux",
        .en: "Basic Games"
    ],
]


// All games handle in app
let cardGames = ["Skyjo", "Uno"]
let diceGames = ["Yam"]


// List of rules
let rules: [String: [Languages: String]] = [
    // CardGamesView
    "skyjo": [
        .fr: "Objectif : Avoir le moins de points possible. La partie se termine lorsqu'un joueur atteint 100 points, et le joueur avec le score le plus bas gagne.\n\nMise en place : Chaque joueur dispose 12 cartes face cachée (3x4). Ils retournent 2 cartes. Le reste des cartes forme une pioche et une défausse.\n\nTour de jeu : Piochez une carte et remplacez-la par une carte de votre grille, ou défaussez-la et retournez une carte. Le but est de réduire votre total de points.\n\nFin de manche : Quand un joueur révèle toutes ses cartes, les points sont comptés. Les cartes en double dans une colonne s'annulent.\n\nFin de partie : La partie se termine quand un joueur atteint 100 points. Le joueur avec le score le plus bas gagne.",
        .en: "Objective: Have the lowest score possible. The game ends when a player reaches 100 points, and the player with the lowest score wins.\n\nSetup: Each player arranges 12 cards face down (3x4). They flip 2 cards. The rest forms a draw pile and a discard pile.\n\nTurn: Draw a card and replace it with one in your grid, or discard it and flip a card. The goal is to lower your point total.\n\nEnd of round: When a player reveals all cards, points are counted. Duplicate cards in a column cancel out.\n\nEnd of game: The game ends when a player reaches 100 points. The player with the lowest score wins."
    ],
    "uno": [
        .fr: "Objectif : Se débarrasser de toutes ses cartes. Le premier joueur à le faire gagne la partie.\n\nMise en place : Distribuez 7 cartes à chaque joueur. Placez le reste des cartes face cachée pour former la pioche, et retournez la carte du dessus pour démarrer la défausse.\n\nTour de jeu : Faites correspondre la couleur ou le numéro de la carte de la défausse avec une de vos cartes. Si vous ne pouvez pas jouer, piochez une carte. Utilisez des cartes spéciales pour ajouter des rebondissements (changer la couleur, passer le tour, inverser le sens, etc.).\n\nFin de partie : Le jeu se termine lorsqu'un joueur se débarrasse de toutes ses cartes. Le joueur qui a terminé est le gagnant.",
        .en: "Objective: Get rid of all your cards. The first player to do so wins the game.\n\nSetup: Deal 7 cards to each player. Place the remaining cards face down to form the draw pile, and turn over the top card to start the discard pile.\n\nTurn: Match the color or number of the discard pile with one of your cards. If you can't play, draw a card. Use special cards to add twists (change color, skip turn, reverse direction, etc.).\n\nEnd of Game: The game ends when a player gets rid of all their cards. The player who finishes first is the winner."
    ],
    
    // DiceGamesView
    "yam": [
        .fr: "Objectif : Obtenir le plus de points possible en lançant des dés pour réaliser des combinaisons spécifiques.\n\nMise en place : Chaque joueur reçoit un tableau de score avec différentes catégories. Le jeu se joue avec 5 dés.\n\nTour de jeu : À chaque tour, le joueur peut lancer les dés jusqu'à trois fois. Après chaque lancer, il peut choisir de garder certains dés et de relancer les autres pour essayer d’obtenir une combinaison souhaitée.\n\nCombinaisons : Les combinaisons possibles incluent :\n\tBrelan : Trois dés identiques\n\tCarré : Quatre dés identiques\n\tFull : Un brelan et une paire\n\tPetite suite : Quatre dés consécutifs\n\tGrande suite : Cinq dés consécutifs\n\tYam : Cinq dés identiques\n\nFin de partie : Après 13 tours, chaque joueur a rempli toutes les catégories de son tableau de score. Les points sont comptés selon les combinaisons obtenues et le joueur avec le total le plus élevé gagne.",
        .en: "Objective: Score the most points by rolling dice to achieve specific combinations.\n\nSetup: Each player gets a score sheet with different categories. The game uses 5 dice.\n\nTurn: On each turn, a player can roll the dice up to three times. After each roll, they can choose to keep certain dice and re-roll the others to try for a desired combination.\n\nCombinations: Possible combinations include:\n\tThree of a Kind: Three identical dice\n\tFour of a Kind: Four identical dice\n\tFull House: Three of a kind and a pair\n\tSmall Straight: Four consecutive dice\n\tLarge Straight: Five consecutive dice\n\tYahtzee: Five identical dice\n\nEnd of Game: After 13 rounds, each player has filled out all categories on their score sheet. Points are totaled, and the player with the highest score wins."
    ]
    
    // BasicGamesView
]


// Card games data
class GameSkyjoData: Codable {
    let numberOfPlayer: Int
    let maxScore: Double
    let names: [String]
    let nameAndScore: [String: Int]
    let roundScores: [String: Int]
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String], nameAndScore: [String : Int], roundScores: [String : Int]) {
        self.numberOfPlayer = numberOfPlayer
        self.maxScore = maxScore
        self.names = names
        self.nameAndScore = nameAndScore
        self.roundScores = roundScores
    }
}

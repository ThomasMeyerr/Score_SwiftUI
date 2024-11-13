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
    "settingsButtonDailyAdds": [
        .fr: "Enlever les publicités pour 24 heures",
        .en: "Remove adds for 24 hours"
    ],
    
    // GameSettingsView
    "rules": [
        .fr: "Règles",
        .en: "Rules"
    ],
    "settings": [
        .fr: "Paramètres de la partie de ",
        .en: "Game settings of "
    ],
    "cutomSettings": [
        .fr: "Paramètres de la partie",
        .en: "Game settings"
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
    "round": [
        .fr: "Tour ",
        .en: "Round "
    ],
    "cancelSure": [
        .fr: "Êtes-vous sûrs ?",
        .en: "Are you sure?"
    ],
    "yes": [
        .fr: "Oui",
        .en: "Yes"
    ],
    "no": [
        .fr: "Non",
        .en: "No"
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
    "yamTitle": [
        .fr: "Yam",
        .en: "Yahtzee"
    ],
    
    // CustomGamesView
    "customGamesTitle": [
        .fr: "Paramètres personnalisés",
        .en: "Custom Parameters"
    ],
    "countdown": [
        .fr: "Compte à rebours",
        .en: "Countdown"
    ],
    "countdownEnable": [
        .fr: "Voulez-vous un compte à rebours ? (en secondes)",
        .en: "Did you want a countdown ? (in seconds)"
    ],
    "timeUp": [
        .fr: "Le temps est écoulé",
        .en: "Time's up"
    ],
    "timeUpMessage": [
        .fr: "Entrez votre score s'il vous plaît",
        .en: "Please enter your score"
    ],
]


// All games handle in app
let cardGames = ["Skyjo", "Uno"]
let diceGames = ["Yam"]


// List of rules
let rules: [String: [Languages: String]] = [
    // CardGamesView
    "skyjo": [
        .fr: "Objectif : Avoir le moins de points possible. La partie se termine lorsqu'un joueur atteint 100 points, et le joueur avec le score le plus bas gagne.\n\nMise en place : Chaque joueur dispose 12 cartes face cachée (3x4). Ils retournent 2 cartes. Le reste des cartes forme une pioche et une défausse.\n\nTour de jeu : Piochez une carte et remplacez-la par une carte de votre grille, ou défaussez-la et retournez une carte. Le but est de réduire votre total de points.\n\nFin de manche : Quand un joueur révèle toutes ses cartes, les points sont comptés. Les cartes en triple dans une colonne s'annulent.\n\nFin de partie : La partie se termine quand un joueur atteint 100 points. Le joueur avec le score le plus bas gagne.",
        .en: "Objective: Have the lowest score possible. The game ends when a player reaches 100 points, and the player with the lowest score wins.\n\nSetup: Each player arranges 12 cards face down (3x4). They flip 2 cards. The rest forms a draw pile and a discard pile.\n\nTurn: Draw a card and replace it with one in your grid, or discard it and flip a card. The goal is to lower your point total.\n\nEnd of round: When a player reveals all cards, points are counted. Three same cards in a column cancel out.\n\nEnd of game: The game ends when a player reaches 100 points. The player with the lowest score wins."
    ],
    "uno": [
        .fr: "Objectif : Se débarrasser de toutes ses cartes. Le premier joueur à le faire gagne le tour, et les autres joueurs comptabilisent leurs points.\n\nMise en place : Distribuez 7 cartes à chaque joueur. Placez le reste des cartes face cachée pour former la pioche, et retournez la carte du dessus pour démarrer la défausse.\n\nTour de jeu : Faites correspondre la couleur ou le numéro de la carte de la défausse avec une de vos cartes. Si vous ne pouvez pas jouer, piochez une carte. Utilisez des cartes spéciales pour ajouter des rebondissements (changer la couleur, passer le tour, inverser le sens, etc.).\n\nComptabilisation des points :\n-Cartes numérotées (0-9) : Valeur faciale de la carte.\n-Cartes spéciales (Passer, Inverser, +2) : 20 points chacune.\n-Joker et +4 : 50 points chacune.\n-Fin du tour : Quand un joueur se débarrasse de toutes ses cartes, les autres joueurs comptabilisent les points des cartes qu'il leur reste en main. Le gagnant du tour ne reçoit aucun point. Continuez à jouer jusqu'à ce qu'un joueur atteigne le score maximum défini, généralement 500 points.\n\nFin de partie : La partie se termine lorsque quelqu'un atteint ou dépasse le score maximum fixé au départ (ex : 500 points). Le joueur avec le score le plus bas est déclaré vainqueur.",
        .en: "Objective: Get rid of all your cards. The first player to do so wins the round, and the other players tally their points.\n\nSetup: Deal 7 cards to each player. Place the remaining cards face down to form the draw pile, and turn over the top card to start the discard pile.\n\nTurn: Match the color or number of the discard pile with one of your cards. If you can't play, draw a card. Use special cards to add twists (change color, skip turn, reverse direction, etc.).\n\nScoring:\n-Number cards (0-9): Face value of the card.\n-Special cards (Skip, Reverse, +2): 20 points each.\n-Wild and +4 Wild cards: 50 points each.\n-End of the round: When a player gets rid of all their cards, the other players score the points from the cards remaining in their hand. The winner of the round scores no points. Continue playing until a player reaches the set maximum score, usually 500 points.\n\nEnd of Game: The game ends when someone reaches or exceeds the set maximum score (e.g., 500 points). The player with the lowest score is declared the winner."
    ],
    
    // DiceGamesView
    "yam": [
        .fr: "Objectif : Obtenir le plus de points possible en lançant des dés pour réaliser des combinaisons spécifiques.\n\nMise en place : Chaque joueur reçoit un tableau de score avec différentes catégories. Le jeu se joue avec 5 dés.\n\nTour de jeu : À chaque tour, le joueur peut lancer les dés jusqu'à trois fois. Après chaque lancer, il peut choisir de garder certains dés et de relancer les autres pour essayer d’obtenir une combinaison souhaitée.\n\nCombinaisons : Les combinaisons possibles incluent :\nBrelan : Trois dés identiques\nCarré : Quatre dés identiques\nFull : Un brelan et une paire\nGrande suite : Cinq dés consécutifs\nYam : Cinq dés identiques\n\nFin de partie : Après 13 tours, chaque joueur a rempli toutes les catégories de son tableau de score. Les points sont comptés selon les combinaisons obtenues et le joueur avec le total le plus élevé gagne.",
        .en: "Objective: Score the most points by rolling dice to achieve specific combinations.\n\nSetup: Each player gets a score sheet with different categories. The game uses 5 dice.\n\nTurn: On each turn, a player can roll the dice up to three times. After each roll, they can choose to keep certain dice and re-roll the others to try for a desired combination.\n\nCombinations: Possible combinations include:\nThree of a Kind: Three identical dice\nFour of a Kind: Four identical dice\nFull House: Three of a kind and a pair\nLarge Straight: Five consecutive dice\nYahtzee: Five identical dice\n\nEnd of Game: After 13 rounds, each player has filled out all categories on their score sheet. Points are totaled, and the player with the highest score wins."
    ],
    
    // CustomGamesView
    "customGames": [
        .fr: "Objectif : Atteindre la limite de points définie ou être le dernier joueur à rester en jeu sans dépasser cette limite. Personnalisez les paramètres pour ajuster la durée et le défi de la partie.\n\nMise en place : Déterminez le nombre de joueurs (entre 1 et 12). Chaque joueur reçoit un ensemble de cartes ou d'éléments de jeu de départ, selon les règles choisies. Choisissez une limite de points (de 50 à 500) pour déclarer un vainqueur.\n\nTour de jeu : Chaque joueur prend son tour en suivant l'ordre établi (par défaut, dans le sens horaire). Utilisez les cartes spéciales ou les actions pour atteindre les objectifs définis sans dépasser la limite de points. Un timer peut être activé pour limiter la durée de chaque tour, avec des intervalles allant de 10 secondes à 500 secondes.\n\nComptabilisation des points :\n-Cartes ou éléments de jeu ordinaires : Valeur définie par les règles de la partie.\n-Cartes spéciales : Valeur attribuée selon leur effet (par exemple, ajouter ou soustraire des points, donner des avantages spécifiques).\n\nFin du tour : Lorsqu'un joueur termine son tour, passez au joueur suivant. Si un joueur atteint la limite de points définie, la manche se termine, et le score est calculé.\n\nFin de partie : La partie se termine lorsqu'un joueur atteint ou dépasse la limite de points définie (par exemple, 500 points) ou lorsqu'il ne reste qu'un seul joueur. Le joueur avec le score le plus haut est déclaré vainqueur.",
        .en: "Objective: Reach the defined point limit or be the last player remaining without exceeding it. Customize the settings to adjust the game's duration and challenge level.\n\nSetup: Determine the number of players (from 1 to 12). Each player receives an initial set of cards or game elements based on the chosen rules. Set a point limit (from 50 to 500) to declare a winner.\n\nTurn: Each player takes their turn following the established order (default is clockwise). Use special cards or actions to reach the objectives without exceeding the point limit. A timer can be set to limit each turn’s duration, ranging from 10 to 500 seconds.\n\nScoring:\n-Regular cards or game elements: Value as defined by the game rules.\n-Special cards: Points assigned according to their effect (e.g., add or subtract points, provide specific advantages).\n\nEnd of the Round: When a player ends their turn, move to the next player. If a player reaches the defined point limit, the round ends, and scores are calculated.\n\nEnd of Game: The game ends when a player reaches or exceeds the defined point limit (e.g., 500 points) or only one player remains. The player with the highest score is declared the winner."
    ]

]


// Scores array for Yahtzee
let scoresString: [Languages: [String]] = [
    .fr: ["As", "Deux", "Trois", "Quatre", "Cinq", "Six", "Sous-Total", "Bonus (35 pts)", "Total I", "Max", "Min", "Total II", "Suite (20 pts)", "Full (30 pts)", "Carré (40 pts)", "Yam (50 pts)", "Total III", "Total"],
    .en: ["Aces", "Twos", "Threes", "Fours", "Fives", "Sixes", "Subtotal", "Bonus (35 pts)", "Total I", "Max", "Min", "Total II", "Straight (20 pts)", "Full House (30 pts)", "Four of a Kind (40 pts)", "Yahtzee (50 pts)", "Total III", "Grand Total"]
]

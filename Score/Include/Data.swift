//
//  Data.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import Foundation


enum Languages: Codable {
    case fr, en, es, pt, it, de
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
        .en: "Settings",
        .es: "Configuración",
        .pt: "Configurações",
        .it: "Impostazioni",
        .de: "Einstellungen"
    ],
    "settingsPicker": [
        .fr: "Choisissez votre langue",
        .en: "Choose your language",
        .es: "Elige tu idioma",
        .pt: "Escolha seu idioma",
        .it: "Scegli la tua lingua",
        .de: "Wählen Sie Ihre Sprache"
    ],
    "settingsReset": [
        .fr: "Restaurer les paramètres",
        .en: "Reset settings",
        .es: "Restablecer configuración",
        .pt: "Restaurar configurações",
        .it: "Ripristina le impostazioni",
        .de: "Einstellungen zurücksetzen"
    ],
    "settingsAlert": [
        .fr: "Êtes-vous sûr ?",
        .en: "Are you sure?",
        .es: "¿Estás seguro?",
        .pt: "Tem certeza?",
        .it: "Sei sicuro?",
        .de: "Bist du sicher?"
    ],
    "settingsButtonCancel": [
        .fr: "Annuler",
        .en: "Cancel",
        .es: "Cancelar",
        .pt: "Cancelar",
        .it: "Annulla",
        .de: "Abbrechen"
    ],
    "settingsButtonAdds": [
        .fr: "Enlever les publicités",
        .en: "Remove adds",
        .es: "Eliminar anuncios",
        .pt: "Remover anúncios",
        .it: "Rimuovi pubblicità",
        .de: "Werbung entfernen"
    ],
    "settingsButtonAddsPrice": [
        .fr: "1,99€",
        .en: "1.99$",
        .es: "1,99€",
        .pt: "1,99€",
        .it: "1,99€",
        .de: "1,99€"
    ],
    "settingsButtonDailyAdds": [
        .fr: "Enlever les publicités pour 24 heures",
        .en: "Remove adds for 24 hours",
        .es: "Eliminar anuncios por 24 horas",
        .pt: "Remover anúncios por 24 horas",
        .it: "Rimuovi pubblicità per 24 ore",
        .de: "Werbung für 24 Stunden entfernen"
    ],
    "settingsReview": [
        .fr: "Laisser un commentaire",
        .en: "Review the app",
        .es: "Deja un comentario",
        .pt: "Deixe um comentário",
        .it: "Lascia una recensione",
        .de: "Bewerte die App"
    ],
    
    // GameSettingsView
    "rules": [
        .fr: "Règles",
        .en: "Rules",
        .es: "Reglas",
        .pt: "Regras",
        .it: "Regole",
        .de: "Regeln"
    ],
    "settings": [
        .fr: "Paramètres de la partie de ",
        .en: "Game settings of ",
        .es: "Configuración del juego de ",
        .pt: "Configurações do jogo de ",
        .it: "Impostazioni del gioco di ",
        .de: "Spieleinstellungen von "
    ],
    "cutomSettings": [
        .fr: "Paramètres de la partie",
        .en: "Game settings",
        .es: "Configuración del juego",
        .pt: "Configurações do jogo",
        .it: "Impostazioni del gioco",
        .de: "Spieleinstellungen"
    ],
    "showMore": [
        .fr: "Voir plus...",
        .en: "Show more...",
        .es: "Mostrar más...",
        .pt: "Mostrar mais...",
        .it: "Mostra di più...",
        .de: "Mehr anzeigen..."
    ],
    "showLess": [
        .fr: "Voir moins...",
        .en: "Show less...",
        .es: "Mostrar menos...",
        .pt: "Mostrar menos...",
        .it: "Mostra meno...",
        .de: "Weniger anzeigen..."
    ],
    "numberOfPlayers": [
        .fr: "Nombres de joueurs",
        .en: "Number of players",
        .es: "Número de jugadores",
        .pt: "Número de jogadores",
        .it: "Numero di giocatori",
        .de: "Anzahl der Spieler"
    ],
    "pseudo": [
        .fr: "Entrer votre nom",
        .en: "Enter your name",
        .es: "Ingresa tu nombre",
        .pt: "Digite seu nome",
        .it: "Inserisci il tuo nome",
        .de: "Gib deinen Namen ein"
    ],
    "launch": [
        .fr: "Lancer la partie",
        .en: "Launch game",
        .es: "Iniciar juego",
        .pt: "Iniciar jogo",
        .it: "Avvia il gioco",
        .de: "Spiel starten"
    ],
    "roundScore": [
        .fr: "Score du tour",
        .en: "Round score",
        .es: "Puntuación de la ronda",
        .pt: "Pontuação da rodada",
        .it: "Punteggio del round",
        .de: "Rundenergebnis"
    ],
    "overallScore": [
        .fr: "Score de la partie",
        .en: "Overall score",
        .es: "Puntuación total",
        .pt: "Pontuação geral",
        .it: "Punteggio totale",
        .de: "Gesamtpunktzahl"
    ],
    "maxScore": [
        .fr: "Score maximum",
        .en: "Max score",
        .es: "Puntuación máxima",
        .pt: "Pontuação máxima",
        .it: "Punteggio massimo",
        .de: "Höchstpunktzahl"
    ],
    "finishRound": [
        .fr: "Finir le tour",
        .en: "Finish round",
        .es: "Terminar ronda",
        .pt: "Terminar rodada",
        .it: "Termina il round",
        .de: "Runde beenden"
    ],
    "cancelGame": [
        .fr: "Annuler la partie",
        .en: "Cancel game",
        .es: "Cancelar juego",
        .pt: "Cancelar jogo",
        .it: "Annulla il gioco",
        .de: "Spiel abbrechen"
    ],
    "alertTitle": [
        .fr: "Noms en double",
        .en: "Duplicate names",
        .es: "Nombres duplicados",
        .pt: "Nomes duplicados",
        .it: "Nomi duplicati",
        .de: "Doppelte Namen"
    ],
    "alertMessage": [
        .fr: "S'il vous plaît, entrez un nom unique pour chaque joueur",
        .en: "Please enter unique names for all players",
        .es: "Por favor, ingrese nombres únicos para todos los jugadores",
        .pt: "Por favor, insira nomes exclusivos para todos os jogadores",
        .it: "Per favore, inserisci nomi unici per tutti i giocatori",
        .de: "Bitte geben Sie für alle Spieler einen eindeutigen Namen ein"
    ],
    "alertWinner": [
        .fr: "Le gagnant est ",
        .en: "The winner is ",
        .es: "El ganador es ",
        .pt: "O vencedor é ",
        .it: "Il vincitore è ",
        .de: "Der Gewinner ist "
    ],
    "alertLooser": [
        .fr: "Et le perdant est ",
        .en: "And the looser is ",
        .es: "Y el perdedor es ",
        .pt: "E o perdedor é ",
        .it: "E il perdente è ",
        .de: "Und der Verlierer ist "
    ],
    "continue": [
        .fr: "Reprendre",
        .en: "Continue",
        .es: "Continuar",
        .pt: "Continuar",
        .it: "Continua",
        .de: "Fortfahren"
    ],
    "round": [
        .fr: "Tour ",
        .en: "Round ",
        .es: "Ronda ",
        .pt: "Rodada ",
        .it: "Round ",
        .de: "Runde "
    ],
    "cancelSure": [
        .fr: "Êtes-vous sûrs ?",
        .en: "Are you sure?",
        .es: "¿Estás seguro?",
        .pt: "Tem certeza?",
        .it: "Sei sicuro?",
        .de: "Bist du sicher?"
    ],
    "yes": [
        .fr: "Oui",
        .en: "Yes",
        .es: "Sí",
        .pt: "Sim",
        .it: "Sì",
        .de: "Ja"
    ],
    "no": [
        .fr: "Non",
        .en: "No",
        .es: "No",
        .pt: "Não",
        .it: "No",
        .de: "Nein"
    ],
    
    // CardGamesView
    "cardGamesTitle": [
        .fr: "Jeux de Cartes",
        .en: "Card Games",
        .es: "Juegos de Cartas",
        .pt: "Jogos de Cartas",
        .it: "Giochi di Carte",
        .de: "Kartenspiele"
    ],
    
    // DiceGamesView
    "diceGamesTitle": [
        .fr: "Jeux de Dés",
        .en: "Dice Games",
        .es: "Juegos de Dados",
        .pt: "Jogos de Dados",
        .it: "Giochi di Dadi",
        .de: "Würfelspiele"
    ],
    "yamTitle": [
        .fr: "Yam",
        .en: "Yahtzee",
        .es: "Yam",
        .pt: "Yam",
        .it: "Yam",
        .de: "Yam"
    ],
    "saveGame": [
        .fr: "Sauvegarder",
        .en: "Save game",
        .es: "Guardar juego",
        .pt: "Salvar jogo",
        .it: "Salva il gioco",
        .de: "Spiel speichern"
    ],
    
    // CustomGamesView
    "customGame": [
        .fr: "Partie personnalisée",
        .en: "Custom game",
        .es: "Juego personalizado",
        .pt: "Jogo personalizado",
        .it: "Gioco personalizzato",
        .de: "Benutzerdefiniertes Spiel"
    ],
    "customGamesTitle": [
        .fr: "Paramètres personnalisés",
        .en: "Custom Parameters",
        .es: "Parámetros personalizados",
        .pt: "Parâmetros personalizados",
        .it: "Parametri personalizzati",
        .de: "Benutzerdefinierte Parameter"
    ],
    "countdown": [
        .fr: "Compte à rebours",
        .en: "Countdown",
        .es: "Cuenta atrás",
        .pt: "Contagem regressiva",
        .it: "Conto alla rovescia",
        .de: "Countdown"
    ],
    "countdownEnable": [
        .fr: "Voulez-vous un compte à rebours ? (en secondes)",
        .en: "Did you want a countdown ? (in seconds)",
        .es: "¿Quieres un cuenta atrás? (en segundos)",
        .pt: "Você quer uma contagem regressiva? (em segundos)",
        .it: "Vuoi un conto alla rovescia? (in secondi)",
        .de: "Möchten Sie einen Countdown? (in Sekunden)"
    ],
    "timeUp": [
        .fr: "Le temps est écoulé",
        .en: "Time's up",
        .es: "Se acabó el tiempo",
        .pt: "O tempo acabou",
        .it: "Il tempo è scaduto",
        .de: "Zeit abgelaufen"
    ],
    "timeUpMessage": [
        .fr: "Entrez votre score s'il vous plaît",
        .en: "Please enter your score",
        .es: "Por favor, ingresa tu puntuación",
        .pt: "Por favor, insira sua pontuação",
        .it: "Per favore, inserisci il tuo punteggio",
        .de: "Bitte geben Sie Ihren Punktestand ein"
    ],
    "scoreToWin": [
        .fr: "Score pour gagner",
        .en: "Score to win",
        .es: "Puntuación para ganar",
        .pt: "Pontuação para ganhar",
        .it: "Punteggio per vincere",
        .de: "Punkte zum Gewinnen"
    ],
    "scoreToLoose": [
        .fr: "Score pour perdre",
        .en: "Score to loose",
        .es: "Puntuación para perder",
        .pt: "Pontuação para perder",
        .it: "Punteggio per perdere",
        .de: "Punkte zum Verlieren"
    ]
]


// All games handle in app
let cardGames = ["Skyjo", "Uno"]
let diceGames = ["Yam"]


// List of rules
let rules: [String: [Languages: String]] = [
    // CardGamesView
    "skyjo": [
        .fr: "Objectif : Avoir le moins de points possible. La partie se termine lorsqu'un joueur atteint 100 points, et le joueur avec le score le plus bas gagne.\n\nMise en place : Chaque joueur dispose 12 cartes face cachée (3x4). Ils retournent 2 cartes. Le reste des cartes forme une pioche et une défausse.\n\nTour de jeu : Piochez une carte et remplacez-la par une carte de votre grille, ou défaussez-la et retournez une carte. Le but est de réduire votre total de points.\n\nFin de manche : Quand un joueur révèle toutes ses cartes, les points sont comptés. Les cartes en triple dans une colonne s'annulent.\n\nFin de partie : La partie se termine quand un joueur atteint 100 points. Le joueur avec le score le plus bas gagne.",
        .en: "Objective: Have the lowest score possible. The game ends when a player reaches 100 points, and the player with the lowest score wins.\n\nSetup: Each player arranges 12 cards face down (3x4). They flip 2 cards. The rest forms a draw pile and a discard pile.\n\nTurn: Draw a card and replace it with one in your grid, or discard it and flip a card. The goal is to lower your point total.\n\nEnd of round: When a player reveals all cards, points are counted. Three same cards in a column cancel out.\n\nEnd of game: The game ends when a player reaches 100 points. The player with the lowest score wins.",
        .es: "Objetivo: Tener la menor cantidad de puntos posible. El juego termina cuando un jugador alcanza los 100 puntos, y el jugador con la puntuación más baja gana.\n\nConfiguración: Cada jugador dispone de 12 cartas boca abajo (3x4). Se voltean 2 cartas. El resto de las cartas forma un mazo y una pila de descarte.\n\nTurno de juego: Saca una carta y reemplázala por una de tu cuadrícula, o descártala y voltea una carta. El objetivo es reducir tu total de puntos.\n\nFin de la ronda: Cuando un jugador revela todas sus cartas, se cuentan los puntos. Tres cartas iguales en una columna se anulan.\n\nFin del juego: El juego termina cuando un jugador alcanza los 100 puntos. El jugador con la puntuación más baja gana.",
        .pt: "Objetivo: Ter a menor pontuação possível. O jogo termina quando um jogador atinge 100 pontos, e o jogador com a menor pontuação vence.\n\nConfiguração: Cada jogador arranja 12 cartas viradas para baixo (3x4). Eles viram 2 cartas. O restante forma um monte de compras e um monte de descarte.\n\nTurno: Compre uma carta e substitua por uma de sua grade, ou descarte e vire uma carta. O objetivo é reduzir o total de pontos.\n\nFim da rodada: Quando um jogador revela todas as suas cartas, os pontos são contados. Três cartas iguais em uma coluna se anulam.\n\nFim do jogo: O jogo termina quando um jogador atinge 100 pontos. O jogador com a menor pontuação vence.",
        .it: "Obiettivo: Avere il punteggio più basso possibile. Il gioco termina quando un giocatore raggiunge 100 punti, e il giocatore con il punteggio più basso vince.\n\nPreparazione: Ogni giocatore dispone di 12 carte coperte (3x4). Vengono girate 2 carte. Il resto delle carte forma un mazzo di pesca e un mazzo di scarti.\n\nTurno: Pesca una carta e sostituiscila con una nella tua griglia, oppure scartala e gira una carta. L'obiettivo è ridurre il tuo totale di punti.\n\nFine del turno: Quando un giocatore rivela tutte le sue carte, i punti vengono conteggiati. Tre carte uguali in una colonna si annullano.\n\nFine del gioco: Il gioco termina quando un giocatore raggiunge 100 punti. Il giocatore con il punteggio più basso vince.",
        .de: "Ziel: Erziele die niedrigste Punktzahl. Das Spiel endet, wenn ein Spieler 100 Punkte erreicht, und der Spieler mit der niedrigsten Punktzahl gewinnt.\n\nAufbau: Jeder Spieler hat 12 Karten verdeckt (3x4). Zwei Karten werden aufgedeckt. Der Rest der Karten bildet einen Ziehstapel und einen Ablagestapel.\n\nSpielzug: Ziehe eine Karte und tausche sie gegen eine in deinem Raster, oder lege sie ab und decke eine Karte auf. Das Ziel ist es, deine Punktzahl zu senken.\n\nEnde der Runde: Wenn ein Spieler alle Karten aufgedeckt hat, werden die Punkte gezählt. Drei gleiche Karten in einer Spalte löschen sich gegenseitig aus.\n\nSpielende: Das Spiel endet, wenn ein Spieler 100 Punkte erreicht. Der Spieler mit der niedrigsten Punktzahl gewinnt."
    ],
    "uno": [
        .fr: "Objectif : Se débarrasser de toutes ses cartes. Le premier joueur à le faire gagne le tour, et les autres joueurs comptabilisent leurs points.\n\nMise en place : Distribuez 7 cartes à chaque joueur. Placez le reste des cartes face cachée pour former la pioche, et retournez la carte du dessus pour démarrer la défausse.\n\nTour de jeu : Faites correspondre la couleur ou le numéro de la carte de la défausse avec une de vos cartes. Si vous ne pouvez pas jouer, piochez une carte. Utilisez des cartes spéciales pour ajouter des rebondissements (changer la couleur, passer le tour, inverser le sens, etc.).\n\nComptabilisation des points :\n-Cartes numérotées (0-9) : Valeur faciale de la carte.\n-Cartes spéciales (Passer, Inverser, +2) : 20 points chacune.\n-Joker et +4 : 50 points chacune.\n-Fin du tour : Quand un joueur se débarrasse de toutes ses cartes, les autres joueurs comptabilisent les points des cartes qu'il leur reste en main. Le gagnant du tour ne reçoit aucun point. Continuez à jouer jusqu'à ce qu'un joueur atteigne le score maximum défini, généralement 500 points.\n\nFin de partie : La partie se termine lorsque quelqu'un atteint ou dépasse le score maximum fixé au départ (ex : 500 points). Le joueur avec le score le plus bas est déclaré vainqueur.",
        .en: "Objective: Get rid of all your cards. The first player to do so wins the round, and the other players tally their points.\n\nSetup: Deal 7 cards to each player. Place the remaining cards face down to form the draw pile, and turn over the top card to start the discard pile.\n\nTurn: Match the color or number of the discard pile with one of your cards. If you can't play, draw a card. Use special cards to add twists (change color, skip turn, reverse direction, etc.).\n\nScoring:\n-Number cards (0-9): Face value of the card.\n-Special cards (Skip, Reverse, +2): 20 points each.\n-Wild and +4 Wild cards: 50 points each.\n-End of the round: When a player gets rid of all their cards, the other players score the points from the cards remaining in their hand. The winner of the round scores no points. Continue playing until a player reaches the set maximum score, usually 500 points.\n\nEnd of Game: The game ends when someone reaches or exceeds the set maximum score (e.g., 500 points). The player with the lowest score is declared the winner.",
        .es: "Objetivo: Descartar todas tus cartas. El primer jugador en hacerlo gana la ronda, y los otros jugadores contabilizan sus puntos.\n\nConfiguración: Reparte 7 cartas a cada jugador. Coloca el resto de las cartas boca abajo para formar el mazo, y voltea la carta superior para comenzar la pila de descarte.\n\nTurno de juego: Haz coincidir el color o el número de la carta del descarte con una de tus cartas. Si no puedes jugar, saca una carta. Usa cartas especiales para agregar giros (cambiar de color, saltar el turno, invertir dirección, etc.).\n\nContabilización de puntos:\n-Cartas numeradas (0-9): Valor nominal de la carta.\n-Cartas especiales (Saltar, Invertir, +2): 20 puntos cada una.\n-Cartas comodín y +4: 50 puntos cada una.\n-Fin de la ronda: Cuando un jugador se deshace de todas sus cartas, los demás jugadores contabilizan los puntos de las cartas que les quedan en la mano. El ganador de la ronda no recibe puntos. Continúa jugando hasta que un jugador alcance la puntuación máxima definida, generalmente 500 puntos.\n\nFin del juego: El juego termina cuando alguien alcanza o supera la puntuación máxima establecida (por ejemplo, 500 puntos). El jugador con la puntuación más baja es declarado ganador.",
        .pt: "Objetivo: Descartar todas as suas cartas. O primeiro jogador a fazer isso ganha a rodada, e os outros jogadores somam seus pontos.\n\nConfiguração: Distribua 7 cartas para cada jogador. Coloque as cartas restantes viradas para baixo para formar o monte de compras, e vire a carta do topo para começar o monte de descarte.\n\nTurno: Combine a cor ou número da carta do monte de descarte com uma das suas cartas. Se você não puder jogar, compre uma carta. Use cartas especiais para adicionar reviravoltas (mudar a cor, pular o turno, inverter a direção, etc.).\n\nContagem de pontos:\n-Cartas numeradas (0-9): Valor nominal da carta.\n-Cartas especiais (Pular, Inverter, +2): 20 pontos cada.\n-Cartas coringas e +4: 50 pontos cada.\n-Fim da rodada: Quando um jogador se desfaz de todas as suas cartas, os outros jogadores somam os pontos das cartas que restam em suas mãos. O vencedor da rodada não recebe pontos. Continue jogando até que um jogador atinja a pontuação máxima definida, geralmente 500 pontos.\n\nFim do jogo: O jogo termina quando alguém alcança ou ultrapassa a pontuação máxima definida (por exemplo, 500 pontos). O jogador com a menor pontuação é declarado vencedor.",
        .it: "Obiettivo: Liberarsi di tutte le carte. Il primo giocatore a farlo vince il turno, e gli altri giocatori conteggiano i loro punti.\n\nPreparazione: Distribuisci 7 carte a ogni giocatore. Posiziona le carte rimanenti coperte per formare il mazzo, e gira la carta superiore per iniziare il mazzo degli scarti.\n\nTurno: Abbina il colore o il numero della carta degli scarti con una delle tue carte. Se non puoi giocare, pesca una carta. Usa le carte speciali per aggiungere colpi di scena (cambiare colore, saltare il turno, invertire la direzione, ecc.).\n\nConteggio dei punti:\n-Cartelle numerate (0-9): Valore nominale della carta.\n-Cartelle speciali (Salta, Inverti, +2): 20 punti ciascuna.\n-Cartelle jolly e +4: 50 punti ciascuna.\n-Fine del turno: Quando un giocatore si libera di tutte le sue carte, gli altri giocatori sommano i punti delle carte che gli rimangono in mano. Il vincitore del turno non riceve punti. Continua a giocare finché un giocatore non raggiunge il punteggio massimo stabilito, solitamente 500 punti.\n\nFine del gioco: Il gioco termina quando qualcuno raggiunge o supera il punteggio massimo stabilito (esempio, 500 punti). Il giocatore con il punteggio più basso è dichiarato vincitore.",
        .de: "Ziel: Alle Karten ablegen. Der erste Spieler, der dies tut, gewinnt die Runde, und die anderen Spieler zählen ihre Punkte.\n\nAufbau: Jeder Spieler erhält 7 Karten. Der Rest der Karten wird verdeckt als Nachziehstapel abgelegt, und die oberste Karte wird umgedreht, um den Ablagestapel zu starten.\n\nSpielzug: Ordne die Farbe oder Zahl der Ablagestapelkarte einer deiner Karten zu. Wenn du nicht spielen kannst, ziehe eine Karte. Nutze Spezialkarten, um Wendungen hinzuzufügen (Farbe wechseln, Runde überspringen, Richtung umkehren, etc.).\n\nPunktzählung:\n-Nummerkarten (0-9): Nennwert der Karte.\n-Spezialkarten (Überspringen, Umkehren, +2): 20 Punkte je Karte.\n-Wildcards und +4 Wildcards: 50 Punkte je Karte.\n-Ende der Runde: Wenn ein Spieler alle seine Karten abgelegt hat, zählen die anderen Spieler die Punkte der Karten, die sie noch auf der Hand haben. Der Gewinner der Runde erhält keine Punkte. Spiele weiter, bis ein Spieler die festgelegte Höchstpunktzahl erreicht, in der Regel 500 Punkte.\n\nSpielende: Das Spiel endet, wenn ein Spieler die festgelegte Höchstpunktzahl erreicht oder überschreitet (z.B. 500 Punkte). Der Spieler mit der niedrigsten Punktzahl wird zum Gewinner erklärt."
    ],
    
    // DiceGamesView
    "yam": [
        .fr: "Objectif : Obtenir le plus de points possible en lançant des dés pour réaliser des combinaisons spécifiques.\n\nMise en place : Chaque joueur reçoit un tableau de score avec différentes catégories. Le jeu se joue avec 5 dés.\n\nTour de jeu : À chaque tour, le joueur peut lancer les dés jusqu'à trois fois. Après chaque lancer, il peut choisir de garder certains dés et de relancer les autres pour essayer d’obtenir une combinaison souhaitée.\n\nCombinaisons : Les combinaisons possibles incluent :\nCarré : Quatre dés identiques\nFull : Un brelan et une paire\nGrande suite : Cinq dés consécutifs\nYam : Cinq dés identiques\n\nFin de partie : Après 12 tours, chaque joueur a rempli toutes les catégories de son tableau de score. Les points sont comptés selon les combinaisons obtenues et le joueur avec le total le plus élevé gagne.",
        .en: "Objective: Score the most points by rolling dice to achieve specific combinations.\n\nSetup: Each player gets a score sheet with different categories. The game uses 5 dice.\n\nTurn: On each turn, a player can roll the dice up to three times. After each roll, they can choose to keep certain dice and re-roll the others to try for a desired combination.\n\nCombinations: Possible combinations include:\nFour of a Kind: Four identical dice\nFull House: Three of a kind and a pair\nLarge Straight: Five consecutive dice\nYahtzee: Five identical dice\n\nEnd of Game: After 12 rounds, each player has filled out all categories on their score sheet. Points are totaled, and the player with the highest score wins.",
        .es: "Objetivo: Obtener la mayor cantidad de puntos posible lanzando los dados para lograr combinaciones específicas.\n\nConfiguración: Cada jugador recibe una hoja de puntuación con diferentes categorías. El juego se juega con 5 dados.\n\nTurno de juego: En cada turno, el jugador puede lanzar los dados hasta tres veces. Después de cada lanzamiento, puede elegir mantener ciertos dados y volver a lanzar los otros para intentar obtener una combinación deseada.\n\nCombinaciones: Las combinaciones posibles incluyen:\nCuatro iguales: Cuatro dados idénticos\nFull: Un trío y una pareja\nEscalera mayor: Cinco dados consecutivos\nYam: Cinco dados idénticos\n\nFin del juego: Después de 12 rondas, cada jugador ha llenado todas las categorías en su hoja de puntuación. Se suman los puntos y el jugador con la puntuación más alta gana.",
        .pt: "Objetivo: Marcar o maior número de pontos possível rolando os dados para realizar combinações específicas.\n\nConfiguração: Cada jogador recebe uma folha de pontuação com diferentes categorias. O jogo usa 5 dados.\n\nTurno: Em cada turno, o jogador pode rolar os dados até três vezes. Após cada rolagem, ele pode escolher manter certos dados e rolar os outros novamente para tentar obter uma combinação desejada.\n\nCombinações: As combinações possíveis incluem:\nQuadra: Quatro dados iguais\nFull House: Três iguais e uma dupla\nEscada alta: Cinco dados consecutivos\nYam: Cinco dados iguais\n\nFim do jogo: Após 12 rodadas, cada jogador preenche todas as categorias da sua folha de pontuação. Os pontos são somados, e o jogador com a maior pontuação vence.",
        .it: "Obiettivo: Ottenere il punteggio più alto possibile lanciando i dadi per ottenere combinazioni specifiche.\n\nPreparazione: Ogni giocatore riceve un foglio punteggio con diverse categorie. Il gioco si gioca con 5 dadi.\n\nTurno: Ad ogni turno, un giocatore può lanciare i dadi fino a tre volte. Dopo ogni lancio, può scegliere di tenere alcuni dadi e rilanciare gli altri per cercare di ottenere una combinazione desiderata.\n\nCombinazioni: Le combinazioni possibili includono:\nQuadra: Quattro dadi identici\nFull: Un tris e una coppia\nScala alta: Cinque dadi consecutivi\nYam: Cinque dadi identici\n\nFine del gioco: Dopo 12 turni, ogni giocatore ha compilato tutte le categorie sul suo foglio punteggio. I punti vengono sommati e il giocatore con il punteggio più alto vince.",
        .de: "Ziel: Erreiche die meisten Punkte, indem du Würfel wirfst, um spezifische Kombinationen zu erzielen.\n\nAufbau: Jeder Spieler erhält ein Punktezettel mit verschiedenen Kategorien. Das Spiel verwendet 5 Würfel.\n\nSpielzug: In jedem Zug kann der Spieler die Würfel bis zu dreimal werfen. Nach jedem Wurf kann der Spieler entscheiden, bestimmte Würfel zu behalten und die anderen erneut zu werfen, um eine gewünschte Kombination zu erzielen.\n\nKombinationen: Mögliche Kombinationen umfassen:\nVier Gleiche: Vier identische Würfel\nFull House: Ein Drilling und ein Paar\nGroße Straße: Fünf aufeinanderfolgende Würfel\nYam: Fünf identische Würfel\n\nSpielende: Nach 12 Runden hat jeder Spieler alle Kategorien auf seinem Punktezettel ausgefüllt. Die Punkte werden summiert, und der Spieler mit der höchsten Punktzahl gewinnt."
    ],
    
    // CustomGamesView
    "customGames": [
        .fr: "Objectif : Atteindre la limite de points définie ou être le dernier joueur à rester en jeu sans dépasser cette limite. Personnalisez les paramètres pour ajuster la durée et le défi de la partie.\n\nMise en place : Déterminez le nombre de joueurs (entre 1 et 12). Chaque joueur reçoit un ensemble de cartes ou d'éléments de jeu de départ, selon les règles choisies. Choisissez une limite de points (de 50 à 500) pour déclarer un vainqueur.\n\nTour de jeu : Chaque joueur prend son tour en suivant l'ordre établi (par défaut, dans le sens horaire). Utilisez les cartes spéciales ou les actions pour atteindre les objectifs définis sans dépasser la limite de points. Un timer peut être activé pour limiter la durée de chaque tour, avec des intervalles allant de 10 secondes à 500 secondes.\n\nComptabilisation des points :\n-Cartes ou éléments de jeu ordinaires : Valeur définie par les règles de la partie.\n-Cartes spéciales : Valeur attribuée selon leur effet (par exemple, ajouter ou soustraire des points, donner des avantages spécifiques).\n\nFin du tour : Lorsqu'un joueur termine son tour, passez au joueur suivant. Si un joueur atteint la limite de points définie, la manche se termine, et le score est calculé.\n\nFin de partie : La partie se termine lorsqu'un joueur atteint ou dépasse la limite de points définie (par exemple, 500 points) ou lorsqu'il ne reste qu'un seul joueur. Le joueur avec le score le plus haut est déclaré vainqueur.",
        .en: "Objective: Reach the defined point limit or be the last player remaining without exceeding it. Customize the settings to adjust the game's duration and challenge level.\n\nSetup: Determine the number of players (from 1 to 12). Each player receives an initial set of cards or game elements based on the chosen rules. Set a point limit (from 50 to 500) to declare a winner.\n\nTurn: Each player takes their turn following the established order (default is clockwise). Use special cards or actions to reach the objectives without exceeding the point limit. A timer can be set to limit each turn’s duration, ranging from 10 to 500 seconds.\n\nScoring:\n-Regular cards or game elements: Value as defined by the game rules.\n-Special cards: Points assigned according to their effect (e.g., add or subtract points, provide specific advantages).\n\nEnd of the Round: When a player ends their turn, move to the next player. If a player reaches the defined point limit, the round ends, and scores are calculated.\n\nEnd of Game: The game ends when a player reaches or exceeds the defined point limit (e.g., 500 points) or only one player remains. The player with the highest score is declared the winner.",
        .es: "Objetivo: Alcanzar el límite de puntos definido o ser el último jugador en permanecer en el juego sin exceder ese límite. Personaliza los parámetros para ajustar la duración y desafío del juego.\n\nConfiguración: Determina el número de jugadores (de 1 a 12). Cada jugador recibe un conjunto de cartas o elementos de juego iniciales según las reglas elegidas. Establece un límite de puntos (de 50 a 500) para declarar un ganador.\n\nTurno: Cada jugador toma su turno siguiendo el orden establecido (por defecto, en sentido horario). Usa cartas especiales o acciones para alcanzar los objetivos definidos sin superar el límite de puntos. Se puede activar un temporizador para limitar la duración de cada turno, con intervalos de 10 segundos a 500 segundos.\n\nContabilización de puntos:\n-Cartas o elementos de juego ordinarios: Valor definido por las reglas del juego.\n-Cartas especiales: Puntos asignados según su efecto (por ejemplo, sumar o restar puntos, dar ventajas específicas).\n\nFin del turno: Cuando un jugador termina su turno, pasa al siguiente jugador. Si un jugador alcanza el límite de puntos definido, termina la ronda y se calculan los puntos.\n\nFin del juego: El juego termina cuando un jugador alcanza o supera el límite de puntos definido (por ejemplo, 500 puntos) o solo queda un jugador. El jugador con la mayor puntuación es declarado el ganador.",
        .pt: "Objetivo: Atingir o limite de pontos definido ou ser o último jogador restante sem ultrapassar esse limite. Personalize as configurações para ajustar a duração e o desafio do jogo.\n\nConfiguração: Determine o número de jogadores (de 1 a 12). Cada jogador recebe um conjunto inicial de cartas ou elementos do jogo de acordo com as regras escolhidas. Defina um limite de pontos (de 50 a 500) para declarar um vencedor.\n\nTurno: Cada jogador faz sua jogada seguindo a ordem estabelecida (por padrão, no sentido horário). Use cartas especiais ou ações para atingir os objetivos definidos sem ultrapassar o limite de pontos. Um temporizador pode ser ativado para limitar a duração de cada turno, variando de 10 a 500 segundos.\n\nContabilização de pontos:\n-Cartas ou elementos de jogo comuns: Valor definido pelas regras do jogo.\n-Cartas especiais: Pontos atribuídos de acordo com seu efeito (por exemplo, adicionar ou subtrair pontos, fornecer vantagens específicas).\n\nFim da rodada: Quando um jogador termina sua vez, passa para o próximo jogador. Se um jogador atingir o limite de pontos definido, a rodada termina e os pontos são calculados.\n\nFim do jogo: O jogo termina quando um jogador atinge ou ultrapassa o limite de pontos definido (por exemplo, 500 pontos) ou quando resta apenas um jogador. O jogador com a maior pontuação é declarado o vencedor.",
        .it: "Obiettivo: Raggiungere il limite di punti definito o essere l'ultimo giocatore a rimanere in gioco senza superare tale limite. Personalizza le impostazioni per regolare la durata e la difficoltà del gioco.\n\nPreparazione: Determina il numero di giocatori (da 1 a 12). Ogni giocatore riceve un set iniziale di carte o elementi di gioco in base alle regole scelte. Imposta un limite di punti (da 50 a 500) per dichiarare il vincitore.\n\nTurno: Ogni giocatore prende il proprio turno seguendo l'ordine stabilito (di default in senso orario). Usa carte speciali o azioni per raggiungere gli obiettivi definiti senza superare il limite di punti. Può essere attivato un timer per limitare la durata di ogni turno, da 10 a 500 secondi.\n\nConteggio dei punti:\n-Cartelle o elementi di gioco ordinari: Valore definito dalle regole del gioco.\n-Cartelle speciali: Punti assegnati in base al loro effetto (ad esempio, aggiungere o sottrarre punti, fornire vantaggi specifici).\n\nFine del turno: Quando un giocatore termina il proprio turno, passa al giocatore successivo. Se un giocatore raggiunge il limite di punti definito, la mano termina e si calcolano i punti.\n\nFine del gioco: Il gioco termina quando un giocatore raggiunge o supera il limite di punti definito (ad esempio, 500 punti) o quando rimane solo un giocatore. Il giocatore con il punteggio più alto è dichiarato vincitore.",
        .de: "Ziel: Erreiche das definierte Punktlimit oder sei der letzte verbleibende Spieler, ohne dieses zu überschreiten. Passe die Einstellungen an, um die Dauer und den Schwierigkeitsgrad des Spiels anzupassen.\n\nAufbau: Bestimme die Anzahl der Spieler (von 1 bis 12). Jeder Spieler erhält ein Anfangsset an Karten oder Spielelementen gemäß den gewählten Regeln. Lege ein Punktlimit fest (von 50 bis 500), um einen Gewinner zu erklären.\n\nSpielzug: Jeder Spieler macht seinen Zug in der festgelegten Reihenfolge (standardmäßig im Uhrzeigersinn). Verwende Spezialkarten oder Aktionen, um die Ziele zu erreichen, ohne das Punktlimit zu überschreiten. Ein Timer kann aktiviert werden, um die Dauer jedes Zuges auf 10 bis 500 Sekunden zu begrenzen.\n\nPunktberechnung:\n-Reguläre Karten oder Spielelemente: Wert gemäß den Spielregeln.\n-Spezialkarten: Punkte werden gemäß ihrer Wirkung zugewiesen (z. B. Punkte hinzufügen oder subtrahieren, bestimmte Vorteile gewähren).\n\nRundenende: Wenn ein Spieler seinen Zug beendet, geht es zum nächsten Spieler. Wenn ein Spieler das festgelegte Punktlimit erreicht, endet die Runde und die Punkte werden berechnet.\n\nSpielende: Das Spiel endet, wenn ein Spieler das definierte Punktlimit erreicht oder überschreitet (z. B. 500 Punkte) oder nur noch ein Spieler übrig bleibt. Der Spieler mit der höchsten Punktzahl wird zum Gewinner erklärt."
    ]
]


// Scores array for Yahtzee
let yamScoresString: [Languages: [String]] = [
    .fr: ["Joueurs", "As", "Deux", "Trois", "Quatre", "Cinq", "Six", "Sous-Total", "Bonus", "Total I", "Moins", "Plus", "Total II", "Suite", "Full", "Carré", "Yam", "Total III", "Total"],
    .en: ["Players", "Aces", "Twos", "Threes", "Fours", "Fives", "Sixes", "Subtotal", "Bonus", "Total I", "Less", "More", "Total II", "Straight", "Full House", "Four of a Kind", "Yahtzee", "Total III", "Grand Total"],
    .es: ["Jugadores", "As", "Dos", "Tres", "Cuatro", "Cinco", "Seis", "Subtotal", "Bono", "Total I", "Menos", "Más", "Total II", "Escalera", "Full", "Póker", "Yam", "Total III", "Total"],
    .pt: ["Jogadores", "Ases", "Dois", "Três", "Quatro", "Cinco", "Seis", "Subtotal", "Bônus", "Total I", "Menos", "Mais", "Total II", "Sequência", "Full", "Quadra", "Yam", "Total III", "Total"],
    .it: ["Giocatori", "Assi", "Due", "Tre", "Quattro", "Cinque", "Sei", "Subtotale", "Bonus", "Totale I", "Meno", "Più", "Totale II", "Scala", "Full", "Poker", "Yam", "Totale III", "Totale"],
    .de: ["Spieler", "Asse", "Zwei", "Drei", "Vier", "Fünf", "Sechs", "Zwischensumme", "Bonus", "Gesamt I", "Weniger", "Mehr", "Gesamt II", "Straße", "Full House", "Vierling", "Yahtzee", "Gesamt III", "Gesamtsumme"]
]

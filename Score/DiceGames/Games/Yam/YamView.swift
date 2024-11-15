//
//  YamView.swift
//  Score
//
//  Created by Thomas Meyer on 06/11/2024.
//


import SwiftUI


struct YamView: View {
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfPlayer: Int
    @State private var names: [String]
    @State private var rules: [String]
    @State private var scores: [String]
    @State private var playerScores: [String: [Int]]
    @State private var isPartyFinished = false
    @State private var isCancelSure = false
    @State private var roundNumber = 1
    @State private var nameForCustomKeyboard = ""
    @State private var isShowingKeyboard = false
    @State private var isDisabled = false
    @State private var isNewGame: Bool
    @State private var activePlayer: String? = nil
    @State private var activeRuleIndex: Int? = nil
    
    let totalsAndBonuses: [Int] = [7, 8, 9, 12, 17, 18]
    
    init(numberOfPlayer: Int, names: [String], language: Languages, isNewGame: Bool) {
        self._numberOfPlayer = State(initialValue: numberOfPlayer)
        self._names = State(initialValue: names)
        self._rules = State(initialValue: getYamScoresString(forLanguage: language))
        let scoreList = getYamScoresString(forLanguage: language)
        self._scores = State(initialValue: scoreList)
        self._playerScores = State(initialValue: names.reduce(into: [:]) { $0[$1] = Array(repeating: 0, count: scoreList.count) })
        self._isNewGame = State(initialValue: isNewGame)
    }
    
    var body: some View {
        VStack {
            Group {
                Text(getText(forKey: "round", forLanguage: data.languages)) +
                Text("\(roundNumber)")
            }
            .font(.title2)
            .padding()
            .foregroundStyle(.white)
            .background(.secondary)
            .clipShape(.rect(cornerRadius: 30))
            
            Form {
                Section(getText(forKey: "overallScore", forLanguage: data.languages)) {
                    ScrollView(.horizontal) {
                        VStack(alignment: .leading) {
                            ForEach(rules.indices, id: \.self) { index in
                                HStack {
                                    cellView(text: rules[index], menu: true, players: index == 0 ? true : false)
                                    
                                    if index == 0 {
                                        ForEach(names, id: \.self) { name in
                                            cellView(text: name, title: true)
                                        }
                                    } else {
                                        ForEach(names, id: \.self) { name in
                                            cellView(text: "\(playerScores[name]?[index] ?? 0)", playerName: name, ruleIndex: index, menu: totalsAndBonuses.contains(index) ? true : false)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            loadButtons()
        }
        .navigationTitle(getText(forKey: "yamTitle", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupInitialScore()
        }
//        .alert(isPresented: $isPartyFinished) {
//            Alert(
//                title: Text(getText(forKey: "alertWinner", forLanguage: data.languages)) + Text(getLeaderName()!),
//                message: Text(getText(forKey: "alertLooser", forLanguage: data.languages)) + Text(getLooserName()!) + Text(" (\(nameAndScore[getLooserName()!] ?? 0))"),
//                dismissButton: .default(Text("OK")) {
//                    cleanData()
//                }
//            )
//        }
        .sheet(isPresented: $isShowingKeyboard) {
            if let playerName = activePlayer, let ruleIndex = activeRuleIndex {
                CustomKeyboard(
                    input: Binding(
                        get: { playerScores[playerName]?[ruleIndex] ?? 0 },
                        set: { newValue in playerScores[playerName]?[ruleIndex] = newValue }
                    )
                )
            }
        }
        .onChange(of: isShowingKeyboard) { oldValue, newValue in
            if !newValue {
                isDisabled = false
            }
        }
    }
    
    func loadButtons() -> some View {
        HStack {
            Spacer()
            
            Button(getText(forKey: "finishRound", forLanguage: data.languages), action: endRound)
            .padding()
            .foregroundStyle(.white)
            .background(.green)
            .cornerRadius(10)
            
            Spacer()
            
            Button(getText(forKey: "cancelGame", forLanguage: data.languages)) {
                isCancelSure = true
            }
            .padding()
            .foregroundStyle(.white)
            .background(.red)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .alert(getText(forKey: "cancelSure", forLanguage: data.languages), isPresented: $isCancelSure) {
            Button(getText(forKey: "yes", forLanguage: data.languages), role: .destructive, action: cleanData)
            Button(getText(forKey: "no", forLanguage: data.languages), role: .cancel) {}
        }
    }
    
    func cellView(text: String, playerName: String? = nil, ruleIndex: Int? = nil, isLeader: Bool = false, menu: Bool = false, title: Bool = false, players: Bool = false) -> some View {
        HStack {
            if isLeader {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
            }
            Text(text)
                .lineLimit(1)
                .fontWeight(title ? .bold : menu && (text.lowercased().contains("total") || text.lowercased().contains("bonus")) ? .bold : players ? .bold : nil)
        }
        .frame(width: 80, height: 40)
        .padding()
        .border(.gray, width: 1)
        .background(menu || title ? Color(.systemGray5) : nil)
        .onTapGesture {
            if let playerName = playerName, let ruleIndex = ruleIndex {
                guard !totalsAndBonuses.contains(ruleIndex) else { return }
                
                activePlayer = playerName
                activeRuleIndex = ruleIndex
                isShowingKeyboard = true
            }
        }
    }
//    
//    func getLeaderName() -> String? {
//        nameAndScore.min(by: { $0.value < $1.value })?.key
//    }
//    
//    func getLooserName() -> String? {
//        nameAndScore.max(by: { $0.value < $1.value })?.key
//    }
    
    func endRound() {
        roundNumber += 1
        saveData()
        
//        for name in nameAndScore.keys {
//            if let roundScore = roundScores[name] {
//                nameAndScore[name, default: 0] += roundScore
//            }
//            roundScores[name] = 0
//        }
        
//        let possibleLooser = nameAndScore.max(by: { $0.value < $1.value })?.value
//        if possibleLooser! >= Int(maxScore) {
//            isPartyFinished = true
//        }
    }
    
    func setupInitialScore() {
        if !isNewGame {
            loadData()
        } else {
            UserDefaults.standard.set(false, forKey: "partyYamOngoing")
            let scores = [Int](repeating: 0, count: numberOfPlayer)
            var combinedDict: [String: Int] = [:]
            for (index, name) in names.enumerated() {
                combinedDict[name] = scores[index]
            }
            
//            nameAndScore = combinedDict
//            roundScores = combinedDict
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(true, forKey: "partyYamOngoing")
//        let data = CardGameData(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores, roundNumber: roundNumber)
        
//        if let encodedGameData = try? JSONEncoder().encode(data) {
//            UserDefaults.standard.set(encodedGameData, forKey: "SkyjoGameData")
//        }
    }
    
    func loadData() {
//        if let data = UserDefaults.standard.data(forKey: "SkyjoGameData") {
//            if let decodedGameData = try? JSONDecoder().decode(CardGameData.self, from: data) {
//                numberOfPlayer = decodedGameData.numberOfPlayer
//                maxScore = decodedGameData.maxScore
//                names = decodedGameData.names
//                nameAndScore = decodedGameData.nameAndScore
//                roundScores = decodedGameData.roundScores
//                roundNumber = decodedGameData.roundNumber
//                
//                for name in nameAndScore.keys {
//                    if let roundScore = roundScores[name] {
//                        nameAndScore[name, default: 0] += roundScore
//                    }
//                    roundScores[name] = 0
//                }
//            }
//        }
    }
    
    func cleanData() {
        UserDefaults.standard.set(false, forKey: "partyYamOngoing")
        dismiss()
    }
}

#Preview {
    YamView(numberOfPlayer: 2, names: ["Thomas", "Zoé"], language: .fr, isNewGame: true)
        .environment(Data())
}

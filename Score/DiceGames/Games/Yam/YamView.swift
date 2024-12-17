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
    @State private var isCancelSure = false
    @State private var isShowingKeyboard = false
    @State private var isDisabled = false
    @State private var isNewGame: Bool
    @State private var activePlayer: String? = nil
    @State private var activeRuleIndex: Int? = nil
    
    let totalsAndBonuses: [Int] = [7, 8, 9, 12, 17, 18]
    let totalThreeScores: [Int: Int] = [13: 20, 14: 30, 15: 40, 16: 50]
    let combiScore : [Int] = [13, 14, 15, 16]
    
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
            Form {
                Section(getText(forKey: "overallScore", forLanguage: data.languages)) {
                    ScrollView(.horizontal) {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(rules.indices, id: \.self) { index in
                                HStack(spacing: 0) {
                                    cellView(text: rules[index], menu: true, players: index == 0 ? true : false)
                                    
                                    if index == 0 {
                                        ForEach(names, id: \.self) { name in
                                            cellView(text: name, isLeader: name == getLeaderName(), title: true)
                                        }
                                    } else if index == rules.count - 1 {
                                        ForEach(names, id: \.self) { name in
                                            cellView(text: "\(playerScores[name]?[index] ?? 0)", playerName: name, ruleIndex: index, menu: true, title: true, number: true)
                                        }
                                    } else {
                                        ForEach(names, id: \.self) { name in
                                            cellView(text: "\(playerScores[name]?[index] ?? 0)", playerName: name, ruleIndex: index, menu: totalsAndBonuses.contains(index) ? true : false, number: true)
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
            updateScore()
        }
    }
    
    func loadButtons() -> some View {
        HStack {
            Spacer()
            
            Button(getText(forKey: "saveGame", forLanguage: data.languages), action: saveData)
            .padding()
            .foregroundStyle(.white)
            .background(.green)
            .cornerRadius(10)
            .frame(height: 30)
            
            Spacer()
            
            Button(getText(forKey: "cancelGame", forLanguage: data.languages)) {
                isCancelSure = true
            }
            .padding()
            .foregroundStyle(.white)
            .background(.red)
            .cornerRadius(10)
            .frame(height: 30)
            
            Spacer()
        }
        .padding()
        .alert(getText(forKey: "cancelSure", forLanguage: data.languages), isPresented: $isCancelSure) {
            Button(getText(forKey: "yes", forLanguage: data.languages), role: .destructive, action: cleanData)
            Button(getText(forKey: "no", forLanguage: data.languages), role: .cancel) {}
        }
    }
    
    func cellView(text: String, playerName: String? = nil, ruleIndex: Int? = nil, isLeader: Bool = false, menu: Bool = false, title: Bool = false, players: Bool = false, number: Bool = false) -> some View {
        HStack {
            if let ruleIndex, ruleIndex > 12 && ruleIndex < 17 {
                if playerScores[playerName!]?[ruleIndex] == 0 {
                    HStack {
                        Button {
                            playerScores[playerName!]?[ruleIndex] = totalThreeScores[ruleIndex]!
                            updateScore()
                        } label: {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        }
                        Button {
                            playerScores[playerName!]?[ruleIndex] = -1
                            updateScore()
                        } label: {
                            Image(systemName: "xmark.seal.fill")
                                .foregroundStyle(.red)
                        }
                    }
                } else {
                    Text(text == "-1" ? "0" : text)
                        .fontWeight(title ? .bold : menu && (text.lowercased().contains("total") || text.lowercased().contains("bonus")) ? .bold : players ? .bold : nil)
                }
            } else {
                if isLeader {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                }
                Text(text)
                    .fontWeight(title ? .bold : menu && (text.lowercased().contains("total") || text.lowercased().contains("bonus")) ? .bold : players ? .bold : nil)
            }
        }
        .frame(width: 60, height: 20)
        .font(number ? .subheadline : .caption)
        .padding()
        .border(.gray, width: 1)
        .background(menu || title ? Color(.systemGray5) : nil)
        .contentShape(Rectangle())
        .onTapGesture {
            if let playerName = playerName, let ruleIndex = ruleIndex {
                guard !totalsAndBonuses.contains(ruleIndex) else { return }
                if let score = playerScores[playerName]?[ruleIndex], score != 0 && combiScore.contains(ruleIndex) {
                    playerScores[playerName]?[ruleIndex] = 0
                    updateScore()
                    return
                }
                
                activePlayer = playerName
                activeRuleIndex = ruleIndex
                isShowingKeyboard = true
            }
        }
    }
    
    func getLeaderName() -> String? {
        names.max {
                let scoreA = playerScores[$0]?[totalsAndBonuses.last!] ?? 0
                let scoreB = playerScores[$1]?[totalsAndBonuses.last!] ?? 0
                return scoreA < scoreB
            }
    }
   
    func getLooserName() -> String? {
        names.min {
                let scoreA = playerScores[$0]?[totalsAndBonuses.last!] ?? 0
                let scoreB = playerScores[$1]?[totalsAndBonuses.last!] ?? 0
                return scoreA < scoreB
            }
    }
    
    func updateScore() {
        let subTotalIndex = totalsAndBonuses[0]
        let bonusIndex = totalsAndBonuses[1]
        let totalOneIndex = totalsAndBonuses[2]
        let totalTwoIndex = totalsAndBonuses[3]
        let totalThreeIndex = totalsAndBonuses[4]
        let finalTotalIndex = totalsAndBonuses[5]
        
        let bonusThreshold = 63
        let bonusPoints = 35
        
        for name in names {
            var scores = playerScores[name] ?? []
            
            let subTotal = rules[0..<subTotalIndex].enumerated()
                .map { index, _ in scores[index] }
                .reduce(0, +)
            scores[subTotalIndex] = subTotal

            scores[bonusIndex] = subTotal >= bonusThreshold ? bonusPoints : 0

            let totalOne = subTotal + scores[bonusIndex]
            scores[totalOneIndex] = totalOne

            var totalTwo = (scores[totalOneIndex + 2] - scores[totalOneIndex + 1]) * scores[1]
            let checker = scores[totalOneIndex + 2] != 0 && scores[totalOneIndex + 1] != 0 && scores[1] != 0
            totalTwo = checker ? totalTwo : 0
            scores[totalTwoIndex] = totalTwo

            let totalThree = rules[(totalTwoIndex + 1)..<totalThreeIndex].enumerated()
                .map { index, _ in
                    let score = scores[index + totalTwoIndex + 1]
                    return score == -1 ? 0 : score
                }
                .reduce(0, +)
            scores[totalThreeIndex] = totalThree

            let finalTotal = totalOne + totalTwo + totalThree
            scores[finalTotalIndex] = finalTotal

            playerScores[name] = scores
        }
        
        saveData()
    }
    
    func setupInitialScore() {
        if !isNewGame {
            loadData()
        } else {
            UserDefaults.standard.set(false, forKey: "partyYamOngoing")
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(true, forKey: "partyYamOngoing")
        let data = YamGameData(numberOfPlayer: numberOfPlayer, names: names, playerScores: playerScores)
        
        if let encodedGameData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedGameData, forKey: "YamGameData")
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "YamGameData") {
            if let decodedGameData = try? JSONDecoder().decode(YamGameData.self, from: data) {
                numberOfPlayer = decodedGameData.numberOfPlayer
                names = decodedGameData.names
                playerScores = decodedGameData.playerScores
            }
        }
        
        updateScore()
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

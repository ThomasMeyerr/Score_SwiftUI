//
//  CustomGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 09/10/2024.
//

import SwiftUI


struct CustomGamesView: View {
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfPlayer: Int
    @State private var maxScore: Double
    @State private var names: [String]
    @State private var nameAndScore: [String: Int] = [:]
    @State private var roundScores: [String: Int] = [:]
    @State private var isPartyFinished = false
    @State private var isCancelSure = false
    @State private var roundNumber = 1
    @State private var nameForCustomKeyboard = ""
    @State private var isShowingKeyboard = false
    @State private var isDisabled = false
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String]) {
        self._numberOfPlayer = State(initialValue: numberOfPlayer)
        self._maxScore = State(initialValue: maxScore)
        self._names = State(initialValue: names)
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
                Section("Score") {
                    Grid {
                        ForEach(sortedNameAndScore(), id: \.key) { name, score in
                            GridRow {
                                HStack(spacing: 0) {
                                    cellView(text: name, isLeader: name == getLeaderName())
                                    cellView(text: String(score))
                                }
                            }
                        }
                    }
                }
                
                Section(getText(forKey: "players", forLanguage: data.languages)) {
                    ForEach(Array(roundScores.keys), id: \.self) { name in
                        HStack {
                            Text(name)
                            
                            Spacer()
                            
                            TextField("Score", value: Binding(
                                get: {
                                    roundScores[name] ?? 0
                                },
                                set: { newValue in
                                    roundScores[name] = newValue
                                    isDisabled = true
                                }
                            ), formatter: NumberFormatter())
                            .onTapGesture {
                                nameForCustomKeyboard = name
                                isShowingKeyboard = true
                            }
                            .disabled(isDisabled)
                        }
                    }
                }
            }
            
            loadButtons()
        }
        .navigationTitle("Skyjo")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupInitialScore()
        }
        .alert(isPresented: $isPartyFinished) {
            Alert(
                title: Text(getText(forKey: "alertWinner", forLanguage: data.languages)) + Text(getLeaderName()!),
                message: Text(getText(forKey: "alertLooser", forLanguage: data.languages)) + Text(getLooserName()!) + Text(" (\(nameAndScore[getLooserName()!] ?? 0))"),
                dismissButton: .default(Text("OK")) {
                    cleanData()
                }
            )
        }
        .sheet(isPresented: $isShowingKeyboard) {
            CustomKeyboard(input: Binding(
                get: { roundScores[nameForCustomKeyboard] ?? 0 },
                set: { newValue in roundScores[nameForCustomKeyboard] = newValue }
            ))
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
    
    func cellView(text: String, isLeader: Bool = false) -> some View {
        HStack {
            if isLeader {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
            }
            Text(text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .border(.gray, width: 1)
    }
    
    func sortedNameAndScore() -> [(key: String, value: Int)] {
        nameAndScore.sorted { $0.value < $1.value }
    }
    
    func getLeaderName() -> String? {
        nameAndScore.min(by: { $0.value < $1.value })?.key
    }
    
    func getLooserName() -> String? {
        nameAndScore.max(by: { $0.value < $1.value })?.key
    }
    
    func endRound() {
        roundNumber += 1
        saveData()
        
        for name in nameAndScore.keys {
            if let roundScore = roundScores[name] {
                nameAndScore[name, default: 0] += roundScore
            }
            roundScores[name] = 0
        }
        
        let possibleLooser = nameAndScore.max(by: { $0.value < $1.value })?.value
        if possibleLooser! >= Int(maxScore) {
            isPartyFinished = true
        }
    }
    
    func setupInitialScore() {
        if UserDefaults.standard.bool(forKey: "partyCustomOngoing") {
            loadData()
        } else {
            let scores = [Int](repeating: 0, count: numberOfPlayer)
            var combinedDict: [String: Int] = [:]
            for (index, name) in names.enumerated() {
                combinedDict[name] = scores[index]
            }
            
            nameAndScore = combinedDict
            roundScores = combinedDict
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(true, forKey: "partyCustomOngoing")
        let data = CardGameData(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores, roundNumber: roundNumber)
        
        if let encodedGameData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedGameData, forKey: "CustomGameData")
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "CustomGameData") {
            if let decodedGameData = try? JSONDecoder().decode(CardGameData.self, from: data) {
                numberOfPlayer = decodedGameData.numberOfPlayer
                maxScore = decodedGameData.maxScore
                names = decodedGameData.names
                nameAndScore = decodedGameData.nameAndScore
                roundScores = decodedGameData.roundScores
                roundNumber = decodedGameData.roundNumber
                
                for name in nameAndScore.keys {
                    if let roundScore = roundScores[name] {
                        nameAndScore[name, default: 0] += roundScore
                    }
                    roundScores[name] = 0
                }
            }
        }
    }
    
    func cleanData() {
        UserDefaults.standard.set(false, forKey: "partyCustomOngoing")
        dismiss()
    }
}

#Preview {
    CustomGamesView(numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"])
        .environment(Data())
}

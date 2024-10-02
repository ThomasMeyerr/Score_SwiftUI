//
//  SkyjoView.swift
//  Score
//
//  Created by Thomas Meyer on 18/09/2024.
//

import SwiftUI


struct SkyjoView: View {
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfPlayer: Int
    @State private var maxScore: Double
    @State private var names: [String]
    @State private var nameAndScore: [String: Int] = [:]
    @State private var roundScores: [String: Int] = [:]
    @State private var isShowingAlert = false
    @State private var roundNumber = 1
    
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
            .font(.title)
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
                                }
                            ), formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        }
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius:40)
                    .fill(Color.secondary.opacity(0.1))
            )
            
            loadButtons()
        }
        .navigationTitle("Skyjo")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupInitialScore()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text(getText(forKey: "alertWinner", forLanguage: data.languages)) + Text(getLeaderName()!),
                message: Text(getText(forKey: "alertLooser", forLanguage: data.languages)) + Text(getLooserName()!),
                dismissButton: .default(Text("OK")) {
                    cleanData()
                }
            )
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
            
            Button(getText(forKey: "cancelGame", forLanguage: data.languages), action: cleanData)
                .padding()
                .foregroundStyle(.white)
                .background(.red)
                .cornerRadius(10)
            
            Spacer()
        }
        .padding()
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
            isShowingAlert = true
        }
    }
    
    func setupInitialScore() {
        if UserDefaults.standard.bool(forKey: "partyOngoing") {
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
        UserDefaults.standard.set(true, forKey: "partyOngoing")
        let data = GameSkyjoData(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores, roundNumber: roundNumber)
        
        if let encodedGameData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedGameData, forKey: "GameData")
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "GameData") {
            if let decodedGameData = try? JSONDecoder().decode(GameSkyjoData.self, from: data) {
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
        UserDefaults.standard.set(false, forKey: "partyOngoing")
        dismiss()
    }
}

#Preview {
    SkyjoView(numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"])
        .environment(Data())
}

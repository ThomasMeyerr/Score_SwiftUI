//
//  SkyjoView.swift
//  Score
//
//  Created by Thomas Meyer on 18/09/2024.
//

import SwiftUI


class GameData: Codable {
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


struct SkyjoView: View {
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfPlayer: Int
    @State private var maxScore: Double
    @State private var names: [String]
    @State private var nameAndScore: [String: Int] = [:]
    @State private var roundScores: [String: Int] = [:]
    @State private var isShowingAlert = false
    
    @Binding var isPartyOngoing: Bool
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String], isPartyOngoing: Binding<Bool>) {
        self._numberOfPlayer = State(initialValue: numberOfPlayer)
        self._maxScore = State(initialValue: maxScore)
        self._names = State(initialValue: names)
        self._isPartyOngoing = isPartyOngoing
    }
    
    var body: some View {
        VStack {
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
                        }
                    }
                }
            }
            
            buttons()
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
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func buttons() -> some View {
        HStack {
            Spacer()
            Button(getText(forKey: "finishRound", forLanguage: data.languages), action: endRound)
                .buttonStyle(.borderedProminent)
            Spacer()
            Button(getText(forKey: "cancelGame", forLanguage: data.languages), role: .destructive, action: cleanData)
            .buttonStyle(.borderedProminent)
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
        if isPartyOngoing {
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
        isPartyOngoing = true
        let data = GameData(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores)
        
        if let encodedGameData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedGameData, forKey: "GameData")
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "GameData") {
            if let decodedGameData = try? JSONDecoder().decode(GameData.self, from: data) {
                numberOfPlayer = decodedGameData.numberOfPlayer
                maxScore = decodedGameData.maxScore
                names = decodedGameData.names
                nameAndScore = decodedGameData.nameAndScore
                roundScores = decodedGameData.roundScores
                
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
        isPartyOngoing = false
        dismiss()
    }
}

#Preview {
    SkyjoView(numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"], isPartyOngoing: .constant(false))
        .environment(Data())
}

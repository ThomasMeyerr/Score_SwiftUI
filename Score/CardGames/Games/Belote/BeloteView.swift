//
//  BeloteView.swift
//  Score
//
//  Created by Thomas Meyer on 20/01/2025.
//

import SwiftUI


struct BeloteView: View {
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfPlayer: Int
    @State private var maxScore: Double
    @State private var names: [String]
    @State private var nameAndScore: [String: Int] = [:]
    @State private var roundScores: [String: Int] = [:]
    @State private var isPartyFinished: Bool = false
    @State private var roundNumber: Int = 1
    @State private var nameForCustomKeyboard: String = ""
    @State private var isShowingKeyboard: Bool = false
    @State private var isDisabled: Bool = false
    @State private var isNewGame: Bool
    @State private var isFinished: Bool = false
    @State private var winner: String = ""
    
    var id: UUID
    
    init(id: UUID?, numberOfPlayer: Int, maxScore: Double, names: [String], isNewGame: Bool = false) {
        if id != nil {
            self.id = id!
        } else {
            self.id = UUID()
        }
        self._numberOfPlayer = State(initialValue: numberOfPlayer)
        self._maxScore = State(initialValue: maxScore)
        self._names = State(initialValue: names)
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
                
                Section(getText(forKey: "roundScore", forLanguage: data.languages)) {
                    ForEach(Array(roundScores.keys), id: \.self) { name in
                        HStack {
                            Text(name)
                            
                            Spacer()
                            
                            HStack {
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
                                .multilineTextAlignment(.trailing)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .truncationMode(.middle)
                            }
                        }
                    }
                }
            }
            
            loadButtons()
        }
        .navigationTitle("Belote")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupInitialScore()
        }
        .alert(isPresented: $isPartyFinished) {
            Alert(
                title: Text(getText(forKey: "alertWinner", forLanguage: data.languages)) + Text(getLeaderName()!),
                dismissButton: .default(Text("OK")) {
                    isFinished = true
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
            
            if !isFinished {
                Button(getText(forKey: "finishRound", forLanguage: data.languages), action: endRound)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.green)
                    .cornerRadius(10)
                    .frame(height: 30)
            }
            
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
        nameAndScore.sorted { $0.value > $1.value }
    }
    
    func getLeaderName() -> String? {
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
        
        let headScore = nameAndScore.max(by: { $0.value < $1.value })?.value
        if headScore! >= Int(maxScore) {
            isPartyFinished = true
            winner = getLeaderName() ?? ""
        } else {
            roundNumber += 1
        }
    }
    
    func setupInitialScore() {
        if !isNewGame {
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
        let data = CardGameData(id: id, numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores, roundNumber: roundNumber, isFinished: isFinished, winner: winner)
        data.lastUpdated = Date()
        
        if let beloteHistory = UserDefaults.standard.data(forKey: "BeloteHistory") {
            if var decodedHistory = try? JSONDecoder().decode(GameCardHistory.self, from: beloteHistory) {
                // Check if a same CardGameData exists with the same id
                if let index = decodedHistory.firstIndex(where: { $0.id == data.id }) {
                    decodedHistory[index] = data
                } else {
                    decodedHistory.append(data)
                }
                
                if let encodedHistory = try? JSONEncoder().encode(decodedHistory) {
                    UserDefaults.standard.setValue(encodedHistory, forKey: "BeloteHistory")
                }
            }
        } else {
            // Create a new history if none exists
            let newHistory: GameCardHistory = [data]
            
            if let encodedHistory = try? JSONEncoder().encode(newHistory) {
                UserDefaults.standard.setValue(encodedHistory, forKey: "BeloteHistory")
            }
        }
    }
    
    func loadData() {
        if let beloteHistory = UserDefaults.standard.data(forKey: "BeloteHistory") {
            if let decodedHistory = try? JSONDecoder().decode(GameCardHistory.self, from: beloteHistory) {
                // Check if a same CardGameData exists with the same id
                if let index = decodedHistory.firstIndex(where: { $0.id == id }) {
                    numberOfPlayer = decodedHistory[index].numberOfPlayer
                    maxScore = decodedHistory[index].maxScore
                    names = decodedHistory[index].names
                    nameAndScore = decodedHistory[index].nameAndScore
                    roundScores = decodedHistory[index].roundScores
                    roundNumber = decodedHistory[index].roundNumber
                    winner = decodedHistory[index].winner
                    
                    for name in nameAndScore.keys {
                        if let roundScore = roundScores[name] {
                            nameAndScore[name, default: 0] += roundScore
                        }
                        roundScores[name] = 0
                    }
                }
            }
        }
    }
}

#Preview {
    BeloteView(id: UUID(), numberOfPlayer: 2, maxScore: 1000, names: ["Thomas & Zoé", "Troy & Brigitte"], isNewGame: true)
        .environment(Data())
}

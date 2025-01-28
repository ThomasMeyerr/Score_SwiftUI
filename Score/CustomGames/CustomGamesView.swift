//
//  CustomGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 09/10/2024.
//

import SwiftUI


struct CustomGamesView: View {
    @EnvironmentObject var data: Data
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var countdownTimer = CountdownTimer(seconds: 120)
    
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
    @State private var winner: String
    @State private var countdown: Int
    @State private var isScoreToWin: Bool
    @State private var isAlert: Bool = false
    
    var id: UUID
    
    init(id: UUID?, numberOfPlayer: Int, maxScore: Double, names: [String], countdown: Int, isNewGame: Bool = false, winner: String = "", isScoreToWin: Bool) {
        if id != nil {
            self.id = id!
        } else {
            self.id = UUID()
        }
        self._numberOfPlayer = State(initialValue: numberOfPlayer)
        self._maxScore = State(initialValue: maxScore)
        self._names = State(initialValue: names)
        self._countdown = State(initialValue: countdown)
        self._isNewGame = State(initialValue: isNewGame)
        self._winner = State(initialValue: winner)
        self._isScoreToWin = State(initialValue: isScoreToWin)
    }
    
    var body: some View {
        VStack {
            loadHeader()
            
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
                                        isDisabled = true // Avoid to open keyboard
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
        .navigationTitle(getText(forKey: "customGame", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupInitialScore()
            countdownTimer.resetCountdown(to: countdown)
        }
        .alert(isPresented: Binding(get: { isPartyFinished || isAlert }, set: { _ in })) {
            if isPartyFinished {
                return Alert(
                    title: Text(getText(forKey: "alertWinner", forLanguage: data.languages)) + Text(getLeaderName()!),
                    dismissButton: .default(Text("OK")) {}
                )
            } else {
                return Alert(
                    title: Text(getText(forKey: "timeUp", forLanguage: data.languages)),
                    message: Text(getText(forKey: "timeUpMessage", forLanguage: data.languages)),
                    dismissButton: .default(Text("OK")) {}
                )
            }
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
    
    func loadHeader() -> some View {
        HStack {
            Spacer()

            Group {
                Text(getText(forKey: "round", forLanguage: data.languages)) +
                Text("\(roundNumber)")
            }
            .font(.title2)
            .padding()
            .foregroundStyle(.white)
            .background(.secondary)
            .clipShape(.rect(cornerRadius: 30))
                            
            if countdown != -1 && winner.isEmpty {
                Spacer()
                CountdownView(countdownTimer: countdownTimer, isAlert: $isAlert)
            }
            
            Spacer()
        }
    }
    
    func loadButtons() -> some View {
        HStack {
            Spacer()
            
            if winner.isEmpty {
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
                // Icon for leader
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
        if isScoreToWin {
            nameAndScore.sorted { $0.value > $1.value }
        } else {
            nameAndScore.sorted { $0.value < $1.value }
        }
    }
    
    func getLeaderName() -> String? {
        if isScoreToWin {
            return nameAndScore.max(by: { $0.value < $1.value })?.key
        } else {
            return nameAndScore.min(by: { $0.value < $1.value })?.key
        }
    }
    
    func endRound() {
        for name in nameAndScore.keys {
            if let roundScore = roundScores[name] {
                nameAndScore[name, default: 0] += roundScore
            }
            roundScores[name] = 0
        }
        
        let headScore = nameAndScore.max(by: { $0.value < $1.value })?.value
        if headScore! >= Int(maxScore) {
            countdownTimer.stopCountdown()
            isPartyFinished = true
            winner = getLeaderName() ?? ""
            data.reviewCount += 1
        } else {
            countdownTimer.resetCountdown(to: countdown)
            roundNumber += 1
        }
        saveData()
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
        let data = CustomGameData(id: id, numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores, roundNumber: roundNumber, countdown: countdown, isScoreToWin: isScoreToWin, winner: winner)
        data.lastUpdated = Date()
        
        if let customHistory = UserDefaults.standard.data(forKey: "CustomHistory") {
            if var decodedHistory = try? JSONDecoder().decode(CustomGameHistory.self, from: customHistory) {
                // Check if a same CardGameData exists with the same id
                if let index = decodedHistory.firstIndex(where: { $0.id == data.id }) {
                    decodedHistory[index] = data
                } else {
                    decodedHistory.append(data)
                }
                
                if let encodedHistory = try? JSONEncoder().encode(decodedHistory) {
                    UserDefaults.standard.setValue(encodedHistory, forKey: "CustomHistory")
                }
            }
        } else {
            // Create a new history if none exists
            let newHistory: CustomGameHistory = [data]
            
            if let encodedHistory = try? JSONEncoder().encode(newHistory) {
                UserDefaults.standard.setValue(encodedHistory, forKey: "CustomHistory")
            }
        }
    }
    
    func loadData() {
        if let customHistory = UserDefaults.standard.data(forKey: "CustomHistory") {
            if let decodedHistory = try? JSONDecoder().decode(CustomGameHistory.self, from: customHistory) {
                // Check if a same CardGameData exists with the same id
                if let index = decodedHistory.firstIndex(where: { $0.id == id }) {
                    numberOfPlayer = decodedHistory[index].numberOfPlayer
                    maxScore = decodedHistory[index].maxScore
                    names = decodedHistory[index].names
                    nameAndScore = decodedHistory[index].nameAndScore
                    roundScores = decodedHistory[index].roundScores
                    roundNumber = decodedHistory[index].roundNumber
                    countdown = decodedHistory[index].countdown
                    isScoreToWin = decodedHistory[index].isScoreToWin
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
    CustomGamesView(id: UUID(), numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"], countdown: 120, isNewGame: true, isScoreToWin: true)
        .environmentObject(Data())
}

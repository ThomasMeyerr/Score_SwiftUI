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
    
    @StateObject private var countdownTimer = CountdownTimer(seconds: 120)
    
    @State private var numberOfPlayer: Int
    @State private var maxScore: Double
    @State private var names: [String]
    @State private var countdown: Int
    @State private var nameAndScore: [String: Int] = [:]
    @State private var roundScores: [String: Int] = [:]
    @State private var isPartyFinished = false
    @State private var isCancelSure = false
    @State private var roundNumber = 1
    @State private var nameForCustomKeyboard = ""
    @State private var isShowingKeyboard = false
    @State private var isDisabled = false
    @State private var isAlert = false
    @State private var isNewGame: Bool
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String], countdown: Int, isNewGame: Bool) {
        self._numberOfPlayer = State(initialValue: numberOfPlayer)
        self._maxScore = State(initialValue: maxScore)
        self._names = State(initialValue: names)
        self._countdown = State(initialValue: countdown)
        self._isNewGame = State(initialValue: isNewGame)
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
                                        isDisabled = true
                                    }
                                ), formatter: NumberFormatter())
                                .onTapGesture {
                                    nameForCustomKeyboard = name
                                    isShowingKeyboard = true
                                }
                                .disabled(isDisabled)
                            }
                            .frame(width: 20, alignment: .leading)
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
            countdownTimer.resetCountdown(to: countdown)
        }
        .alert(isPresented: $isPartyFinished) {
            Alert(
                title: Text(getText(forKey: "alertWinner", forLanguage: data.languages)) + Text(getLeaderName()!),
                message: nameAndScore.count > 1 ? Text(getText(forKey: "alertLooser", forLanguage: data.languages)) + Text(getLooserName()!) + Text(" (\(nameAndScore[getLooserName()!] ?? 0))") : nil,
                dismissButton: .default(Text("OK")) {
                    cleanData() 
                }
            )
        }
        .alert(isPresented: $isAlert) {
            Alert(
                title: Text(getText(forKey: "timeUp", forLanguage: data.languages)),
                message: Text(getText(forKey: "timeUpMessage", forLanguage: data.languages)),
                dismissButton: .default(Text("OK")) {}
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
                            
            if countdown != -1 {
                Spacer()
                CountdownView(countdownTimer: countdownTimer, isAlert: $isAlert)
            }
            
            Spacer()
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
        nameAndScore.sorted { $0.value > $1.value }
    }
    
    func getLeaderName() -> String? {
        nameAndScore.max(by: { $0.value < $1.value })?.key
    }
    
    func getLooserName() -> String? {
        nameAndScore.min(by: { $0.value < $1.value })?.key
    }
    
    func endRound() {
        countdownTimer.resetCountdown(to: countdown)
        roundNumber += 1
        saveData()
        
        for name in nameAndScore.keys {
            if let roundScore = roundScores[name] {
                nameAndScore[name, default: 0] += roundScore
            }
            roundScores[name] = 0
        }
        
        let possibleWinner = nameAndScore.max(by: { $0.value < $1.value })?.value
        if possibleWinner! >= Int(maxScore) {
            isPartyFinished = true
            return
        }
    }
    
    func setupInitialScore() {
        if !isNewGame {
            loadData()
        } else {
            UserDefaults.standard.set(false, forKey: "partyCustomOngoing")
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
        let data = CustomGameData(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, nameAndScore: nameAndScore, roundScores: roundScores, roundNumber: roundNumber, countdown: countdown)
        
        if let encodedGameData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedGameData, forKey: "CustomGameData")
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "CustomGameData") {
            if let decodedGameData = try? JSONDecoder().decode(CustomGameData.self, from: data) {
                numberOfPlayer = decodedGameData.numberOfPlayer
                maxScore = decodedGameData.maxScore
                names = decodedGameData.names
                nameAndScore = decodedGameData.nameAndScore
                roundScores = decodedGameData.roundScores
                roundNumber = decodedGameData.roundNumber
                countdown = decodedGameData.countdown
                
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
    CustomGamesView(numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"], countdown: 120, isNewGame: true)
        .environment(Data())
}

//
//  SkyjoView.swift
//  Score
//
//  Created by Thomas Meyer on 18/09/2024.
//

import SwiftUI


struct SkyjoView: View {
    let numberOfPlayer: Int
    let maxScore: Double
    let names: [String]
    
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    @State private var nameAndScore: [String: Int] = [:]
    @State private var roundScores: [String: Int] = [:]
    @State private var isShowingAlert = false
    @Binding var isPartyOngoing: Bool
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String], isPartyOngoing: Binding<Bool>) {
        self.numberOfPlayer = numberOfPlayer
        self.maxScore = maxScore
        self.names = names
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
            Button(getText(forKey: "finishRound", forLanguage: data.languages), action: endRound)
                .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button(getText(forKey: "cancelGame", forLanguage: data.languages), role: .destructive) {
                isPartyOngoing = false
                dismiss()
            }
            .buttonStyle(.borderedProminent)
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
        isPartyOngoing = true
        for name in nameAndScore.keys {
            if let roundScore = roundScores[name] {
                nameAndScore[name, default: 0] += roundScore
            }
            roundScores[name] = 0
        }
        
        let possibleLooser = nameAndScore.max(by: { $0.value < $1.value })?.value
        if possibleLooser! >= 100 {
            isShowingAlert = true
        }
    }
    
    func setupInitialScore() {
        let scores = [Int](repeating: 0, count: numberOfPlayer)
        var combinedDict: [String: Int] = [:]
        for (index, name) in names.enumerated() {
            combinedDict[name] = scores[index]
        }
        
        nameAndScore = combinedDict
        roundScores = combinedDict
    }
}

#Preview {
    SkyjoView(numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"], isPartyOngoing: .constant(true))
        .environment(Data())
}

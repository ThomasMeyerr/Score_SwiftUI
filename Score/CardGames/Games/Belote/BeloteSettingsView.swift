//
//  BeloteSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 20/01/2025.
//

import SwiftUI

struct BeloteSettingsView: View {
    @Environment(Data.self) var data
    
    @State private var numberOfPlayer = 2
    @State private var maxScore: Double = 1000
    @State private var names: [String] = Array(repeating: "", count: 2)
    @State private var isShowingAlert = false
    @State private var history: GameCardHistory = []
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(getText(forKey: "players", forLanguage: data.languages)) {
                        loadPlayersList()
                    }
                    
                    Section(getText(forKey: "maxScore", forLanguage: data.languages)) {
                        HStack {
                            Text(String(Int(maxScore)))
                            Slider(value: $maxScore, in: 200...1800, step: 100)
                        }
                    }
                    
                    Section(getText(forKey: "rules", forLanguage: data.languages)) {
                        RulesText(text: getRules(forKey: "belote", forLanguage: data.languages), language: data.languages)
                    }
                    
                    Section(getText(forKey: "history", forLanguage: data.languages)) {
                        if !history.isEmpty {
                            List {
                                ForEach(history.sorted(by: { $0.lastUpdated > $1.lastUpdated })) { game in
                                    NavigationLink {
                                        BeloteView(id: game.id, numberOfPlayer: game.numberOfPlayer, maxScore: game.maxScore, names: game.names, winner: game.winner)
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(game.names.joined(separator: ", "))
                                                
                                                Text("\(getText(forKey: "lastUpdate", forLanguage: data.languages)): \(formattedDate(date: game.lastUpdated))")
                                                    .font(.caption.italic())
                                                    .foregroundStyle(.secondary.opacity(0.8))
                                            }
                                            
                                            Spacer()
                                            
                                            if game.winner.isEmpty {
                                                Image(systemName: "clock")
                                                    .foregroundStyle(.orange)
                                            } else {
                                                HStack {
                                                    Image(systemName: "crown.fill")
                                                        .foregroundStyle(.yellow)
                                                    
                                                    Text(game.winner)
                                                }
                                                .font(.subheadline)
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: removeRows)
                            }
                        } else {
                            Text(getText(forKey: "gameRecorded", forLanguage: data.languages))
                                .italic()
                                .foregroundStyle(.secondary.opacity(0.8))
                        }
                    }
                }
                
                loadButtons()
            }
            .onAppear {
                resetData()
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    
                    title: Text(getText(forKey: "alertTitle", forLanguage: data.languages)),
                    message: Text(getText(forKey: "alertMessage", forLanguage: data.languages)),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle(getText(forKey: "settings", forLanguage: data.languages) + "Belote")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadPlayersList() -> some View {
        Section {
            Picker(getText(forKey: "numberOfPlayers", forLanguage: data.languages), selection: $numberOfPlayer) {
                ForEach([2, 4], id: \.self) { number in
                    Text("\(number)")
                }
            }
            .onChange(of: numberOfPlayer) { oldValue, newValue in
                if names.count < newValue {
                    names.append(contentsOf: Array(repeating: "", count: newValue - names.count))
                } else if names.count > newValue {
                    names.removeLast(names.count - newValue)
                }
            }
            
            
            if numberOfPlayer > 2 {
                Section("\(getText(forKey: "team", forLanguage: data.languages)) 1") {
                    ForEach(0..<2, id: \.self) { index in
                        TextField(getText(forKey: "pseudo", forLanguage: data.languages), text: Binding(
                            get: { names.indices.contains(index) ? names[index] : "" },
                            set: { newValue in
                                if names.indices.contains(index) {
                                    names[index] = newValue
                                }
                            }
                        ))
                    }
                }
            } else {
                ForEach(0..<2, id: \.self) { index in
                    TextField(getText(forKey: "pseudo", forLanguage: data.languages), text: Binding(
                        get: { names.indices.contains(index) ? names[index] : "" },
                        set: { newValue in
                            if names.indices.contains(index) {
                                names[index] = newValue
                            }
                        }
                    ))
                }
            }
            
            if numberOfPlayer > 2 {
                Section("\(getText(forKey: "team", forLanguage: data.languages)) 2") {
                    ForEach(2..<4, id: \.self) { index in
                        TextField(getText(forKey: "pseudo", forLanguage: data.languages), text: Binding(
                            get: { names.indices.contains(index) ? names[index] : "" },
                            set: { newValue in
                                if names.indices.contains(index) {
                                    names[index] = newValue
                                }
                            }
                        ))
                    }
                }
            }
        }
    }
    
    func loadButtons() -> some View {
        HStack {
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                let teamNames = names.count == 2 ? names : ["\(names[0]) & \(names[1])", "\(names[2]) & \(names[3])"]
                BeloteView(id: nil, numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: teamNames, isNewGame: true)
            }
            .padding()
            .foregroundStyle(.white)
            .background(names.contains(where: { $0.isEmpty }) || names.count != Set(names).count ? .gray : .blue)
            .cornerRadius(10)
            .frame(height: 30)
            .disabled(names.contains(where: { $0.isEmpty }) || names.count != Set(names).count)
            .onTapGesture {
                if (names.count != Set(names).count) && !names.contains(where: { $0.isEmpty }) {
                    isShowingAlert = true
                }
            }
            Spacer()
        }
        .padding()
    }
    
    func loadHistory() {
        if let beloteHistory = UserDefaults.standard.data(forKey: "BeloteHistory"), let decodedHistory = try? JSONDecoder().decode(GameCardHistory.self, from: beloteHistory) {
            history = decodedHistory
        } else {
            history = []
        }
    }
    
    func resetData() {
        loadHistory()
        numberOfPlayer = 2
        maxScore = 1000
        names = Array(repeating: "", count: 2)
    }
    
    func removeRows(at offsets: IndexSet) {
        if let beloteHistory = UserDefaults.standard.data(forKey: "BeloteHistory"), var decodedHistory = try? JSONDecoder().decode(GameCardHistory.self, from: beloteHistory) {
            decodedHistory.remove(atOffsets: offsets)
            
            if let encodedHistory = try? JSONEncoder().encode(decodedHistory) {
                UserDefaults.standard.setValue(encodedHistory, forKey: "BeloteHistory")
            }
        }
    }
}

#Preview {
    BeloteSettingsView()
        .environment(Data())
}

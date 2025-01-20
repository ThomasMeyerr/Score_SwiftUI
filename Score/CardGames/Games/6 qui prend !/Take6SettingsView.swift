//
//  Take6SettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 20/01/2025.
//

import SwiftUI


struct Take6SettingsView: View {
    @Environment(Data.self) var data
    
    @State private var numberOfPlayer = 2
    @State private var maxScore: Double = 66
    @State private var names: [String] = Array(repeating: "", count: 2)
    @State private var isShowingAlert = false
    @State private var isPartyOngoing = UserDefaults.standard.bool(forKey: "partyTake6Ongoing")
    
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
                            Slider(value: $maxScore, in: 33...90, step: 3)
                        }
                    }
                    
                    Section(getText(forKey: "rules", forLanguage: data.languages)) {
                        RulesText(text: getRules(forKey: "take6", forLanguage: data.languages), language: data.languages)
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
        .navigationTitle(getText(forKey: "settings", forLanguage: data.languages) + "6 Qui Prend !")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadPlayersList() -> some View {
        Section {
            Picker(getText(forKey: "numberOfPlayers", forLanguage: data.languages), selection: $numberOfPlayer) {
                ForEach(2..<9, id: \.self) {
                    Text(String($0))
                }
            }
            .onChange(of: numberOfPlayer) { oldValue, newValue in
                if names.count < newValue {
                    names.append(contentsOf: Array(repeating: "", count: newValue - names.count))
                } else if names.count > newValue {
                    names.removeLast(names.count - newValue)
                }
            }
            
            ForEach(0..<numberOfPlayer, id: \.self) { index in
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
    
    func loadButtons() -> some View {
        HStack {
            if isPartyOngoing {
                Spacer()
                NavigationLink(getText(forKey: "continue", forLanguage: data.languages)) {
                    SkyjoView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, isNewGame: false)
                }
                .padding()
                .foregroundStyle(.white)
                .background(.green)
                .cornerRadius(10)
                .frame(height: 30)
            }
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                SkyjoView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, isNewGame: true)
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
    
    func resetData() {
        isPartyOngoing = UserDefaults.standard.bool(forKey: "partyTake6Ongoing")
        numberOfPlayer = 2
        maxScore = 66
        names = Array(repeating: "", count: 2)
    }
}

#Preview {
    Take6SettingsView()
        .environment(Data())
}

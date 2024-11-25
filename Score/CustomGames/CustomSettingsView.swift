//
//  CustomSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct CustomSettingsView: View {
    @Environment(Data.self) var data
    
    @State private var numberOfPlayer = 1
    @State private var maxScore: Double = 100
    @State private var names: [String] = Array(repeating: "", count: 1)
    @State private var isShowingAlert = false
    @State private var isPartyOngoing = UserDefaults.standard.bool(forKey: "partyCustomOngoing")
    @State private var isToggleTimer = false
    @State private var countdown: Double = 120
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(getText(forKey: "players", forLanguage: data.languages)) {
                        loadPlayersList()
                    }
                    
                    Section(getText(forKey: "maxScore", forLanguage: data.languages)) {
//                        Toggle
                        HStack {
                            Text(String(Int(maxScore)))
                            Slider(value: $maxScore, in: 50...500, step: 10)
                        }
                    }
                    
                    Section(getText(forKey: "countdown", forLanguage: data.languages)) {
                        Toggle(isOn: $isToggleTimer) {
                            Text(getText(forKey: "countdownEnable", forLanguage: data.languages))
                        }
                        
                        if isToggleTimer {
                            HStack {
                                Text(String(Int(countdown)))
                                Slider(value: $countdown, in: 10...300, step: 10)
                            }
                        }
                    }
                    
                    Section(getText(forKey: "rules", forLanguage: data.languages)) {
                        RulesText(text: getRules(forKey: "customGames", forLanguage: data.languages), language: data.languages)
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
        .navigationTitle(getText(forKey: "customSettings", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadPlayersList() -> some View {
        Section {
            Picker(getText(forKey: "numberOfPlayers", forLanguage: data.languages), selection: $numberOfPlayer) {
                ForEach(1..<13, id: \.self) {
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
                    CustomGamesView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, countdown: Int(countdown), isNewGame: false)
                }
                .padding()
                .foregroundStyle(.white)
                .background(.green)
                .cornerRadius(10)
                .frame(height: 30)
            }
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                if isToggleTimer {
                    CustomGamesView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, countdown: Int(countdown), isNewGame: true)
                } else {
                    CustomGamesView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names, countdown: -1, isNewGame: true)
                }
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
        isPartyOngoing = UserDefaults.standard.bool(forKey: "partyCustomOngoing")
        numberOfPlayer = 1
        maxScore = 100
        names = Array(repeating: "", count: 1)
    }
}

#Preview {
    CustomSettingsView()
        .environment(Data())
}

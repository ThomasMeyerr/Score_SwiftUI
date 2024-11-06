//
//  UnoSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI


struct UnoSettingsView: View {
    @Environment(Data.self) var data
    
    @State private var numberOfPlayer = 2
    @State private var maxScore: Double = 500
    @State private var names: [String] = Array(repeating: "", count: 2)
    @State private var isShowingAlert = false
    @State private var isPartyOngoing = UserDefaults.standard.bool(forKey: "partyUnoOngoing")
    
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
                            Slider(value: $maxScore, in: 400...600, step: 10)
                        }
                    }
                    
                    Section(getText(forKey: "rules", forLanguage: data.languages)) {
                        RulesText(text: getRules(forKey: "uno", forLanguage: data.languages), language: data.languages)
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
        .navigationTitle(getText(forKey: "settings", forLanguage: data.languages) + "Uno")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadPlayersList() -> some View {
        Section {
            Picker(getText(forKey: "numberOfPlayers", forLanguage: data.languages), selection: $numberOfPlayer) {
                ForEach(2..<11, id: \.self) {
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
                    SkyjoView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names)
                }
                .padding()
                .foregroundStyle(.white)
                .background(.green)
                .cornerRadius(10)
            }
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                SkyjoView(numberOfPlayer: numberOfPlayer, maxScore: maxScore, names: names)
            }
            .padding()
            .foregroundStyle(.white)
            .background(names.contains(where: { $0.isEmpty }) || names.count != Set(names).count ? .gray : .blue)
            .cornerRadius(10)
            .disabled(names.contains(where: { $0.isEmpty }) || names.count != Set(names).count)
            .onTapGesture {
                if (names.count != Set(names).count) && !names.contains(where: { $0.isEmpty }) {
                    isShowingAlert = true
                    return
                }
                UserDefaults.standard.set(false, forKey: "partyUnoOngoing")
            }
            Spacer()
        }
        .padding()
    }
    
    func resetData() {
        isPartyOngoing = UserDefaults.standard.bool(forKey: "partyUnoOngoing")
        numberOfPlayer = 2
        maxScore = 500
        names = Array(repeating: "", count: 2)
    }
}

#Preview {
    UnoSettingsView()
        .environment(Data())
}

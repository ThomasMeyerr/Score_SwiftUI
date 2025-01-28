//
//  YamSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//


import SwiftUI


struct YamSettingsView: View {
    @EnvironmentObject var data: Data
    
    @State private var numberOfPlayer = 2
    @State private var names: [String] = Array(repeating: "", count: 1)
    @State private var isShowingAlert = false
    @State private var isPartyOngoing = UserDefaults.standard.bool(forKey: "partyYamOngoing")
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(getText(forKey: "players", forLanguage: data.languages)) {
                        loadPlayersList()
                    }
                    
                    Section(getText(forKey: "rules", forLanguage: data.languages)) {
                        RulesText(text: getRules(forKey: "yam", forLanguage: data.languages), language: data.languages)
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
        .navigationTitle(getText(forKey: "settings", forLanguage: data.languages) + getText(forKey: "yamTitle", forLanguage: data.languages))
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
                    YamView(numberOfPlayer: numberOfPlayer, names: names, language: data.languages, isNewGame: false)
                }
                .padding()
                .foregroundStyle(.white)
                .background(.green)
                .cornerRadius(10)
                .frame(height: 30)
            }
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                YamView(numberOfPlayer: numberOfPlayer, names: names, language: data.languages, isNewGame: true)
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
        isPartyOngoing = UserDefaults.standard.bool(forKey: "partyYamOngoing")
        numberOfPlayer = 1
        names = Array(repeating: "", count: 1)
    }
}

#Preview {
    YamSettingsView()
        .environmentObject(Data())
}

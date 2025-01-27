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
                        let test = true
                        List {
                            if test {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Thomas, Zoé")
                                        Text("Last update: 02-07-2025 00h04")
                                            .italic()
                                            .foregroundStyle(.secondary.opacity(0.8))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "clock")
                                        .foregroundStyle(.orange)
                                }
                            } else {
                                Text(getText(forKey: "gameRecorded", forLanguage: data.languages))
                                    .italic()
                                    .foregroundStyle(.secondary.opacity(0.8))
                            }
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
    
    func resetData() {
        numberOfPlayer = 2
        maxScore = 1000
        names = Array(repeating: "", count: 2)
    }
    
    func removeRows(at offsets: IndexSet) {
//        ??.remove(atOffsets: offsets)
    }
}

#Preview {
    BeloteSettingsView()
        .environment(Data())
}

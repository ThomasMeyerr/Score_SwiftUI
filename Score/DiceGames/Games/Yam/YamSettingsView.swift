//
//  YamSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//


import SwiftUI


struct YamSettingsView: View {
    @EnvironmentObject var data: Data
    
    @State private var numberOfPlayer = 1
    @State private var names: [String] = Array(repeating: "", count: 1)
    @State private var isShowingAlert = false
    @State private var history: YamGameHistory = []

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
                    
                    Section(getText(forKey: "history", forLanguage: data.languages)) {
                        if !history.isEmpty {
                            List {
                                ForEach(history) { game in
                                    NavigationLink {
                                        YamView(id: game.id, numberOfPlayer: game.numberOfPlayer, names: game.names, language: data.languages)
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(game.names.joined(separator: ", "))
                                                
                                                Text("\(getText(forKey: "lastUpdate", forLanguage: data.languages)): \(formattedDate(date: game.lastUpdated))")
                                                    .font(.caption.italic())
                                                    .foregroundStyle(.secondary.opacity(0.8))
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
                            names[index] = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    }
                ))
            }
        }
    }
    
    func loadButtons() -> some View {
        HStack {
            Spacer()
            NavigationLink(getText(forKey: "launch", forLanguage: data.languages)) {
                YamView(id: nil, numberOfPlayer: numberOfPlayer, names: names, language: data.languages, isNewGame: true)
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
        if let yamHistory = UserDefaults.standard.data(forKey: "YamHistory"), let decodedHistory = try? JSONDecoder().decode(YamGameHistory.self, from: yamHistory) {
            history = decodedHistory.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        } else {
            history = []
        }
    }
    
    func resetData() {
        loadHistory()
        numberOfPlayer = 1
        names = Array(repeating: "", count: 1)
    }
    
    func removeRows(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
            
        if let encodedHistory = try? JSONEncoder().encode(history) {
            UserDefaults.standard.setValue(encodedHistory, forKey: "YamHistory")
        }
    }
}

#Preview {
    YamSettingsView()
        .environmentObject(Data())
}

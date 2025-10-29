//
//  SeaSaltPaperSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/01/2025.
//

import SwiftUI

struct SeaSaltPaperSettingsView: View {
    @EnvironmentObject var data: Data

    @State private var numberOfPlayer = 2
    @State private var maxScore: Double = 40
    @State private var names: [String] = Array(repeating: "", count: 2)
    @State private var isShowingAlert = false
    @State private var history: GameCardHistory = []

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(
                        getText(forKey: "players", forLanguage: data.languages)
                    ) {
                        loadPlayersList()
                    }

                    Section(
                        getText(forKey: "maxScore", forLanguage: data.languages)
                    ) {
                        HStack {
                            Text(String(Int(maxScore)))
                            Slider(value: $maxScore, in: 30...41, step: 5)
                        }
                    }

                    Section(
                        getText(forKey: "rules", forLanguage: data.languages)
                    ) {
                        RulesText(
                            text: getRules(
                                forKey: "seaSaltPaper",
                                forLanguage: data.languages
                            ),
                            language: data.languages
                        )
                    }

                    Section(
                        getText(forKey: "history", forLanguage: data.languages)
                    ) {
                        if !history.isEmpty {
                            List {
                                ForEach(history) { game in
                                    NavigationLink {
                                        SeaSaltPaperView(
                                            id: game.id,
                                            numberOfPlayer: game.numberOfPlayer,
                                            maxScore: game.maxScore,
                                            names: game.names,
                                            winner: game.winner
                                        )
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(
                                                    game.names.joined(
                                                        separator: ", "
                                                    )
                                                )

                                                Text(
                                                    "\(getText(forKey: "lastUpdate", forLanguage: data.languages)): \(formattedDate(date: game.lastUpdated))"
                                                )
                                                .font(.caption.italic())
                                                .foregroundStyle(
                                                    .secondary.opacity(0.8)
                                                )
                                            }

                                            Spacer()

                                            if game.winner.isEmpty {
                                                Image(systemName: "clock")
                                                    .foregroundStyle(.orange)
                                            } else {
                                                HStack {
                                                    VStack {
                                                        Image(
                                                            systemName:
                                                                "crown.fill"
                                                        )
                                                        .foregroundStyle(
                                                            .yellow
                                                        )

                                                        Text(game.winner)
                                                    }
                                                }
                                                .font(.subheadline)
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: removeRows)
                            }
                        } else {
                            Text(
                                getText(
                                    forKey: "gameRecorded",
                                    forLanguage: data.languages
                                )
                            )
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
                    title: Text(
                        getText(
                            forKey: "alertTitle",
                            forLanguage: data.languages
                        )
                    ),
                    message: Text(
                        getText(
                            forKey: "alertMessage",
                            forLanguage: data.languages
                        )
                    ),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle(
            getText(forKey: "settings", forLanguage: data.languages)
                + "Sea Salt & Paper"
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    func loadPlayersList() -> some View {
        Section {
            Picker(
                getText(forKey: "numberOfPlayers", forLanguage: data.languages),
                selection: $numberOfPlayer
            ) {
                ForEach(2..<5, id: \.self) {
                    Text(String($0))
                }
            }
            .onChange(of: numberOfPlayer) { oldValue, newValue in
                if names.count < newValue {
                    names.append(
                        contentsOf: Array(
                            repeating: "",
                            count: newValue - names.count
                        )
                    )
                } else if names.count > newValue {
                    names.removeLast(names.count - newValue)
                }
                switch numberOfPlayer {
                case 3: maxScore = 35
                case 4: maxScore = 30
                default: maxScore = 40
                }
            }

            ForEach(0..<numberOfPlayer, id: \.self) { index in
                TextField(
                    getText(forKey: "pseudo", forLanguage: data.languages),
                    text: Binding(
                        get: {
                            names.indices.contains(index) ? names[index] : ""
                        },
                        set: { newValue in
                            if names.indices.contains(index) {
                                names[index] = newValue.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                )
                            }
                        }
                    )
                )
            }
        }
    }

    func loadButtons() -> some View {
        HStack {
            Spacer()
            NavigationLink(
                getText(forKey: "launch", forLanguage: data.languages)
            ) {
                SeaSaltPaperView(
                    id: nil,
                    numberOfPlayer: numberOfPlayer,
                    maxScore: maxScore,
                    names: names,
                    isNewGame: true
                )
            }
            .padding()
            .foregroundStyle(.white)
            .background(
                names.contains(where: { $0.isEmpty })
                    || names.count != Set(names).count ? .gray : .blue
            )
            .cornerRadius(10)
            .frame(height: 30)
            .disabled(
                names.contains(where: { $0.isEmpty })
                    || names.count != Set(names).count
            )
            .onTapGesture {
                if (names.count != Set(names).count)
                    && !names.contains(where: { $0.isEmpty })
                {
                    isShowingAlert = true
                }
            }
            Spacer()
        }
        .padding()
    }

    func loadHistory() {
        if let seaSaltPaperHistory = UserDefaults.standard.data(
            forKey: "SeaSaltPaperHistory"
        ),
            let decodedHistory = try? JSONDecoder().decode(
                GameCardHistory.self,
                from: seaSaltPaperHistory
            )
        {
            history = decodedHistory.sorted(by: {
                $0.lastUpdated > $1.lastUpdated
            })
        } else {
            history = []
        }
    }

    func resetData() {
        loadHistory()
        numberOfPlayer = 2
        maxScore = 40
        names = Array(repeating: "", count: 2)
    }

    func removeRows(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)

        if let encodedHistory = try? JSONEncoder().encode(history) {
            UserDefaults.standard.setValue(
                encodedHistory,
                forKey: "SeaSaltPaperHistory"
            )
        }
    }
}

#Preview {
    SeaSaltPaperSettingsView()
        .environmentObject(Data())
}

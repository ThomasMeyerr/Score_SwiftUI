//
//  CustomSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct CustomSettingsView: View {
    @EnvironmentObject var data: Data

    @State private var numberOfPlayer = 1
    @State private var maxScore: Double = 100
    @State private var names: [String] = Array(repeating: "", count: 1)
    @State private var isShowingAlert = false
    @State private var history: CustomGameHistory = []
    @State private var isToggleTimer = false
    @State private var isScoreToWin = true
    @State private var countdown: Double = 120

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
                        Toggle(isOn: $isScoreToWin) {
                            Text(
                                isScoreToWin
                                    ? getText(
                                        forKey: "scoreToWin",
                                        forLanguage: data.languages
                                    )
                                    : getText(
                                        forKey: "scoreToLoose",
                                        forLanguage: data.languages
                                    )
                            )
                        }
                        .tint(.green)

                        HStack {
                            Text(String(Int(maxScore)))
                            Slider(value: $maxScore, in: 50...500, step: 10)
                        }
                    }

                    Section(
                        getText(
                            forKey: "countdown",
                            forLanguage: data.languages
                        )
                    ) {
                        Toggle(isOn: $isToggleTimer) {
                            Text(
                                getText(
                                    forKey: "countdownEnable",
                                    forLanguage: data.languages
                                )
                            )
                        }
                        .tint(.blue)

                        if isToggleTimer {
                            HStack {
                                Text(String(Int(countdown)))
                                Slider(
                                    value: $countdown,
                                    in: 10...300,
                                    step: 10
                                )
                            }
                        }
                    }

                    Section(
                        getText(forKey: "rules", forLanguage: data.languages)
                    ) {
                        RulesText(
                            text: getRules(
                                forKey: "customGames",
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
                                        CustomGamesView(
                                            id: game.id,
                                            numberOfPlayer: game.numberOfPlayer,
                                            maxScore: game.maxScore,
                                            names: game.names,
                                            countdown: Int(game.countdown),
                                            winner: game.winner,
                                            isScoreToWin: game.isScoreToWin
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
            getText(forKey: "customSettings", forLanguage: data.languages)
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    func loadPlayersList() -> some View {
        Section {
            Picker(
                getText(forKey: "numberOfPlayers", forLanguage: data.languages),
                selection: $numberOfPlayer
            ) {
                ForEach(1..<13, id: \.self) {
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
                if isToggleTimer {
                    CustomGamesView(
                        id: nil,
                        numberOfPlayer: numberOfPlayer,
                        maxScore: maxScore,
                        names: names,
                        countdown: Int(countdown),
                        isNewGame: true,
                        isScoreToWin: isScoreToWin
                    )
                } else {
                    CustomGamesView(
                        id: nil,
                        numberOfPlayer: numberOfPlayer,
                        maxScore: maxScore,
                        names: names,
                        countdown: -1,
                        isNewGame: true,
                        isScoreToWin: isScoreToWin
                    )
                }
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
        if let customHistory = UserDefaults.standard.data(
            forKey: "CustomHistory"
        ),
            let decodedHistory = try? JSONDecoder().decode(
                CustomGameHistory.self,
                from: customHistory
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
        numberOfPlayer = 1
        maxScore = 100
        names = Array(repeating: "", count: 1)
    }

    func removeRows(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)

        if let encodedHistory = try? JSONEncoder().encode(history) {
            UserDefaults.standard.setValue(
                encodedHistory,
                forKey: "CustomHistory"
            )
        }
    }
}

#Preview {
    CustomSettingsView()
        .environmentObject(Data())
}

//
//  SkyjoSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI


struct SkyjoSettingsView: View {
    @Environment(Data.self) var data
    @State private var numberOfPlayer = 2
    @State private var maxScore: Double = 100
    @State private var names: [String] = Array(repeating: "", count: 2)

    
    var body: some View {
        VStack {
            Form {
                Section(getText(forKey: "Parameter", forLanguage: data.languages)) {
                    Picker(getText(forKey: "NumberOfPlayers", forLanguage: data.languages), selection: $numberOfPlayer) {
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
                        TextField(getText(forKey: "Pseudo", forLanguage: data.languages), text: $names[index])
                    }
                }
                
                Section("Max Score") {
                    HStack {
                        Text(String(Int(maxScore)))
                        Slider(value: $maxScore, in: 80...120, step: 1)
                    }
                }
                
                Section(getText(forKey: "Rules", forLanguage: data.languages)) {
                    RulesText(text: getRules(forKey: "Skyjo", forLanguage: data.languages), language: data.languages)
                }
            }
            
            Button("Launch") {}
                .buttonStyle(.borderedProminent)
                .disabled(names.contains(where: { $0.isEmpty }))
        }
        .navigationTitle("Skyjo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SkyjoSettingsView()
        .environment(Data())
}

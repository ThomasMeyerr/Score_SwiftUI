//
//  Utils.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI


@ViewBuilder
func getGameView(for game: String) -> some View {
    switch game {
    case "Skyjo":
        SkyjoSettingsView()
    case "Uno":
        UnoSettingsView()
    case "Yam":
        YamSettingsView()
    default:
        Text("View not available")
    }
}


func getText(forKey key: String, forLanguage language: Languages) -> String {
    return texts[key]?[language] ?? (language == .en ? "Data unavailable" : "Données indisponibles")
}


func getRules(forKey key: String, forLanguage language: Languages) -> String {
    return rules[key]?[language] ?? (language == .en ? "Data unavailable" : "Données indisponibles")
}


struct RulesText: View {
    let text: String
    let language: Languages
    let lineLimit = 3
    
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.subheadline)
                .lineLimit(expanded ? nil : lineLimit)
                .padding(.bottom, 2)
            
            if !expanded && textIsTruncated() {
                Button {
                    expanded.toggle()
                } label: {
                    Text(getText(forKey: "showMore", forLanguage: language))
                        .font(.footnote)
                }
            }
            
            if expanded && textIsTruncated() {
                Button {
                    expanded.toggle()
                } label: {
                    Text(getText(forKey: "showLess", forLanguage: language))
                        .font(.footnote)
                }
            }
        }
    }
    
    func textIsTruncated() -> Bool {
        text.count > lineLimit * 30
    }
}


struct CustomKeyboard: View {
    @Environment(\.dismiss) var dismiss
    @Binding var input: Int
    @State private var inputString = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 15) {
                VStack {
                    Text("Score :")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    
                    Text(inputString)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                }
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(1..<10, id: \.self) { number in
                        Button(action: {
                            inputString.append("\(number)")
                        }) {
                            Text("\(number)")
                                .font(.largeTitle)
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                HStack(spacing: 40) {
                    Button(action: {
                        if inputString.isEmpty {
                            inputString.append("-")
                        }
                    }) {
                        Text("-")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                    }
                    
                    Button(action: {
                        inputString.append("0")
                    }) {
                        Text("0")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                    }
                    
                    Button(action: {
                        if !inputString.isEmpty {
                            inputString.removeLast()
                        }
                    }) {
                        Image(systemName: "delete.left.fill")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                    }
                }
                
                Button(action: {
                    input = Int(inputString) ?? 0
                    inputString = ""
                    dismiss()
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}


class CardGameData: Codable {
    let numberOfPlayer: Int
    let maxScore: Double
    let names: [String]
    let nameAndScore: [String: Int]
    let roundScores: [String: Int]
    let roundNumber: Int
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String], nameAndScore: [String : Int], roundScores: [String : Int], roundNumber: Int) {
        self.numberOfPlayer = numberOfPlayer
        self.maxScore = maxScore
        self.names = names
        self.nameAndScore = nameAndScore
        self.roundScores = roundScores
        self.roundNumber = roundNumber
    }
}


struct CountdownView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

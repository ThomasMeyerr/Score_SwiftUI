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
                    Text(getText(forKey: "ShowMore", forLanguage: language))
                        .font(.footnote)
                }
            }
        }
    }
    
    func textIsTruncated() -> Bool {
        text.count > lineLimit * 30
    }
}

//
//  UnoSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI


struct UnoSettingsView: View {
    @Environment(Data.self) var data

    var body: some View {
        Form {
            Section(getText(forKey: "rules", forLanguage: data.languages)) {
                RulesText(text: getRules(forKey: "uno", forLanguage: data.languages), language: data.languages)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius:40)
                .fill(Color.secondary.opacity(0.1))
        )
        .navigationTitle(getText(forKey: "settings", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UnoSettingsView()
        .environment(Data())
}

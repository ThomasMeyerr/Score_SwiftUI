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
            Section(getText(forKey: "Rules", forLanguage: data.languages)) {
                RulesText(text: getRules(forKey: "Uno", forLanguage: data.languages), language: data.languages)
            }
        }
        .navigationTitle(getText(forKey: "UnoSettingsTitle", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UnoSettingsView()
        .environment(Data())
}

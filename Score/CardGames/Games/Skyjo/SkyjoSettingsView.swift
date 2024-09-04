//
//  SkyjoSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI

struct SkyjoSettingsView: View {
    @Environment(Data.self) var data

    var body: some View {
        Form {
            Section(getText(forKey: "Rules", forLanguage: data.languages)) {
                RulesText(text: getRules(forKey: "Skyjo", forLanguage: data.languages), language: data.languages)
            }
        }
        .navigationTitle(getText(forKey: "SkyjoSettingsTitle", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SkyjoSettingsView()
        .environment(Data())
}

//
//  YamSettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 04/09/2024.
//

import SwiftUI


struct YamSettingsView: View {
    @Environment(Data.self) var data

    var body: some View {
        Form {
            Section(getText(forKey: "Rules", forLanguage: data.languages)) {
                RulesText(text: getRules(forKey: "Yam", forLanguage: data.languages), language: data.languages)
            }
        }
        .navigationTitle(getText(forKey: "YamSettingsTitle", forLanguage: data.languages))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    YamSettingsView()
        .environment(Data())
}

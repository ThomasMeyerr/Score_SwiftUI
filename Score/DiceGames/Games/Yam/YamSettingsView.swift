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
            Section(getText(forKey: "rules", forLanguage: data.languages)) {
                RulesText(text: getRules(forKey: "yam", forLanguage: data.languages), language: data.languages)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius:40)
                .fill(Color.secondary.opacity(0.1))
        )
        .navigationTitle("Yam")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    YamSettingsView()
        .environment(Data())
}

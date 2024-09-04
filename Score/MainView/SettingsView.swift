//
//  SettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Data.self) var data
    @State private var languagesText = LanguagesText()

    var body: some View {
        Form {
            Text(languagesText.getText(forKey: "settingsPicker", forLanguage: data.languages))
        }
    }
}

#Preview {
    SettingsView()
        .environment(Data())
}

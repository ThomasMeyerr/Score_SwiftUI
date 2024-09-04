//
//  SettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct SettingsView: View {
    let languages: [String: Languages] = ["English": .en, "Français": .fr]

    @Environment(Data.self) var data
    @State private var languagesText = LanguagesText()
    @State private var languageSelected = "English"
    @State private var isAlert = false

    var body: some View {
        Form {
            Section {
                Button {} label: {
                    HStack {
                        Text(languagesText.getText(forKey: "settingsButtonAdds", forLanguage: data.languages))
                        Spacer()
                        Text(languagesText.getText(forKey: "settingsButtonAddsPrice", forLanguage: data.languages))
                    }
                }
            }
            
            Section {
                Picker(languagesText.getText(forKey: "settingsPicker", forLanguage: data.languages), selection: $languageSelected) {
                    ForEach(Array(languages.keys), id: \.self) { key in
                        Text(key)
                            .tag(key)
                    }
                }
                .onChange(of: languageSelected) { oldValue, newValue in
                    if let selectedLanguage = languages[newValue] {
                        data.languages = selectedLanguage
                    }
                }
            }
            
            Section {
                Button(languagesText.getText(forKey: "settingsReset", forLanguage: data.languages), role: .destructive) {
                    isAlert = true
                }
            }
        }
        .alert(languagesText.getText(forKey: "settingsAlert", forLanguage: data.languages), isPresented: $isAlert) {
            Button("Ok", action: resetData)
            Button(languagesText.getText(forKey: "settingsButtonCancel", forLanguage: data.languages), role: .cancel) {}
        }
    }
    
    func resetData() {
        data.languages = .en
        languageSelected = "English"
    }
}

#Preview {
    SettingsView()
        .environment(Data())
}

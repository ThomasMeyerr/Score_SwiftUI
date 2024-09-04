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
            Section("Rules") {
                Text(getRules(forKey: "Uno", forLanguage: data.languages))
                    .font(.subheadline)
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

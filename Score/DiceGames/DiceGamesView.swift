//
//  DiceGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct DiceGamesView: View {
    @Environment(Data.self) var data
    @State private var languagesText = LanguagesText()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 250/255, green: 246/255, blue: 232/255).ignoresSafeArea()

                ScrollView {
                    ForEach(Data.diceGames, id: \.self) { game in
                        NavigationLink {
                            Text(String(game))
                        } label: {
                            Image( .example)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 275)
                                .clipShape(.rect(cornerRadius: 30))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.black, lineWidth: 2)
                                )
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(languagesText.getText(forKey: "DiceGamesTitle", forLanguage: data.languages))
    }
}

#Preview {
    DiceGamesView()
        .environment(Data())
}

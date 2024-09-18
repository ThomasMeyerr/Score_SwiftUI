//
//  DiceGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI


struct DiceGamesView: View {
    @Environment(Data.self) var data

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(diceGames, id: \.self) { game in
                    NavigationLink {
                        getGameView(for: game)
                    } label: {
                        Image(game)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 270, height: 150)
                            .clipShape(.rect(cornerRadius: 30))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.secondary, lineWidth: 2)
                            )
                            .padding()
                    }
                }
            }
            .padding()
        }
        .navigationTitle(getText(forKey: "diceGamesTitle", forLanguage: data.languages))
    }
}

#Preview {
    DiceGamesView()
        .environment(Data())
}

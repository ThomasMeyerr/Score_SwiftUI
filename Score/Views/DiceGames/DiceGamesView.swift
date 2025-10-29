//
//  DiceGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct DiceGamesView: View {
    @EnvironmentObject var data: Data

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
                                    .stroke(.white, lineWidth: 5)
                            )
                            .padding()
                    }
                }
                .padding()
            }
            .padding()
            .background(
                Image("diceBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
        .navigationTitle(
            getText(forKey: "diceGamesTitle", forLanguage: data.languages)
        )
    }
}

#Preview {
    DiceGamesView()
        .environmentObject(Data())
}

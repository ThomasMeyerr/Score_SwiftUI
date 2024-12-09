//
//  CardGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI


struct CardGamesView: View {
    @Environment(Data.self) var data

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(cardGames, id: \.self) { game in
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
                Image("cardBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
        .navigationTitle(getText(forKey: "cardGamesTitle", forLanguage: data.languages))
    }
}

#Preview {
    CardGamesView()
        .environment(Data())
}

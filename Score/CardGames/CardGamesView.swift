//
//  CardGamesView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI

struct CardGamesView: View {
    @Environment(Data.self) var data
    @State private var languagesText = LanguagesText()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                ScrollView {
                    ForEach(0...10, id: \.self) { _ in
                        NavigationLink {
                            Text("omg")
                        } label: {
                            Image( .example)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 275)
                                .clipShape(.rect(cornerRadius: 30))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.white, lineWidth: 1)
                                )
                                .padding()
                        }
                    }
                }
            }
        }
        .navigationTitle(languagesText.getText(forKey: "CardGamesTitle", forLanguage: data.languages))
    }
}

#Preview {
    CardGamesView()
        .environment(Data())
}

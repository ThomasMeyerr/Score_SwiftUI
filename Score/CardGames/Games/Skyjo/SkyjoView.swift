//
//  SkyjoView.swift
//  Score
//
//  Created by Thomas Meyer on 18/09/2024.
//

import SwiftUI


struct SkyjoView: View {
    let numberOfPlayer: Int
    let maxScore: Double
    let names: [String]
    
    @Environment(Data.self) var data
    @Environment(\.dismiss) var dismiss
    @State private var nameAndScore: [String: Int]
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String]) {
        self.numberOfPlayer = numberOfPlayer
        self.maxScore = maxScore
        self.names = names
        
        let scores = [Int](repeating: 0, count: self.numberOfPlayer)
        var combinedDict: [String: Int] = [:]
        for (index, name) in names.enumerated() {
            combinedDict[name] = scores[index]
        }
        
        self._nameAndScore = State(initialValue: combinedDict)
    }
    
    var body: some View {
        ForEach(Array(nameAndScore.keys), id: \.self) { name in
            Text(name) +
            Text(String(nameAndScore[name]!))
        }
    }
}

#Preview {
    SkyjoView(numberOfPlayer: 2, maxScore: 100, names: ["Thomas", "Zoé"])
        .environment(Data())
}

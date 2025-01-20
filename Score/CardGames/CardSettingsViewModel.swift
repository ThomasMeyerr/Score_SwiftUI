//
//  CardSettingsViewModel.swift
//  Score
//
//  Created by Thomas Meyer on 20/01/2025.
//

import SwiftUI


@MainActor class CardSettingsViewModel: ObservableObject {
    @Published var numberOfPlayer: Int
    @Published var maxScore: Double
    @Published var names: [String]
    @Published var isShowingAlert = false
    @Published var isPartyOngoing: Bool
    
    init(numberOfPlayer: Int, maxScore: Double, names: [String], isShowingAlert: Bool = false, isPartyOngoing: Bool) {
        self.numberOfPlayer = numberOfPlayer
        self.maxScore = maxScore
        self.names = names
        self.isShowingAlert = isShowingAlert
        self.isPartyOngoing = isPartyOngoing
    }
}

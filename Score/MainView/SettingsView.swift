//
//  SettingsView.swift
//  Score
//
//  Created by Thomas Meyer on 01/09/2024.
//

import SwiftUI
import StoreKit


@MainActor class SettingsViewModel: ObservableObject {
    @Published var languageSelected = "English"
    @Published var isAlert = false
    
    let languages: [String: Languages] = ["English": .en, "Français": .fr, "Español": .es, "Português": .pt, "Italiano": .it, "Deutsch": .de]
    let flags: [String: String] = ["English": " 🇬🇧", "Français": " 🇫🇷", "Español": " 🇪🇸", "Português": " 🇵🇹", "Italiano": " 🇮🇹", "Deutsch": " 🇩🇪"]
}


struct SettingsView: View {
    @EnvironmentObject var data: Data
    @Environment(\.requestReview) var requestReview
    @StateObject var vm = SettingsViewModel()

    var body: some View {
        Form {
            Section {
//                Button {} label: {
//                    HStack {
//                        Text(getText(forKey: "settingsButtonAdds", forLanguage: data.languages))
//                        Spacer()
//                        Text(getText(forKey: "settingsButtonAddsPrice", forLanguage: data.languages))
//                    }
//                }
                
//                Button {} label: {
//                    Text(getText(forKey: "settingsButtonDailyAdds", forLanguage: data.languages))
//                }
                
                Button {
                    requestReview()
                } label: {
                    Text(getText(forKey: "settingsReview", forLanguage: data.languages))
                }
                .tint(.green)
            }
            
            Section {
                Picker(getText(forKey: "settingsPicker", forLanguage: data.languages), selection: $vm.languageSelected) {
                    ForEach(Array(vm.languages.keys), id: \.self) { key in
                        Text(key + (vm.flags[key] ?? ""))
                            .tag(key)
                    }
                }
                .onChange(of: vm.languageSelected) { oldValue, newValue in
                    if let selectedLanguage = vm.languages[newValue] {
                        data.languages = selectedLanguage
                    }
                }
            }
            
            Section {
                Button(getText(forKey: "settingsReset", forLanguage: data.languages), role: .destructive) {
                    vm.isAlert = true
                }
            }
        }
        .alert(getText(forKey: "settingsAlert", forLanguage: data.languages), isPresented: $vm.isAlert) {
            Button("Ok", action: resetData)
            Button(getText(forKey: "settingsButtonCancel", forLanguage: data.languages), role: .cancel) {}
        }
        .onAppear {
            switch data.languages {
            case .en: vm.languageSelected = "English"
            case .es: vm.languageSelected = "Español"
            case .pt: vm.languageSelected = "Português"
            case .it: vm.languageSelected = "Italiano"
            case .de: vm.languageSelected = "Deutsch"
            default: vm.languageSelected = "Français"
            }
        }
    }
    
    func resetData() {
        data.languages = .en
        vm.languageSelected = "English"
    }
}

#Preview {
    SettingsView()
        .environmentObject(Data())
}

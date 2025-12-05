//
//  UserSettings.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI

@Observable
class UserSettings {
    // Currency
    var currencySymbol: String {
        didSet { UserDefaults.standard.set(currencySymbol, forKey: "userCurrency") }
    }
    
    // Theme Color (Hex)
    var themeColorHex: String {
        didSet { UserDefaults.standard.set(themeColorHex, forKey: "userThemeColor") }
    }
    
    // Language code (e.g. "zh-Hans", "en") - Actual switching requires restart/reload, 
    // but here we track preference.
    var language: String {
        didSet { 
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        self.currencySymbol = UserDefaults.standard.string(forKey: "userCurrency") ?? "¥"
        self.themeColorHex = UserDefaults.standard.string(forKey: "userThemeColor") ?? "#7B4DFF" // Default Purple
        
        let langs = UserDefaults.standard.array(forKey: "AppleLanguages") as? [String]
        self.language = langs?.first ?? "zh-Hans"
    }
    
    var themeColor: Color {
        Color(hex: themeColorHex)
    }
}

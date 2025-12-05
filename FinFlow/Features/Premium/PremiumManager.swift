//
//  PremiumManager.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI

@Observable
class PremiumManager {
    var isPremium: Bool = false
    
    init() {
        // Load status from UserDefaults for simulation
        self.isPremium = UserDefaults.standard.bool(forKey: "isPremiumUser")
    }
    
    func purchase(productID: String) async {
        // SIMULATION: Simulate network delay and success
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Grant premium
        await MainActor.run {
            self.isPremium = true
            UserDefaults.standard.set(true, forKey: "isPremiumUser")
        }
    }
    
    func restorePurchases() async {
        // SIMULATION
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            self.isPremium = true // Ideally check actual receipt, but for now just restore
            UserDefaults.standard.set(true, forKey: "isPremiumUser")
        }
    }
    
    // Dev only: Reset status
    func resetPremium() {
        self.isPremium = false
        UserDefaults.standard.set(false, forKey: "isPremiumUser")
    }
}

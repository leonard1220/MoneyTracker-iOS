//
//  BalanceSnapshotService.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import Foundation
import SwiftData

struct BalanceSnapshotService {
    static func takeSnapshot(modelContext: ModelContext) {
        // 1. Check if we already have a snapshot for today
        let today = Calendar.current.startOfDay(for: Date())
        let descriptor = FetchDescriptor<DailyBalanceSnapshot>(
            predicate: #Predicate { $0.date == today }
        )
        
        if let existing = try? modelContext.fetch(descriptor).first {
            // Already took snapshot today, update it?
            updateSnapshot(existing, context: modelContext)
            return
        }
        
        // 2. Create new snapshot
        let snapshot = DailyBalanceSnapshot(totalAssets: 0, totalLiabilities: 0)
        snapshot.date = today
        modelContext.insert(snapshot)
        updateSnapshot(snapshot, context: modelContext)
    }
    
    private static func updateSnapshot(_ snapshot: DailyBalanceSnapshot, context: ModelContext) {
        // Calculate total assets/liabilities from Accounts
        let accountDescriptor = FetchDescriptor<Account>()
        if let accounts = try? context.fetch(accountDescriptor) {
            var assets: Decimal = 0
            var liabilities: Decimal = 0
            
            for account in accounts {
                if account.type == .credit || account.type == .loan { // Assuming these are liabilities if balance is positive (owed)? 
                    // Usually credit card balance is positive representing debt in some apps, 
                    // or negative representing debt. 
                    // Let's assume positive balance on Credit Card = Owing money.
                    liabilities += account.balance
                } else if account.type == .debt {
                    liabilities += account.balance
                } else {
                    assets += account.balance
                }
            }
            
            snapshot.totalAssets = assets
            snapshot.totalLiabilities = liabilities
            try? context.save()
        }
    }
}

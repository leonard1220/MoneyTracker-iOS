//
//  BudgetService.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import Foundation

struct BudgetProgress {
    let budget: Budget
    let spent: Decimal
    let percent: Double
    let remaining: Decimal
    
    var status: BudgetStatus {
        if percent >= 1.0 { return .exceeded }
        if percent >= 0.8 { return .warning }
        return .normal
    }
}

enum BudgetStatus {
    case normal
    case warning
    case exceeded
}

class BudgetService {
    static func calculateProgress(for budget: Budget, transactions: [Transaction]) -> BudgetProgress {
        
        let txs = transactions.filter { tx in
            // Must be expense
            guard tx.type == .expense else { return false }
            // Date range check
            guard tx.date >= budget.startDate && tx.date <= budget.endDate else { return false }
            
            // Category check
            if let budgetCat = budget.category {
                return tx.category?.id == budgetCat.id
            }
            return true
        }
        
        let spent = txs.reduce(0) { $0 + $1.amount }
        let amount = budget.amount > 0 ? budget.amount : 1
        
        // Use native Decimal division first
        let ratio = spent / amount
        
        // Convert to double safely
        let percent = (ratio as NSDecimalNumber).doubleValue
        
        let remaining = budget.amount - spent
        
        return BudgetProgress(budget: budget, spent: spent, percent: percent.isNaN ? 0 : percent, remaining: remaining)
    }
}

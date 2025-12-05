//
//  MonthlyReportService.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

struct CategoryStat: Identifiable {
    let id = UUID()
    let categoryName: String
    let amount: Decimal
    let colorHex: String?
    let iconName: String?
    
    var percentage: Double = 0.0
}

struct MonthlySummary {
    var totalIncome: Decimal = 0
    var totalExpense: Decimal = 0
    var netIncome: Decimal { totalIncome - totalExpense }
    var expenseByCategory: [CategoryStat] = []
    var incomeByCategory: [CategoryStat] = []
}

class MonthlyReportService {
    static func generateReport(for date: Date, transactions: [Transaction]) -> MonthlySummary {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        // Filter transactions for the month
        let monthTransactions = transactions.filter {
            let tComponents = calendar.dateComponents([.year, .month], from: $0.date)
            return tComponents.year == components.year && tComponents.month == components.month
        }
        
        var summary = MonthlySummary()
        
        var expenseMap: [String: (Decimal, String?, String?)] = [:] // Name -> (Amount, Color, Icon)
        var incomeMap: [String: (Decimal, String?, String?)] = [:]
        
        for t in monthTransactions {
            let amount = t.amount
            let catName = t.category?.name ?? "Uncategorized"
            let catColor = t.category?.color
            let catIcon = t.category?.iconName
            
            if t.type == .expense {
                summary.totalExpense += amount
                
                let current = expenseMap[catName] ?? (0, catColor, catIcon)
                expenseMap[catName] = (current.0 + amount, current.1, current.2)
                
            } else if t.type == .income {
                summary.totalIncome += amount
                
                let current = incomeMap[catName] ?? (0, catColor, catIcon)
                incomeMap[catName] = (current.0 + amount, current.1, current.2)
            }
        }
        
        // Convert Map to Array
        summary.expenseByCategory = expenseMap.map { (key, value) in
            CategoryStat(categoryName: key, amount: value.0, colorHex: value.1, iconName: value.2)
        }.sorted { $0.amount > $1.amount }
        
        summary.incomeByCategory = incomeMap.map { (key, value) in
            CategoryStat(categoryName: key, amount: value.0, colorHex: value.1, iconName: value.2)
        }.sorted { $0.amount > $1.amount }
        
        return summary
    }
}

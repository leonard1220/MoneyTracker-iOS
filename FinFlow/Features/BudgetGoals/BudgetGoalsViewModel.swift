//
//  BudgetGoalsViewModel.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class BudgetGoalsViewModel {
    var budgetProgresses: [BudgetProgress] = []
    
    func loadBudgets(budgets: [Budget], transactions: [Transaction]) {
        self.budgetProgresses = budgets.map { budget in
            BudgetService.calculateProgress(for: budget, transactions: transactions)
        }.sorted { $0.percent > $1.percent } // Sort by highest usage
    }
    
    func deleteBudget(_ budget: Budget, context: ModelContext) {
        context.delete(budget)
    }
}

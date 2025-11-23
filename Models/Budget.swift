//
//  Budget.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 预算数据模型
@Model
final class Budget {
    var id: UUID
    var category: Category?
    var month: Int
    var year: Int
    var amount: Decimal
    
    init(
        id: UUID = UUID(),
        category: Category? = nil,
        month: Int,
        year: Int,
        amount: Decimal
    ) {
        self.id = id
        self.category = category
        self.month = month
        self.year = year
        self.amount = amount
    }
}


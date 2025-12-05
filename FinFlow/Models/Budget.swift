//
//  Budget.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

enum BudgetPeriod: String, Codable {
    case monthly
    case yearly
    case oneTime
}

/// 预算数据模型
@Model
final class Budget {
    var id: UUID
    var category: Category?
    var amount: Decimal
    var period: BudgetPeriod
    var startDate: Date
    var endDate: Date
    var createdAt: Date
    var updatedAt: Date
    
    // 临时存储计算的已用金额（非持久化，实际需通过 Transaction 查询计算）
    // 或者可以作为缓存字段
    @Attribute(.ephemeral) var spentAmount: Decimal = 0
    
    init(
        id: UUID = UUID(),
        category: Category? = nil,
        amount: Decimal,
        period: BudgetPeriod = .monthly,
        startDate: Date,
        endDate: Date,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.category = category
        self.amount = amount
        self.period = period
        self.startDate = startDate
        self.endDate = endDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

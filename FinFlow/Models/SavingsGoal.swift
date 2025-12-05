//
//  SavingsGoal.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 储蓄目标数据模型
@Model
final class SavingsGoal {
    var id: UUID
    var name: String
    var targetAmount: Decimal
    var currentAmount: Decimal
    var targetDate: Date?
    var account: Account?
    var createdAt: Date
    var updatedAt: Date
    
    // 计算属性: 进度 (0.0 - 1.0)
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return NSDecimalNumber(decimal: currentAmount).doubleValue / NSDecimalNumber(decimal: targetAmount).doubleValue
    }
    
    // 计算属性: 剩余金额
    var remainingAmount: Decimal {
        return max(0, targetAmount - currentAmount)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        targetAmount: Decimal,
        currentAmount: Decimal = 0,
        targetDate: Date? = nil,
        account: Account? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.targetDate = targetDate
        self.account = account
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

//
//  Goal.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 储蓄目标数据模型
@Model
final class Goal {
    var id: UUID
    var name: String
    var targetAmount: Decimal
    var currentAmount: Decimal
    var deadline: Date?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        targetAmount: Decimal,
        currentAmount: Decimal = 0,
        deadline: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.createdAt = createdAt
    }
}


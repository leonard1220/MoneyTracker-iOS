//
//  Transaction.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 交易数据模型
@Model
final class Transaction {
    var id: UUID
    var amount: Decimal
    var type: TransactionType
    var date: Date
    var note: String?
    var mood: String?
    var fromAccount: Account?
    var toAccount: Account?
    var category: Category?
    var createdAt: Date
    var updatedAt: Date
    
    // 转账目标账户（仅用于转账类型）
    var targetAccount: Account?
    
    init(
        id: UUID = UUID(),
        amount: Decimal,
        type: TransactionType,
        date: Date = Date(),
        note: String? = nil,
        mood: String? = nil,
        fromAccount: Account? = nil,
        toAccount: Account? = nil,
        targetAccount: Account? = nil,
        category: Category? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.date = date
        self.note = note
        self.mood = mood
        self.fromAccount = fromAccount
        self.toAccount = toAccount
        self.targetAccount = targetAccount
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


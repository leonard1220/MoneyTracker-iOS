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
    var remark: String?
    var mood: String?
    var fromAccount: Account?
    var toAccount: Account?
    var category: Category?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        amount: Decimal,
        type: TransactionType,
        date: Date = Date(),
        remark: String? = nil,
        mood: String? = nil,
        fromAccount: Account? = nil,
        toAccount: Account? = nil,
        category: Category? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.date = date
        self.remark = remark
        self.mood = mood
        self.fromAccount = fromAccount
        self.toAccount = toAccount
        self.category = category
        self.createdAt = createdAt
    }
}


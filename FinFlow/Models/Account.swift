//
//  Account.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 账户数据模型
@Model
final class Account {
    var id: UUID
    var name: String
    var type: AccountType
    var balance: Decimal
    var currency: String
    var icon: String
    var color: String
    var creditLimit: Decimal?
    var sortOrder: Int
    var createdAt: Date
    var updatedAt: Date
    
    // 关联交易（从账户转出）
    @Relationship(deleteRule: .nullify, inverse: \Transaction.fromAccount)
    var fromTransactions: [Transaction]?
    
    // 关联交易（转入账户）
    @Relationship(deleteRule: .nullify, inverse: \Transaction.toAccount)
    var toTransactions: [Transaction]?
    
    init(
        id: UUID = UUID(),
        name: String,
        type: AccountType,
        balance: Decimal = 0,
        currency: String = "CNY",
        icon: String = "creditcard",
        color: String = "#007AFF",
        creditLimit: Decimal? = nil,
        sortOrder: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.balance = balance
        self.currency = currency
        self.icon = icon
        self.color = color
        self.creditLimit = creditLimit
        self.sortOrder = sortOrder
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}


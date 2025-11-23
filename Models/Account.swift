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
    var creditLimit: Decimal?
    var createdAt: Date
    
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
        creditLimit: Decimal? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.balance = balance
        self.creditLimit = creditLimit
        self.createdAt = createdAt
    }
}


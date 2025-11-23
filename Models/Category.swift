//
//  Category.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 分类数据模型
@Model
final class Category {
    var id: UUID
    var name: String
    var type: CategoryType
    var iconName: String?
    var colorHex: String?
    var createdAt: Date
    
    // 关联交易
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]?
    
    init(
        id: UUID = UUID(),
        name: String,
        type: CategoryType,
        iconName: String? = nil,
        colorHex: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.iconName = iconName
        self.colorHex = colorHex
        self.createdAt = createdAt
    }
}


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
    var color: String?
    var isSystem: Bool
    var isDefault: Bool
    var sortOrder: Int
    var createdAt: Date
    
    // 关联交易
    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]?
    
    init(
        id: UUID = UUID(),
        name: String,
        type: CategoryType,
        iconName: String? = nil,
        color: String? = nil,
        isSystem: Bool = false,
        isDefault: Bool = false,
        sortOrder: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.iconName = iconName
        self.color = color
        self.isSystem = isSystem
        self.isDefault = isDefault
        self.sortOrder = sortOrder
        self.createdAt = createdAt
    }
}


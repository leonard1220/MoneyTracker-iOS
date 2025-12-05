//
//  CategorySeeder.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import Foundation
import SwiftData

struct CategorySeeder {
    static func seedDefaultCategories(modelContext: ModelContext) {
        // Check if categories already exist
        let descriptor = FetchDescriptor<Category>()
        if let count = try? modelContext.fetchCount(descriptor), count > 0 {
            return
        }
        
        let categories: [Category] = [
            // Expenses
            Category(name: "餐饮", type: .expense, iconName: "fork.knife", color: "#FF5722", isSystem: true, sortOrder: 1),
            Category(name: "交通", type: .expense, iconName: "bus", color: "#2196F3", isSystem: true, sortOrder: 2),
            Category(name: "购物", type: .expense, iconName: "cart", color: "#E91E63", isSystem: true, sortOrder: 3),
            Category(name: "娱乐", type: .expense, iconName: "gamecontroller", color: "#9C27B0", isSystem: true, sortOrder: 4),
            Category(name: "居住", type: .expense, iconName: "house", color: "#795548", isSystem: true, sortOrder: 5),
            Category(name: "医疗", type: .expense, iconName: "cross.case", color: "#F44336", isSystem: true, sortOrder: 6),
            Category(name: "教育", type: .expense, iconName: "book", color: "#FFC107", isSystem: true, sortOrder: 7),
            Category(name: "其他", type: .expense, iconName: "ellipsis.circle", color: "#9E9E9E", isSystem: true, sortOrder: 99),
            
            // Income
            Category(name: "工资", type: .income, iconName: "dollarsign.circle", color: "#4CAF50", isSystem: true, sortOrder: 1),
            Category(name: "奖金", type: .income, iconName: "gift", color: "#FF9800", isSystem: true, sortOrder: 2),
            Category(name: "投资", type: .income, iconName: "chart.bar", color: "#673AB7", isSystem: true, sortOrder: 3),
            Category(name: "兼职", type: .income, iconName: "briefcase", color: "#3F51B5", isSystem: true, sortOrder: 4)
        ]
        
        for category in categories {
            modelContext.insert(category)
        }
        
        try? modelContext.save()
    }
}

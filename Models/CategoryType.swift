//
//  CategoryType.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation

/// 分类类型枚举
enum CategoryType: String, Codable, Hashable, CaseIterable {
    case income = "income"
    case expense = "expense"
    case transfer = "transfer"
    
    var displayName: String {
        switch self {
        case .income: return "收入"
        case .expense: return "支出"
        case .transfer: return "转账"
        }
    }
}


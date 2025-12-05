//
//  AccountType.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation

/// 账户类型枚举
enum AccountType: String, Codable, Hashable, CaseIterable {
    case cash = "cash"
    case bank = "bank"
    case ewallet = "ewallet"
    case credit = "credit"
    case loan = "loan"
    
    var displayName: String {
        switch self {
        case .cash: return "现金"
        case .bank: return "银行"
        case .ewallet: return "电子钱包"
        case .credit: return "信用卡"
        case .loan: return "贷款"
        }
    }
}


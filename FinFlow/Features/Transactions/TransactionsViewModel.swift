//
//  TransactionsViewModel.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 交易视图模型，管理交易列表的状态和逻辑
@Observable
class TransactionsViewModel {
    // 表单状态
    var amount: String = ""
    var selectedType: TransactionType = .expense
    var selectedFromAccount: Account?
    var selectedToAccount: Account? // 收入账户
    var selectedTargetAccount: Account? // 转账目标账户
    var selectedCategory: Category?
    var selectedDate: Date = Date()
    var note: String = ""
    var selectedMood: String?
    
    // 可用的心情选项
    let moodOptions: [String?] = [nil, "happy", "stressed", "impulse", "need"]
    let moodDisplayNames: [String?: String] = [
        nil: "无",
        "happy": "开心",
        "stressed": "压力",
        "impulse": "冲动",
        "need": "需要"
    ]
    
    /// 验证表单是否有效
    var isFormValid: Bool {
        // 金额必须有效且大于 0
        guard let amountValue = Decimal(string: amount), amountValue > 0 else {
            return false
        }
        
        // 根据交易类型验证账户选择
        switch selectedType {
        case .expense:
            return selectedFromAccount != nil
        case .income:
            return selectedToAccount != nil
        case .transfer:
            return selectedFromAccount != nil && selectedTargetAccount != nil && selectedFromAccount != selectedTargetAccount
        }
    }
    
    /// 重置表单
    func resetForm() {
        amount = ""
        selectedType = .expense
        selectedFromAccount = nil
        selectedToAccount = nil
        selectedTargetAccount = nil
        selectedCategory = nil
        selectedDate = Date()
        note = ""
        selectedMood = nil
    }
}

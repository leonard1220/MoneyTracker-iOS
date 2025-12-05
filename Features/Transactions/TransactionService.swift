//
//  TransactionService.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 交易服务类，处理交易相关的业务逻辑
class TransactionService {
    
    /// 保存交易并更新账户余额
    /// - Parameters:
    ///   - transaction: 要保存的交易对象
    ///   - context: SwiftData 模型上下文
    /// - Returns: 是否保存成功
    @MainActor
    static func saveTransaction(_ transaction: Transaction, context: ModelContext) -> Bool {
        // 根据交易类型更新账户余额
        switch transaction.type {
        case .expense:
            // 支出：从 fromAccount 扣除金额
            if let fromAccount = transaction.fromAccount {
                fromAccount.balance -= transaction.amount
            }
            
        case .income:
            // 收入：向 toAccount 增加金额
            if let toAccount = transaction.toAccount {
                toAccount.balance += transaction.amount
            }
            
        case .transfer:
            // 转账：从 fromAccount 扣除，向 targetAccount 增加
            if let fromAccount = transaction.fromAccount {
                fromAccount.balance -= transaction.amount
            }
            if let targetAccount = transaction.targetAccount {
                targetAccount.balance += transaction.amount
            }
        }
        
        // 保存交易到数据库
        context.insert(transaction)
        
        // 保存上下文
        do {
            try context.save()
            return true
        } catch {
            print("保存交易失败: \(error)")
            return false
        }
    }
    
    /// 删除交易并恢复账户余额
    /// - Parameters:
    ///   - transaction: 要删除的交易对象
    ///   - context: SwiftData 模型上下文
    /// - Returns: 是否删除成功
    @MainActor
    static func deleteTransaction(_ transaction: Transaction, context: ModelContext) -> Bool {
        // 恢复账户余额（反向操作）
        switch transaction.type {
        case .expense:
            // 支出：恢复 fromAccount 余额
            if let fromAccount = transaction.fromAccount {
                fromAccount.balance += transaction.amount
            }
            
        case .income:
            // 收入：恢复 toAccount 余额
            if let toAccount = transaction.toAccount {
                toAccount.balance -= transaction.amount
            }
            
        case .transfer:
            // 转账：恢复两个账户余额
            if let fromAccount = transaction.fromAccount {
                fromAccount.balance += transaction.amount
            }
            if let targetAccount = transaction.targetAccount {
                targetAccount.balance -= transaction.amount
            }
        }
        
        // 删除交易
        context.delete(transaction)
        
        // 保存上下文
        do {
            try context.save()
            return true
        } catch {
            print("删除交易失败: \(error)")
            return false
        }
    }
}


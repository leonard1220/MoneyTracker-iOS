//
//  Double+Extensions.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation

extension Double {
    // 在这里添加金额相关的扩展方法
    // 例如：格式化、计算等
    
    /// 格式化为货币字符串
    func formattedCurrency(currency: String = "CNY") -> String {
        // TODO: 实现货币格式化
        return String(format: "%.2f", self)
    }
}


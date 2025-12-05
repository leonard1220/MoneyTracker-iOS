//
//  Decimal+Extensions.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation

extension Decimal {
    /// 从字符串创建 Decimal
    /// - Parameter string: 数字字符串
    /// - Returns: Decimal 值，如果转换失败返回 nil
    init?(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        guard let number = formatter.number(from: string) else {
            return nil
        }
        
        self = number.decimalValue
    }
    
    /// 格式化为货币字符串
    func formattedCurrency(code: String = "CNY") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.locale = Locale.current
        // 如果货币是 CNY，可能需要强制某些显示习惯，这里使用系统默认
        
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}


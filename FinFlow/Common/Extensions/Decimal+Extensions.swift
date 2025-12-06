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
    func formattedCurrency(code: String = "") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        // 优先使用传入的 code
        if !code.isEmpty {
            formatter.currencyCode = code
        } else if let userSymbol = UserDefaults.standard.string(forKey: "userCurrency") {
            // 使用用户设置的符号
            formatter.currencySymbol = userSymbol
        } else {
            // 默认兜底
            formatter.currencyCode = "CNY"
        }
        
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}


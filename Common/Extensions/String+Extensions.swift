//
//  String+Extensions.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation

extension String {
    /// 转换为 Decimal
    func toDecimal() -> Decimal? {
        return Decimal(string: self)
    }
    
    /// 是否包含非空白字符
    var isNotBlank: Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


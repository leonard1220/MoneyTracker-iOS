//
//  Date+Extensions.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import Foundation

extension Date {
    func formattedDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

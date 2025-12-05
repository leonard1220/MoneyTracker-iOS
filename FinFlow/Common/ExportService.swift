//
//  ExportService.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

class ExportService {
    static func generateCSV(from transactions: [Transaction]) -> String {
        // BOM for Excel compatibility with UTF-8
        var csvString = "\u{FEFF}日期,类型,金额,分类,账户,备注,心情\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        for tx in transactions {
            let date = dateFormatter.string(from: tx.date)
            let typeName: String
            switch tx.type {
            case .expense: typeName = "支出"
            case .income: typeName = "收入"
            case .transfer: typeName = "转账"
            }
            
            let amount = tx.amount.description
            let category = tx.category?.name ?? "未分类"

            var accountName = ""
            if let from = tx.fromAccount?.name {
                accountName = from
            }
            if let to = tx.toAccount?.name {
                if !accountName.isEmpty {
                    accountName += " -> \(to)"
                } else {
                    accountName = to
                }
            }
            
            // Escape special characters for CSV
            func escape(_ str: String) -> String {
                if str.contains(",") || str.contains("\"") || str.contains("\n") {
                    let escaped = str.replacingOccurrences(of: "\"", with: "\"\"")
                    return "\"\(escaped)\""
                }
                return str
            }
            
            let note = escape(tx.note ?? "")
            let mood = tx.mood ?? ""
            
            let row = "\(date),\(typeName),\(amount),\(escape(category)),\(escape(accountName)),\(note),\(mood)\n"
            csvString.append(row)
        }
        
        return csvString
    }
    
    static func createCSVFile(from transactions: [Transaction]) -> URL? {
        let csvString = generateCSV(from: transactions)
        let fileName = "FinFlow_Export_\(Date().formatted(date: .numeric, time: .omitted).replacingOccurrences(of: "/", with: "-")).csv"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            
            do {
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                return fileURL
            } catch {
                print("Failed to write CSV: \(error)")
                return nil
            }
        }
        return nil
    }
}

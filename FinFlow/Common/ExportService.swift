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
        var csvString = "Date,Type,Amount,Category,Account,Note\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        for tx in transactions {
            let date = dateFormatter.string(from: tx.date)
            let type = tx.type.rawValue
            let amount = tx.amount.description
            let category = tx.category?.name ?? "Uncategorized"
            let account = tx.account?.name ?? "Unknown"
            let note = tx.note?.replacingOccurrences(of: ",", with: " ") ?? "" // Simple escape
            
            let row = "\(date),\(type),\(amount),\(category),\(account),\(note)\n"
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

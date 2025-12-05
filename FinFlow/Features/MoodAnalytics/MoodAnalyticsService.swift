//
//  MoodAnalyticsService.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import Foundation

struct MoodStat: Identifiable {
    let id = UUID()
    let mood: String
    let amount: Decimal
    let count: Int
    let colorHex: String
}

class MoodAnalyticsService {
    static func analyze(transactions: [Transaction]) -> [MoodStat] {
        // Group expenses by mood
        let expenses = transactions.filter { $0.type == .expense }
        var dict: [String: (Decimal, Int)] = [:]
        
        for tx in expenses {
            let mood = tx.mood ?? "unknown" // Default if no mood selected
            let current = dict[mood] ?? (0, 0)
            dict[mood] = (current.0 + tx.amount, current.1 + 1)
        }
        
        // Convert to MoodStats
        return dict.map { key, value in
            MoodStat(
                mood: key,
                amount: value.0,
                count: value.1,
                colorHex: colorForMood(key)
            )
        }.sorted { $0.amount > $1.amount }
    }
    
    static func colorForMood(_ mood: String) -> String {
        switch mood {
        case "happy": return "#FFC107" // Amber
        case "sad": return "#2196F3"   // Blue
        case "neutral": return "#9E9E9E" // Grey
        case "angry": return "#F44336" // Red
        case "excited": return "#9C27B0" // Purple
        case "unknown": return "#607D8B" // Blue Grey
        default: return "#607D8B"
        }
    }
    
    static func moodDisplayName(_ mood: String) -> String {
        switch mood {
        case "happy": return "开心 (Happy)"
        case "sad": return "难过 (Sad)"
        case "neutral": return "平静 (Neutral)"
        case "angry": return "生气 (Angry)"
        case "excited": return "兴奋 (Excited)"
        case "unknown": return "未记录"
        default: return mood
        }
    }
    
    static func moodIcon(_ mood: String) -> String {
        switch mood {
        case "happy": return "face.smiling"
        case "sad": return "cloud.rain"
        case "neutral": return "face.dashed"
        case "angry": return "flame"
        case "excited": return "star.fill"
        case "unknown": return "questionmark.circle"
        default: return "circle"
        }
    }
}

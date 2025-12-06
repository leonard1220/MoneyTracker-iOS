//
//  AppTheme.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 应用主题配置
struct AppTheme {
    // MARK: - Colors
    
    // MARK: - Colors
    
    // 品牌色 (Brand Colors)
    static let primary = Color(hex: "#7B4DFF")    // Electric Purple
    static let secondary = Color(hex: "#5AC8FA")  // Secondary Blue
    static let primaryLight = Color(hex: "#9D7BFF") 
    static let accent = Color(hex: "#00E0FF")     // Cyan Neon
    
    // 暗黑背景体系 (Dark Surface System)
    static let background = Color(hex: "#0C0D10")        // Deepest Black
    static let secondaryBackground = Color(hex: "#14161C") // Surface
    static let tertiaryBackground = Color(hex: "#1C1E26")  // Elevated Surface
    static let groupedBackground = Color(hex: "#000000")
    
    // 功能色 (Functional Colors)
    static let income = Color(hex: "#4CD964")     // Neon Green
    static let expense = Color(hex: "#FF3B30")    // Neon Red
    static let warning = Color(hex: "#FFD60A")
    
    // 文本色 (Text)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let textTertiary = Color.white.opacity(0.4)
    
    // MARK: - Gradients
    
    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "#7B4DFF"), Color(hex: "#4B00D1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color(hex: "#252836"), Color(hex: "#14161C")],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - Layout
    
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let buttonHeight: CGFloat = 56
}


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
    
    // 主色调
    static let primary = Color(hex: "#007AFF")
    static let secondary = Color(hex: "#5AC8FA")
    static let accent = Color(hex: "#5856D6")
    
    // 背景色
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let groupedBackground = Color(uiColor: .systemGroupedBackground)
    
    // 文本色
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    
    // 功能色
    static let income = Color(hex: "#34C759")  // Green
    static let expense = Color(hex: "#FF3B30") // Red
    static let warning = Color(hex: "#FFCC00") // Yellow
    
    // MARK: - Layout
    
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 50
    
    // MARK: - Fonts
    
    // 使用系统动态字体，这里仅作预留，SwiftUI View 中直接使用 .font(.headline) 等更佳
    // 如果需要自定义字体，可以在这里静态定义
}


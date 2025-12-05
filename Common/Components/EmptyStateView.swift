//
//  EmptyStateView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 空状态视图组件
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: AppTheme.padding) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(AppTheme.secondary)
            
            Text(title)
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.padding)
    }
}

#Preview {
    EmptyStateView(
        icon: "tray",
        title: "暂无数据",
        message: "开始添加您的第一笔交易吧"
    )
}


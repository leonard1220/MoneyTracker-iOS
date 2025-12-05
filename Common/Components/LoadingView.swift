//
//  LoadingView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 加载视图组件
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .tint(AppTheme.primary)
    }
}

#Preview {
    LoadingView()
}


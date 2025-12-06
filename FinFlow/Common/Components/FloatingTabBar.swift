//
//  FloatingTabBar.swift
//  FinFlow
//
//  Created on 2025-12-06.
//

import SwiftUI

/// 自定义悬浮 Tab Bar
struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    
    // Tab 配置
    struct TabItem {
        let icon: String
        let title: String
        let tag: Int
    }
    
    let tabs = [
        TabItem(icon: "house.fill", title: "首页", tag: 0),
        TabItem(icon: "list.bullet", title: "明细", tag: 1),
        TabItem(icon: "chart.line.uptrend.xyaxis", title: "计划", tag: 2),
        TabItem(icon: "chart.bar.fill", title: "报表", tag: 3),
        TabItem(icon: "gearshape.fill", title: "设置", tag: 4)
    ]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.tag) { tab in
                Spacer()
                
                Button {
                    // 触感反馈
                    if selectedTab != tab.tag {
                        HapticManager.shared.lightImpact()
                    }
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.tag
                    }
                } label: {
                    VStack(spacing: 4) {
                        // 图标容器
                        ZStack {
                            if selectedTab == tab.tag {
                                // 选中态光晕
                                Circle()
                                    .fill(AppTheme.primary.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .blur(radius: 5)
                                    .scaleEffect(1.0)
                            }
                            
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: selectedTab == tab.tag ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab.tag ? AppTheme.primary : Color.white.opacity(0.5))
                                .scaleEffect(selectedTab == tab.tag ? 1.1 : 1.0)
                        }
                        
                        // 标题（仅选中或全部显示，这里选择简洁风格：仅图标变化，不显示文字，或者显示极小文字）
                        // 为了极简，我们这里只显示图标，或者可以添加一个极小的点指示器
                        if selectedTab == tab.tag {
                           Circle()
                                .fill(AppTheme.primary)
                                .frame(width: 4, height: 4)
                                .offset(y: -2)
                        }
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
                Spacer()
            }
        }
        .frame(height: 64)
        .background(
            ZStack {
                // 玻璃背景
                Capsule()
                    .fill(.ultraThinMaterial)
                
                // 描边
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.1), .white.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
        )
        // 外部阴影
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 24)
        .padding(.bottom, 8) // 离底部的距离
    }
}

// 简单的按压缩放效果
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            Spacer()
            FloatingTabBar(selectedTab: Binding.constant(0))
        }
    }
}

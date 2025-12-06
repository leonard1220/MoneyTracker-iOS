//
//  PremiumAssetCard.swift
//  FinFlow
//
//  Created on 2025-12-06.
//

import SwiftUI

/// 高级资产卡片 - 采用流体渐变和玻璃质感设计
struct PremiumAssetCard: View {
    let totalBalance: Decimal
    let income: Decimal
    let expense: Decimal
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 1. 动态流体背景 (Fluid Mesh Gradient Background)
            GeometryReader { proxy in
                ZStack {
                    // 深紫色基底
                    Color(hex: "#2A1B5E")
                    
                    // 流动的光斑 - 使用 BlendMode 混合
                    Circle()
                        .fill(Color(hex: "#7B4DFF")) // Brand Purple
                        .frame(width: 200, height: 200)
                        .blur(radius: 60)
                        .offset(x: isAnimating ? 80 : -80, y: isAnimating ? -40 : 40)
                    
                    Circle()
                        .fill(Color(hex: "#00E0FF")) // Neon Cyan
                        .frame(width: 150, height: 150)
                        .blur(radius: 50)
                        .offset(x: isAnimating ? -60 : 60, y: isAnimating ? 40 : -30)
                        .opacity(0.8)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            }
            .animation(.easeInOut(duration: 5).repeatForever(autoreverses: true), value: isAnimating)
            
            // 2. 玻璃磨砂层 (Glass Overlay)
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(.ultraThinMaterial)
                .opacity(0.3)
            
            // 3. 细微边框光泽
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .white.opacity(0.1), .white.opacity(0.05), .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
            
            // 4. 内容层
            VStack(spacing: 24) {
                // 上部分：总资产
                VStack(spacing: 8) {
                    HStack {
                        Text("当前总资产")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        // 装饰性图标
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(AppTheme.accent)
                    }
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("RM")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.bottom, 4)
                        
                        // 数字滚动效果 (可用 contentTransition 如果是 iOS 17+)
                        Text(totalBalance.formattedCurrency(code: ""))
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText(value: Double(truncating: totalBalance as NSNumber)))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // 分割线
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.2), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                
                // 下部分：收入与支出
                HStack(spacing: 0) {
                    // 收入
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(AppTheme.income)
                                .frame(width: 8, height: 8)
                                .shadow(color: AppTheme.income.opacity(0.5), radius: 4)
                            
                            Text("本月收入")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Text(income.formattedCurrency())
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // 支出
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 4) {
                            Text("本月支出")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            
                            Circle()
                                .fill(AppTheme.expense)
                                .frame(width: 8, height: 8)
                                .shadow(color: AppTheme.expense.opacity(0.5), radius: 4)
                        }
                        
                        Text(expense.formattedCurrency())
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(24)
        }
        .frame(height: 220)
        // 卡片自身阴影
        .shadow(color: AppTheme.primary.opacity(0.3), radius: 20, x: 0, y: 10)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    ZStack {
        Color(hex: "#0C0D10").ignoresSafeArea() // Preview Dark Background
        
        PremiumAssetCard(
            totalBalance: 12580.50,
            income: 5200.00,
            expense: 1280.00
        )
        .padding()
    }
}

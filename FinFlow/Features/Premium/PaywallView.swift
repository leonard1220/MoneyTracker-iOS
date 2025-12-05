//
//  PaywallView.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI

struct PaywallView: View {
    @Environment(PremiumManager.self) private var premiumManager
    @Environment(UserSettings.self) private var userSettings
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPlan = "yearly"
    @State private var isPurchasing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                            )
                            .padding(.top, 40)
                        
                        Text("解锁 FinFlow Premium")
                            .font(.title2)
                            .bold()
                        
                        Text("获取无限访问权限，掌握财务自由")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Features
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "净资产趋势追踪")
                        FeatureRow(icon: "face.smiling", text: "情绪消费分析报告")
                        FeatureRow(icon: "square.and.arrow.up", text: "CSV 数据导出")
                        FeatureRow(icon: "infinity", text: "无限账户与分类")
                    }
                    .padding()
                    .background(AppTheme.background)
                    .cornerRadius(16)
                    
                    // Pricing Cards
                    HStack(spacing: 12) {
                        PlanCard(
                            id: "monthly",
                            title: "月度",
                            price: "\(userSettings.currencySymbol)12",
                            period: "/月",
                            isSelected: selectedPlan == "monthly",
                            action: { selectedPlan = "monthly" }
                        )
                        
                        PlanCard(
                            id: "yearly",
                            title: "年度",
                            price: "\(userSettings.currencySymbol)98",
                            period: "/年",
                            tag: "省 32%",
                            isBestValue: true,
                            isSelected: selectedPlan == "yearly",
                            action: { selectedPlan = "yearly" }
                        )
                    }
                    .frame(height: 160)
                    
                    PlanCard(
                        id: "lifetime",
                        title: "终身买断",
                        price: "\(userSettings.currencySymbol)298",
                        period: "一次性支付",
                        isSelected: selectedPlan == "lifetime",
                        action: { selectedPlan = "lifetime" }
                    )
                    .frame(height: 80)
                    
                    // Action Button
                    Button {
                        isPurchasing = true
                        Task {
                            await premiumManager.purchase(productID: selectedPlan)
                            isPurchasing = false
                            dismiss()
                        }
                    } label: {
                        HStack {
                            if isPurchasing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("立即订阅")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [AppTheme.primary, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .shadow(color: AppTheme.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    // Footer
                    Text("确认购买即代表您同意《用户协议》与《隐私政策》\n此为模拟支付，扣费不会发生。")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                }
                .padding()
            }
            .background(AppTheme.groupedBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("恢复购买") {
                        Task { await premiumManager.restorePurchases() }
                    }
                    .font(.caption)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primary)
                .frame(width: 30)
            Text(text)
                .font(.body)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundColor(.green)
                .font(.caption)
        }
    }
}

struct PlanCard: View {
    let id: String
    let title: String
    let price: String
    let period: String
    var tag: String? = nil
    var isBestValue: Bool = false
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .top) {
                VStack {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(price)
                        .font(.title2)
                        .bold()
                        .foregroundColor(isSelected ? AppTheme.primary : .primary)
                    
                    Text(period)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(AppTheme.background)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? AppTheme.primary : Color.clear, lineWidth: 2)
                )
                
                if let tag = tag {
                     Text(tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .offset(y: -10)
                }
            }
        }
    }
}

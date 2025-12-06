
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
                                LinearGradient(colors: [AppTheme.primary, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .shadow(color: AppTheme.primary.opacity(0.5), radius: 20)
                            .padding(.top, 40)
                        
                        Text("解锁 FinFlow Premium")
                            .font(.title2)
                            .bold()
                        
                        Text("无限制访问，掌握财务自由")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Features List (Updated with user requests)
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "icloud.fill", text: "iCloud 云备份与同步 (即将推出)", color: .blue)
                        FeatureRow(icon: "faceid", text: "FaceID / 指纹解锁", color: .green)
                        FeatureRow(icon: "doc.text.fill", text: "Excel 导出报表", color: .green)
                        FeatureRow(icon: "book.fill", text: "多账本管理", color: .orange)
                        FeatureRow(icon: "chart.xyaxis.line", text: "无限图表与分析", color: .purple)
                        FeatureRow(icon: "tag.fill", text: "无限自定义分类", color: .red)
                        FeatureRow(icon: "camera.fill", text: "交易图片附件 (即将推出)", color: .blue)
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
                                ProgressView().tint(.white)
                            } else {
                                Text("立即订阅")
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.primaryGradient)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .shadow(color: AppTheme.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                    
                    Text("确认购买即代表您同意《用户协议》与《隐私政策》")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .background(AppTheme.groupedBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("关闭") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("恢复购买") {
                        Task { await premiumManager.restorePurchases() }
                    }
                    .font(.caption)
                }
            }
        }
    }
}

// Subcomponents
struct FeatureRow: View {
    let icon: String
    let text: String
    var color: Color = AppTheme.primary
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(text)
                .font(.body)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppTheme.primary.opacity(0.8))
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

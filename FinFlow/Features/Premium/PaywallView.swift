
import SwiftUI

struct PremiumFeature: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let description: String
}

let premiumFeatures = [
    PremiumFeature(icon: "cloud.fill", color: .blue, title: "iCloud Backup", description: "Backup your data to iCloud! Sync across devices"),
    PremiumFeature(icon: "book.closed.fill", color: .orange, title: "Multiple Books", description: "Create dedicated books for different scenarios"),
    PremiumFeature(icon: "tray.full.fill", color: .purple, title: "Unlimited Categories", description: "Create unlimited custom expense/income categories"),
    PremiumFeature(icon: "faceid", color: .blue, title: "Fingerprint/Face ID", description: "Unlock app with Touch ID / Face ID"),
    PremiumFeature(icon: "tablecells.fill", color: .green, title: "Export Excel", description: "Export transactions to Excel"),
    PremiumFeature(icon: "magnifyingglass", color: .purple, title: "Search Transactions", description: "Search by category/amount/note/account"),
    PremiumFeature(icon: "calendar", color: .pink, title: "Custom Month/Week Start", description: "Custom start date for transaction list, charts, and budgets"),
    PremiumFeature(icon: "photo.fill", color: .cyan, title: "Transaction Photos", description: "Add receipts or memory photos to transactions"),
    PremiumFeature(icon: "clock.arrow.2.circlepath", color: .teal, title: "Recurring", description: "Support fixed payment plans, auto-record when due"),
    PremiumFeature(icon: "bell.fill", color: .yellow, title: "Reminders", description: "Support custom reminders, up to 63 local notifications"),
    PremiumFeature(icon: "chart.pie.fill", color: .indigo, title: "More Charts", description: "Advanced visualization and insights"),
    PremiumFeature(icon: "leaf.fill", color: .mint, title: "More Saving Methods", description: "Support more types of saving goals"),
    PremiumFeature(icon: "chart.bar.doc.horizontal", color: .orange, title: "Create Exclusive Budget Modes", description: "Can create inclusion or exclusion budgets, satisfying more budget scenarios"),
    PremiumFeature(icon: "heart.fill", color: .red, title: "Support Us", description: "Help us keep innovating")
]

struct PaywallView: View {
    @Environment(PremiumManager.self) private var premiumManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPurchasing = false
    
    // Screenshot Yellow Theme
    let themeYellow = Color(red: 1.0, green: 0.92, blue: 0.23) // ~#FFEB3B
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Button("Restore Purchase") {
                        Task { await premiumManager.restorePurchases() }
                    }
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
                .padding()
                .background(themeYellow)
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(premiumFeatures) { feature in
                            HStack(alignment: .top, spacing: 16) {
                                // Icon Container
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(feature.color.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: feature.icon)
                                        .foregroundStyle(feature.color)
                                        .font(.system(size: 20))
                                }
                                
                                // Text
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(feature.title)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text(feature.description)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                                
                                // Checkmark
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.top, 4)
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 120) // Bottom padding for floating button
                }
            }
            .background(Color(UIColor.systemBackground))
            .overlay(alignment: .bottom) {
                // Bottom Button Container
                VStack {
                    Button {
                        isPurchasing = true
                        Task {
                            await premiumManager.purchase(productID: "yearly")
                            isPurchasing = false
                            dismiss()
                        }
                    } label: {
                        VStack(spacing: 2) {
                            Text("Pay per year (Automatic subscription 1 year)")
                                .font(.system(size: 14))
                            Text("RM47.90")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(themeYellow)
                        .cornerRadius(30)
                        // Add slight shadow for depth as in screenshot button usually has
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                    .disabled(isPurchasing)
                    .opacity(isPurchasing ? 0.7 : 1.0)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color(UIColor.systemBackground).opacity(0), Color(UIColor.systemBackground)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                )
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    PaywallView()
        .environment(PremiumManager())
}

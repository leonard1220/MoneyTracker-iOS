//
//  CommonVerifyView.swift
//  MoneyTracker
//
//  Created for Verification.
//

import SwiftUI

struct CommonVerifyView: View {
    let date = Date()
    let amount: Decimal = 12345.678
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Common Layer Verification")
                    .font(.title)
                    .foregroundColor(AppTheme.primary)
                
                Text("Semantic Colors")
                    .font(.headline)
                HStack {
                    ColorCircle(color: AppTheme.primary, name: "Primary")
                    ColorCircle(color: AppTheme.secondary, name: "Secondary")
                    ColorCircle(color: AppTheme.accent, name: "Accent")
                }
                HStack {
                    ColorCircle(color: AppTheme.income, name: "Income")
                    ColorCircle(color: AppTheme.expense, name: "Expense")
                    ColorCircle(color: AppTheme.warning, name: "Warning")
                }
                
                Divider()
                
                Text("Extensions")
                    .font(.headline)
                Text("Date: \(date.formatted())")
                // Text("StartOfMonth: \(date.startOfMonth.formatted())") // Commenting out potential missing extension
                Text("Currency: \(amount.formattedCurrency())")
                Text("Hex Color: #FF00FF").foregroundColor(Color(hex: "#FF00FF"))
                
                Divider()
                
                Text("Components")
                    .font(.headline)
                
                EmptyStateView(
                    icon: "archivebox",
                    title: "Empty State",
                    message: "This is a test message for empty state."
                )
                .background(AppTheme.secondaryBackground)
                .cornerRadius(AppTheme.cornerRadius)
                
                LoadingView()
                    .padding()
                    .background(AppTheme.groupedBackground)
            }
            .padding()
        }
        .background(AppTheme.background)
    }
}

struct ColorCircle: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
            Text(name)
                .font(.caption)
        }
    }
}

#Preview {
    CommonVerifyView()
}

//
//  DashboardView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Auto-updating queries
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query var accounts: [Account]
    
    var totalBalance: Decimal {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    var monthlySummary: MonthlySummary {
        MonthlyReportService.generateReport(for: Date(), transactions: transactions)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Total Balance Card
                    VStack(spacing: 10) {
                        Text("总资产")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(totalBalance.formattedCurrency)
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .numberTicker(value: totalBalance)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.primary, AppTheme.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 10, y: 5)
                    .padding(.horizontal)
                    
                    // 2. Month Summary
                    HStack(spacing: 15) {
                        DashboardStatCard(
                            title: "本月收入",
                            amount: monthlySummary.totalIncome,
                            color: AppTheme.income,
                            icon: "arrow.down.left"
                        )
                        
                        DashboardStatCard(
                            title: "本月支出",
                            amount: monthlySummary.totalExpense,
                            color: AppTheme.expense,
                            icon: "arrow.up.right"
                        )
                    }
                    .padding(.horizontal)
                    
                    // 3. Recent Transactions
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("最近交易")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: TransactionListView()) {
                                Text("查看全部")
                                    .font(.subheadline)
                            }
                        }
                        
                        if transactions.isEmpty {
                            ContentUnavailableView("无交易记录", systemImage: "list.bullet.clipboard")
                        } else {
                            ForEach(transactions.prefix(5)) { transaction in
                                TransactionRowView(transaction: transaction)
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(AppTheme.background)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 20)
            }
            .background(AppTheme.groupedBackground)
            .navigationTitle("FinFlow")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DashboardStatCard: View {
    let title: String
    let amount: Decimal
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundColor(color)
                    }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(amount.formattedCurrency)
                    .font(.headline)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .numberTicker(value: amount)
            }
        }
        .padding()
        .background(AppTheme.background)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

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
    
    @State private var showAddSheet = false

    var totalBalance: Decimal {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    var monthlySummary: MonthlySummary {
        MonthlyReportService.generateReport(for: Date(), transactions: transactions)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 1. Total Balance Card (Premium Design)
                    ZStack {
                        // Background Gradient
                        LinearGradient(
                            colors: [Color(hex: "#1A2980"), Color(hex: "#26D0CE")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(24)
                        .shadow(color: Color(hex: "#1A2980").opacity(0.3), radius: 15, x: 0, y: 10)
                        
                        // Content
                        VStack(spacing: 8) {
                            Text("总资产 (Total Assets)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(alignment: .lastTextBaseline) {
                                Text(totalBalance.formattedCurrency())
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .contentTransition(.numericText(value: Double(truncating: totalBalance as NSNumber)))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Spacer()
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding(24)
                    }
                    .padding(.horizontal)
                    
                    // 2. Quick Actions (New "Add Transaction" Button)
                    HStack(spacing: 16) {
                        Button {
                            showAddSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("记一笔")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.primary)
                            .cornerRadius(16)
                            .shadow(color: AppTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 3. Month Summary
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
                    
                    // 4. Recent Transactions
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("最近交易")
                                .font(.title3)
                                .bold()
                            Spacer()
                            NavigationLink(destination: TransactionListView()) {
                                Text("查看全部")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.primary)
                            }
                        }
                        
                        if transactions.isEmpty {
                            ContentUnavailableView("无交易记录", systemImage: "list.bullet.clipboard")
                                .padding(.vertical, 20)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(transactions.prefix(5)) { transaction in
                                    TransactionRowView(transaction: transaction)
                                    if transaction.id != transactions.prefix(5).last?.id {
                                        Divider()
                                            .padding(.leading, 50)
                                    }
                                }
                            }
                            .background(AppTheme.background)
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 20)
            }
            .background(AppTheme.groupedBackground)
            .navigationTitle("FinFlow")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddSheet) {
                AddTransactionView()
            }
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
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(color)
                    }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Text(amount.formattedCurrency())
                    .font(.headline)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .background(AppTheme.background)
        .cornerRadius(18)
        // .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
}

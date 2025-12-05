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
    @Environment(PremiumManager.self) private var premiumManager
    
    // Auto-updating queries
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query var accounts: [Account]
    
    @State private var showAddSheet = false
    @State private var showPaywall = false // Added state

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
                    // ... [Previous Content Kept Intact through Replace] ... 
                    
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
                    
                    // 2. Quick Actions
                    HStack(spacing: 16) {
                        Button {
                            showAddSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                Text("记一笔")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.primary)
                            .cornerRadius(12)
                            .shadow(color: AppTheme.primary.opacity(0.3), radius: 5, y: 3)
                        }
                        
                        NavigationLink(destination: SubscriptionListView()) {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.title3)
                                Text("订阅")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(AppTheme.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppTheme.background)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                        }
                    }
                    .padding(.horizontal)

                    // 3. Accounts Overview (Horizontal List)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("我的账户")
                                .font(.title3)
                                .bold()
                            Spacer()
                            NavigationLink(destination: AccountListView()) { // Assuming AccountListView exists as destination
                                Text("管理")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.primary)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(accounts) { account in
                                    DashboardAccountCard(account: account)
                                }
                                
                                // Add Account shortcut card
                                NavigationLink(destination: AddEditAccountView()) {
                                    VStack {
                                        Image(systemName: "plus")
                                            .font(.title)
                                            .foregroundColor(.secondary)
                                        Text("添加")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(width: 140, height: 100)
                                    .background(AppTheme.background)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 4. Net Worth Trend (New)
                    if premiumManager.isPremium {
                        NetWorthTrendView()
                            .padding(.top, 10)
                    } else {
                        // View-only / Blurred for Free Users
                        ZStack {
                           NetWorthTrendView()
                                .blur(radius: 6)
                                .disabled(true)
                                .mask(RoundedRectangle(cornerRadius: 16))
                           
                           Button {
                               showPaywall = true
                           } label: {
                               VStack(spacing: 10) {
                                   Image(systemName: "lock.circle.fill")
                                       .font(.system(size: 40))
                                       .foregroundColor(.white)
                                       .shadow(radius: 5)
                                   Text("解锁净资产趋势")
                                       .font(.headline)
                                       .fontWeight(.bold)
                                       .foregroundColor(.white)
                                       .shadow(radius: 5)
                               }
                               .padding(20)
                               .background(Color.black.opacity(0.3))
                               .cornerRadius(16)
                           }
                        }
                        .padding(.top, 10)
                    }
                    
                    // 5. Month Summary
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
                    
                    // 6. Recent Transactions
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
            .sheet(isPresented: $showPaywall) {
                PaywallView()
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

struct DashboardAccountCard: View {
    let account: Account
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: account.icon)
                    .font(.title2)
                    .foregroundColor(Color(hex: account.color))
                    .frame(width: 40, height: 40)
                    .background(Color(hex: account.color).opacity(0.1))
                    .clipShape(Circle())
                
                Spacer()
                
                if account.creditLimit != nil {
                    // Show utilization or just credit badge for simplicity
                    Text("Credit")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(account.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("\(account.currency) \(account.balance.formattedCurrency(code: ""))")
                    .font(.headline)
                    .bold()
                    .lineLimit(1)
            }
        }
        .padding()
        .frame(width: 160, height: 110)
        .background(AppTheme.background)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
    }
}

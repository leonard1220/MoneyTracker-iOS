
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
                    
                    // 1. Premium Asset Card (New Fluid Design)
                    PremiumAssetCard(
                        totalBalance: totalBalance,
                        income: monthlySummary.totalIncome,
                        expense: monthlySummary.totalExpense
                    )
                    .padding(.horizontal)
                    
                    // 2. Quick Actions (Pill Buttons)
                    HStack(spacing: 12) {
                        Button {
                            HapticManager.shared.lightImpact()
                            showAddSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("记一笔")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#1C1E26"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        
                        NavigationLink(destination: SubscriptionListView()) {
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                Text("订阅")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#1C1E26"))
                            .foregroundColor(AppTheme.primary)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // 3. Main Bento Grid (Net Worth & Accounts)
                    VStack(spacing: 16) {
                        // Top Row: Net Worth Trend (Full Width)
                        if premiumManager.isPremium {
                            NetWorthTrendView()
                        } else {
                            // View-only / Blurred for Free Users
                            ZStack {
                               NetWorthTrendView()
                                    .blur(radius: 8)
                                    .disabled(true)
                                    .mask(RoundedRectangle(cornerRadius: 20))
                               
                               Button {
                                   showPaywall = true
                               } label: {
                                   VStack(spacing: 12) {
                                       Image(systemName: "lock.fill")
                                           .font(.system(size: 32))
                                           .foregroundColor(AppTheme.accent)
                                       
                                       Text("解锁趋势分析")
                                           .font(.headline)
                                           .fontWeight(.bold)
                                           .foregroundColor(.white)
                                   }
                                   .padding(24)
                                   .background(.thinMaterial)
                                   .cornerRadius(20)
                                   .shadow(radius: 10)
                               }
                            }
                        }
                        
                        // Bottom Row: Accounts (Horizontal Scroll)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("我的账户")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                NavigationLink(destination: AccountListView()) {
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
                                    
                                    // Add Account shortcut
                                    NavigationLink(destination: AddEditAccountView()) {
                                        VStack(spacing: 8) {
                                            Circle()
                                                .fill(Color(hex: "#1C1E26"))
                                                .frame(width: 48, height: 48)
                                                .overlay(
                                                    Image(systemName: "plus")
                                                        .foregroundColor(.white.opacity(0.5))
                                                )
                                            Text("添加")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(width: 120, height: 110)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [6]))
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    // End of Bento Grid Section
                    
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

// MARK: - Premium Asset Card (Merged)
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

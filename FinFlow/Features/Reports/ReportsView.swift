
import SwiftUI
import SwiftData

struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(PremiumManager.self) private var premiumManager
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @State private var selectedDate = Date()
    @State private var selectedSegment = 0 // 0: Expense, 1: Income
    @State private var showPaywall = false
    @State private var selectedCategoryForNavigation: String?
    
    var summary: MonthlySummary {
        MonthlyReportService.generateReport(for: selectedDate, transactions: transactions)
    }
    
    var currentStats: [CategoryStat] {
        selectedSegment == 0 ? summary.expenseByCategory : summary.incomeByCategory
    }
    
    var chartData: [ChartData] {
        currentStats.map { stat in
            ChartData(
                category: stat.categoryName,
                amount: stat.amount,
                color: Color(hex: stat.colorHex ?? "#808080")
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Picker (Month Wrapper)
                    HStack {
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                        Text(selectedDate.formattedDate(format: "MMMM yyyy"))
                            .font(.headline)
                            .frame(width: 150)
                        
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding()
                    .background(AppTheme.groupedBackground)
                    .cornerRadius(12)
                    
                    // Summary Cards
                    HStack(spacing: 15) {
                        SummaryCard(title: "收入", amount: summary.totalIncome, color: AppTheme.income)
                        SummaryCard(title: "支出", amount: summary.totalExpense, color: AppTheme.expense)
                    }
                    .padding(.horizontal)

                    // Mood Analytics Entry (Gated)
                    Group {
                        if premiumManager.isPremium {
                            NavigationLink(destination: MoodAnalyticsView()) {
                                MoodAnalyticsCardContent(isLocked: false)
                            }
                        } else {
                            Button {
                                showPaywall = true
                            } label: {
                                MoodAnalyticsCardContent(isLocked: true)
                            }
                        }
                    }
                    .sheet(isPresented: $showPaywall) {
                        PaywallView()
                    }
                    
                    
                    Text("结余: \(summary.netIncome.formattedCurrency())")
                        .font(.headline)
                        .foregroundColor(summary.netIncome >= 0 ? AppTheme.income : AppTheme.expense)
                    
                    // Segment
                    Picker("Type", selection: $selectedSegment) {
                        Text("支出分析").tag(0)
                        Text("收入分析").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Chart
                    if !chartData.isEmpty {
                        VStack {
                            PieChartView(
                                data: chartData,
                                totalAmount: selectedSegment == 0 ? summary.totalExpense : summary.totalIncome,
                                typeTitle: selectedSegment == 0 ? "总支出" : "总收入",
                                selectedCategory: $selectedCategoryForNavigation
                            )
                                .frame(height: 300) // Slightly taller for donut
                                .padding()
                        }
                        .background(AppTheme.background)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                        .padding(.horizontal)
                        
                        // List
                        VStack(spacing: 0) {
                            ForEach(currentStats) { stat in
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: stat.colorHex ?? "#808080").opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Image(systemName: stat.iconName ?? "tag")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: stat.colorHex ?? "#808080"))
                                    }
                                    
                                    Text(stat.categoryName)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    Text(stat.amount.formattedCurrency())
                                        .font(.callout)
                                        .bold()
                                }
                                .padding()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedCategoryForNavigation = stat.categoryName
                                }
                                Divider()
                            }
                        }
                        .background(AppTheme.background)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                    } else {
                        ContentUnavailableView("本月无数据", systemImage: "chart.pie")
                            .padding(.top, 40)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("报表")
            .background(AppTheme.groupedBackground)
            .navigationDestination(isPresented: Binding(
                get: { selectedCategoryForNavigation != nil },
                set: { if !$0 { selectedCategoryForNavigation = nil } }
            )) {
                if let categoryName = selectedCategoryForNavigation {
                    CategoryTransactionsView(categoryName: categoryName, month: selectedDate)
                }
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let amount: Decimal
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(amount.formattedCurrency())
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppTheme.background)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2)
    }
}

struct MoodAnalyticsCardContent: View {
    let isLocked: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "face.smiling.inverse")
                .font(.title2)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.purple)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("情绪消费分析")
                    .font(.headline)
                    .foregroundColor(.primary)
                HStack {
                    Text("看看心情如何影响您的钱包")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            Spacer()
            if !isLocked {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
        .background(AppTheme.background)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

//
//  TransactionListView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 交易列表视图
struct TransactionListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showAddTransaction = false
    
    // 查询交易，按日期降序排列，最多显示最近 50 笔
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    
    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    // 空状态
                    ContentUnavailableView {
                        Label("暂无交易记录", systemImage: "list.bullet")
                    } description: {
                        Text("点击右上角的 + 按钮开始记账")
                    }
                } else {
                    // 交易列表
                    List {
                        ForEach(transactions.prefix(50)) { transaction in
                            TransactionRowView(transaction: transaction)
                        }
                        .onDelete(perform: deleteTransactions)
                    }
                }
            }
            .navigationTitle("明细")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView()
            }
        }
    }
    
    /// 删除交易
    private func deleteTransactions(at offsets: IndexSet) {
        for index in offsets {
            let transaction = transactions[index]
            TransactionService.deleteTransaction(transaction, context: modelContext)
        }
    }
}

/// 交易行视图组件
struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // 类型图标和颜色
            Circle()
                .fill(typeColor)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: typeIcon)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
            
            VStack(alignment: .leading, spacing: 4) {
                // 分类名称或账户名称
                Text(displayName)
                    .font(.headline)
                
                // 备注或账户信息
                if let note = transaction.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else {
                    Text(accountInfo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                // 金额
                Text(formattedAmount)
                    .font(.headline)
                    .foregroundColor(amountColor)
                
                // 日期
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - 计算属性
    
    /// 交易类型颜色
    private var typeColor: Color {
        switch transaction.type {
        case .income:
            return AppTheme.income
        case .expense:
            return AppTheme.expense
        case .transfer:
            return AppTheme.primary
        }
    }
    
    /// 交易类型图标
    private var typeIcon: String {
        switch transaction.type {
        case .income:
            return "arrow.down.circle.fill"
        case .expense:
            return "arrow.up.circle.fill"
        case .transfer:
            return "arrow.left.arrow.right.circle.fill"
        }
    }
    
    /// 显示名称（分类或账户）
    private var displayName: String {
        if let category = transaction.category {
            return category.name
        } else if transaction.type == .transfer {
            return "转账"
        } else {
            return transaction.type.displayName
        }
    }
    
    /// 账户信息
    private var accountInfo: String {
        switch transaction.type {
        case .expense:
            return transaction.fromAccount?.name ?? "未知账户"
        case .income:
            return transaction.toAccount?.name ?? "未知账户"
        case .transfer:
            let from = transaction.fromAccount?.name ?? "未知"
            let target = transaction.targetAccount?.name ?? "未知"
            return "\(from) → \(target)"
        }
    }
    
    /// 格式化金额
    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "MYR"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let nsDecimal = transaction.amount as NSDecimalNumber
        return formatter.string(from: nsDecimal) ?? "RM \(transaction.amount)"
    }
    
    /// 金额颜色
    private var amountColor: Color {
        switch transaction.type {
        case .income:
            return AppTheme.income
        case .expense:
            return AppTheme.expense
        case .transfer:
            return .primary
        }
    }
    
    /// 格式化日期
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: transaction.date)
    }
}

#Preview {
    TransactionListView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}

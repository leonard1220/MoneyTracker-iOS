//
//  QuickAddTransactionView.swift
//  FinFlow
//
//  快速记账视图 - 极简流程，最少步骤完成记账
//

import SwiftUI
import SwiftData

struct QuickAddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Account.name) private var accounts: [Account]
    @Query(sort: \Category.name) private var allCategories: [Category]
    
    // 状态
    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category?
    @State private var selectedAccount: Account?
    @State private var note: String = ""
    @State private var showSuccess = false
    
    // 常用金额
    private let quickAmounts = [10, 20, 50, 100, 200, 500]
    
    // 根据类型过滤分类
    private var filteredCategories: [Category] {
        allCategories.filter { $0.type.rawValue == selectedType.rawValue }
    }
    
    // 最近使用的分类（前6个）
    private var recentCategories: [Category] {
        Array(filteredCategories.prefix(6))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.groupedBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 1. 类型切换
                        typeSelector
                        
                        // 2. 金额输入区域
                        amountInputSection
                        
                        // 3. 快捷金额按钮
                        quickAmountButtons
                        
                        // 4. 分类快选
                        categoryQuickSelect
                        
                        // 5. 账户选择
                        accountSelector
                        
                        // 6. 备注（可选）
                        noteSection
                        
                        // 7. 保存按钮
                        saveButton
                    }
                    .padding()
                }
            }
            .navigationTitle("快速记账")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                // 自动选择第一个账户
                if selectedAccount == nil {
                    selectedAccount = accounts.first
                }
            }
            .overlay {
                if showSuccess {
                    successOverlay
                }
            }
        }
    }
    
    // MARK: - 类型选择器
    private var typeSelector: some View {
        HStack(spacing: 12) {
            ForEach([TransactionType.expense, TransactionType.income], id: \.self) { type in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedType = type
                        selectedCategory = nil // 重置分类
                    }
                } label: {
                    HStack {
                        Image(systemName: type == .expense ? "arrow.up.right" : "arrow.down.left")
                        Text(type == .expense ? "支出" : "收入")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(selectedType == type ? (type == .expense ? AppTheme.expense : AppTheme.income) : AppTheme.background)
                    .foregroundColor(selectedType == type ? .white : .primary)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - 金额输入区域
    private var amountInputSection: some View {
        VStack(spacing: 8) {
            Text("金额")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("RM")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                TextField("0", text: $amount)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            .padding()
            .background(AppTheme.background)
            .cornerRadius(16)
        }
    }
    
    // MARK: - 快捷金额按钮
    private var quickAmountButtons: some View {
        VStack(spacing: 8) {
            Text("常用金额")
                .font(.subheadline)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dismiss()
            }
        }
    }
}

#Preview {
    QuickAddTransactionView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}

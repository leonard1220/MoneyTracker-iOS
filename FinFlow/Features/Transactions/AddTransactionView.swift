//
//  AddTransactionView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 添加交易视图
struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = TransactionsViewModel()
    
    // 查询数据
    @Query(sort: \Account.name) private var accounts: [Account]
    @Query(sort: \Category.name) private var allCategories: [Category]
    
    // 根据交易类型过滤分类
    private var filteredCategories: [Category] {
        allCategories.filter { $0.type.rawValue == viewModel.selectedType.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // 金额输入
                Section {
                    TextField("金额", text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("金额")
                } footer: {
                    if !viewModel.amount.isEmpty, Decimal(string: viewModel.amount) == nil {
                        Text("请输入有效的金额")
                            .foregroundColor(.red)
                    }
                }
                
                // 交易类型选择
                Section {
                    Picker("类型", selection: $viewModel.selectedType) {
                        Text("支出").tag(TransactionType.expense)
                        Text("收入").tag(TransactionType.income)
                        Text("转账").tag(TransactionType.transfer)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("交易类型")
                }
                
                // 账户选择
                Section {
                    if viewModel.selectedType == .expense || viewModel.selectedType == .transfer {
                        // 支出和转账：选择转出账户
                        Picker("从账户", selection: $viewModel.selectedFromAccount) {
                            Text("请选择").tag(nil as Account?)
                            ForEach(accounts) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                    }
                    
                    if viewModel.selectedType == .income {
                        // 收入：选择转入账户
                        Picker("到账户", selection: $viewModel.selectedToAccount) {
                            Text("请选择").tag(nil as Account?)
                            ForEach(accounts) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                    }
                    
                    if viewModel.selectedType == .transfer {
                        // 转账：选择目标账户
                        Picker("到账户", selection: $viewModel.selectedTargetAccount) {
                            Text("请选择").tag(nil as Account?)
                            ForEach(accounts) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                    }
                } header: {
                    Text("账户")
                }
                
                // 分类选择
                Section {
                    Picker("分类", selection: $viewModel.selectedCategory) {
                        Text("无分类").tag(nil as Category?)
                        ForEach(filteredCategories) { category in
                            HStack {
                                if let iconName = category.iconName {
                                    Image(systemName: iconName)
                                }
                                Text(category.name)
                            }
                            .tag(category as Category?)
                        }
                    }
                } header: {
                    Text("分类")
                } footer: {
                    if filteredCategories.isEmpty {
                        Text("暂无匹配的分类，请在设置中添加")
                            .foregroundColor(.secondary)
                    }
                }
                
                // 日期选择
                Section {
                    DatePicker("日期", selection: $viewModel.selectedDate, displayedComponents: .date)
                } header: {
                    Text("日期")
                }
                
                // 备注
                Section {
                    TextField("备注（可选）", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("备注")
                }
                
                // 心情选择
                Section {
                    Picker("心情", selection: $viewModel.selectedMood) {
                        ForEach(viewModel.moodOptions, id: \.self) { mood in
                            Text(viewModel.moodDisplayNames[mood] ?? "无")
                                .tag(mood)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("心情（可选）")
                }
            }
            .navigationTitle("记一笔")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveTransaction()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
    }
    
    /// 保存交易
    private func saveTransaction() {
        // 验证金额
        guard let amountValue = Decimal(string: viewModel.amount), amountValue > 0 else {
            return
        }
        
        // 创建交易对象
        let transaction = Transaction(
            amount: amountValue,
            type: viewModel.selectedType,
            date: viewModel.selectedDate,
            note: viewModel.note.isEmpty ? nil : viewModel.note,
            mood: viewModel.selectedMood,
            fromAccount: viewModel.selectedFromAccount,
            toAccount: viewModel.selectedToAccount,
            targetAccount: viewModel.selectedTargetAccount,
            category: viewModel.selectedCategory
        )
        
        // 使用服务保存交易（会自动更新账户余额）
        if TransactionService.saveTransaction(transaction, context: modelContext) {
            // 保存成功，关闭表单
            dismiss()
        }
    }
}

#Preview {
    AddTransactionView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


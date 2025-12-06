//
//  EnhancedAddTransactionView.swift
//  FinFlow
//
//  增强版记账视图 - 集成快捷记账、OCR扫描等功能
//

import SwiftUI
import SwiftData

struct EnhancedAddTransactionView: View {
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
    @State private var selectedDate = Date()
    @State private var showScanner = false
    @State private var showSuccess = false
    
    // 输入模式
    enum InputMode {
        case quick      // 快速模式
        case detailed   // 详细模式
    }
    @State private var inputMode: InputMode = .quick
    
    // 根据类型过滤分类
    private var filteredCategories: [Category] {
        allCategories.filter { $0.type.rawValue == selectedType.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.groupedBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 模式切换
                        modeSwitcher
                        
                        if inputMode == .quick {
                            quickModeContent
                        } else {
                            detailedModeContent
                        }
                        
                        // 保存按钮
                        saveButton
                    }
                    .padding()
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showScanner = true
                        } label: {
                            Label("扫描票据", systemImage: "doc.text.viewfinder")
                        }
                        
                        Button {
                            // 语音输入（未来功能）
                        } label: {
                            Label("语音记账", systemImage: "mic.fill")
                        }
                        .disabled(true)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showScanner) {
                ReceiptScannerView(scannedAmount: $amount, scannedNote: $note)
            }
            .onAppear {
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
    
    // MARK: - 模式切换器
    private var modeSwitcher: some View {
        Picker("输入模式", selection: $inputMode) {
            Text("快速").tag(InputMode.quick)
            Text("详细").tag(InputMode.detailed)
        }
        .pickerStyle(.segmented)
    }
    
    // MARK: - 快速模式内容
    private var quickModeContent: some View {
        VStack(spacing: 20) {
            // 类型选择
            typeSelector
            
            // 金额输入
            amountInput
            
            // 快捷金额
            quickAmounts
            
            // 分类选择
            categoryGrid
            
            // 账户选择
            accountPicker
            
            // 简单备注
            TextField("备注（可选）", text: $note)
                .padding()
                .background(AppTheme.background)
                .cornerRadius(12)
        }
    }
    
    // MARK: - 详细模式内容
    private var detailedModeContent: some View {
        VStack(spacing: 16) {
            // 类型选择
            typeSelector
            
            // 金额
            amountInput
            
            // 分类
            VStack(alignment: .leading, spacing: 8) {
                Text("分类")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Menu {
                    ForEach(filteredCategories) { category in
                        Button {
                            selectedCategory = category
                        } label: {
                            HStack {
                                if let icon = category.iconName {
                                    Image(systemName: icon)
                                }
                                Text(category.name)
                                if selectedCategory?.id == category.id {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        if let category = selectedCategory {
                            if let icon = category.iconName {
                                Image(systemName: icon)
                            }
                            Text(category.name)
                        } else {
                            Text("选择分类")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(AppTheme.background)
                    .cornerRadius(12)
                }
            }
            
            // 账户
            accountPicker
            
            // 日期
            VStack(alignment: .leading, spacing: 8) {
                Text("日期")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .padding()
                    .background(AppTheme.background)
                    .cornerRadius(12)
            }
            
            // 备注
            VStack(alignment: .leading, spacing: 8) {
                Text("备注")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("添加备注...", text: $note, axis: .vertical)
                    .lineLimit(3...6)
                    .padding()
                    .background(AppTheme.background)
                    .cornerRadius(12)
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
                        selectedCategory = nil
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
    
    // MARK: - 金额输入
    private var amountInput: some View {
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
    
    // MARK: - 快捷金额
    private var quickAmounts: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach([10, 20, 50, 100, 200, 500], id: \.self) { value in
                Button {
                    amount = String(value)
                } label: {
                    Text("RM \(value)")
                        .font(.headline)
                        .foregroundColor(AppTheme.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(AppTheme.primary.opacity(0.1))
                        .cornerRadius(10)
                }
            }
        }
    }
    
    // MARK: - 分类网格
    private var categoryGrid: some View {
        VStack(spacing: 12) {
            HStack {
                Text("分类")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(filteredCategories.prefix(6)) { category in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = category
                        }
                    } label: {
                        VStack(spacing: 6) {
                            if let icon = category.iconName {
                                Image(systemName: icon)
                                    .font(.title2)
                            }
                            Text(category.name)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(selectedCategory?.id == category.id ? AppTheme.primary : AppTheme.background)
                        .foregroundColor(selectedCategory?.id == category.id ? .white : .primary)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    // MARK: - 账户选择器
    private var accountPicker: some View {
        VStack(spacing: 8) {
            Text("账户")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Menu {
                ForEach(accounts) { account in
                    Button {
                        selectedAccount = account
                    } label: {
                        HStack {
                            Image(systemName: account.icon)
                            Text(account.name)
                            if selectedAccount?.id == account.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    if let account = selectedAccount {
                        Image(systemName: account.icon)
                            .foregroundColor(Color(hex: account.color))
                        Text(account.name)
                            .foregroundColor(.primary)
                    } else {
                        Text("选择账户")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(AppTheme.background)
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - 保存按钮
    private var saveButton: some View {
        Button {
            saveTransaction()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("保存")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isFormValid ? AppTheme.primary : Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: isFormValid ? AppTheme.primary.opacity(0.3) : .clear, radius: 10, y: 5)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - 成功提示
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("记账成功!")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(40)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - 表单验证
    private var isFormValid: Bool {
        guard let amountValue = Decimal(string: amount), amountValue > 0 else {
            return false
        }
        return selectedAccount != nil
    }
    
    // MARK: - 保存交易
    private func saveTransaction() {
        guard let amountValue = Decimal(string: amount), amountValue > 0 else {
            return
        }
        
        guard let account = selectedAccount else {
            return
        }
        
        let transaction = Transaction(
            amount: amountValue,
            type: selectedType,
            date: inputMode == .quick ? Date() : selectedDate,
            note: note.isEmpty ? nil : note,
            mood: nil,
            fromAccount: selectedType == .expense ? account : nil,
            toAccount: selectedType == .income ? account : nil,
            targetAccount: nil,
            category: selectedCategory
        )
        
        if TransactionService.saveTransaction(transaction, context: modelContext) {
            withAnimation(.spring(response: 0.5)) {
                showSuccess = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dismiss()
            }
        }
    }
}

#Preview {
    EnhancedAddTransactionView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}

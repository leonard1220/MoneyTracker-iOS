//
//  AddEditAccountView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 添加/编辑账户视图
struct AddEditAccountView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // 编辑模式下的现有账户
    var accountToEdit: Account?
    
    // 表单状态
    @State private var name: String = ""
    @State private var type: AccountType = .cash
    @State private var balance: String = ""
    @State private var currency: String = "CNY"
    @State private var icon: String = "creditcard"
    @State private var color: String = "#007AFF"
    @State private var creditLimit: String = ""
    
    var isEditing: Bool {
        accountToEdit != nil
    }
    
    var body: some View {
        Form {
            Section("基本信息") {
                TextField("账户名称", text: $name)
                
                Picker("账户类型", selection: $type) {
                    ForEach(AccountType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .onChange(of: type) { oldValue, newValue in
                    updateDefaultIcon(for: newValue)
                }
                
                HStack {
                    Text("当前余额")
                    Spacer()
                    TextField("0.00", text: $balance)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                
                if type == .credit {
                    HStack {
                        Text("信用额度")
                        Spacer()
                        TextField("0.00", text: $creditLimit)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Picker("货币", selection: $currency) {
                    Text("CNY - 人民币").tag("CNY")
                    Text("USD - 美元").tag("USD")
                    Text("EUR - 欧元").tag("EUR")
                    Text("HKD - 港币").tag("HKD")
                    Text("JPY - 日元").tag("JPY")
                }
            }
            
            Section("图标与颜色") {
                VStack(alignment: .leading) {
                    Text("选择图标")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    IconPickerView(selectedIcon: $icon, colorHex: color)
                }
                
                VStack(alignment: .leading) {
                    Text("选择颜色")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ColorPickerView(selectedColor: $color)
                }
            }
        }
        .navigationTitle(isEditing ? "编辑账户" : "添加账户")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") {
                    saveAccount()
                }
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            if let account = accountToEdit {
                loadAccountData(account)
            }
        }
    }
    
    private func updateDefaultIcon(for type: AccountType) {
        // 如果用户未手动更改过图标（这里简化处理，直接基于类型更新）
        switch type {
        case .cash: icon = "banknote"
        case .bank: icon = "building.columns"
        case .ewallet: icon = "wallet.pass"
        case .credit: icon = "creditcard"
        case .loan: icon = "doc.text" // Mapped loan
        }
    }
    
    private func loadAccountData(_ account: Account) {
        name = account.name
        type = account.type
        balance = "\(account.balance)"
        currency = account.currency
        icon = account.icon
        color = account.color
        if let limit = account.creditLimit {
            creditLimit = "\(limit)"
        }
    }
    
    private func saveAccount() {
        let balanceDecimal = Decimal(string: balance) ?? 0
        let limitDecimal = creditLimit.isEmpty ? nil : Decimal(string: creditLimit)
        
        if let account = accountToEdit {
            // 更新
            account.name = name
            account.type = type
            account.balance = balanceDecimal
            account.currency = currency
            account.icon = icon
            account.color = color
            account.creditLimit = limitDecimal
            account.updatedAt = Date()
        } else {
            // 新增
            let newAccount = Account(
                name: name,
                type: type,
                balance: balanceDecimal,
                currency: currency,
                icon: icon,
                color: color,
                creditLimit: limitDecimal
            )
            modelContext.insert(newAccount)
        }
        
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddEditAccountView()
    }
}


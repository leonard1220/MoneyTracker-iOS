//
//  AccountListView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 账户列表视图
struct AccountListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.sortOrder, order: .forward) private var accounts: [Account]
    @State private var showAddAccount = false
    @State private var accountToEdit: Account?
    
    // 计算总资产
    var totalBalance: Decimal {
        accounts.reduce(0) { $0 + $1.balance }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if accounts.isEmpty {
                    EmptyStateView(
                        icon: "creditcard",
                        title: "暂无账户",
                        message: "添加您的第一个账户来管理资金"
                    )
                } else {
                    List {
                        // 资产总览
                        Section {
                            VStack(spacing: 8) {
                                Text("总资产")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(totalBalance.formattedCurrency())
                                    .font(.system(size: 32, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .listRowBackground(Color.clear)
                        }
                        
                        // 账户列表
                        ForEach(accounts) { account in
                            AccountRowView(account: account)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    accountToEdit = account
                                }
                        }
                        .onDelete(perform: deleteAccounts)
                    }
                }
            }
            .navigationTitle("账户")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddAccount = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddAccount) {
                NavigationStack {
                    AddEditAccountView()
                }
            }
            .sheet(item: $accountToEdit) { account in
                NavigationStack {
                    AddEditAccountView(accountToEdit: account)
                }
            }
        }
    }
    
    private func deleteAccounts(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(accounts[index])
        }
    }
}

struct AccountRowView: View {
    let account: Account
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: account.color).opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: account.icon)
                    .foregroundColor(Color(hex: account.color))
                    .font(.system(size: 20))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(account.name)
                    .font(.headline)
                Text(account.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(account.balance.formattedCurrency(code: account.currency))
                .font(.headline)
                .foregroundColor(account.balance >= 0 ? .primary : AppTheme.expense)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AccountListView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


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
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("这里将显示账户列表")
                        .foregroundColor(.secondary)
                } header: {
                    Text("我的账户")
                }
            }
            .navigationTitle("账户")
        }
    }
}

#Preview {
    AccountListView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


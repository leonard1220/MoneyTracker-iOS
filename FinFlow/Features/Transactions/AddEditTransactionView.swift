//
//  AddEditTransactionView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 添加/编辑交易视图
struct AddEditTransactionView: View {
    var body: some View {
        Text("Add/Edit Transaction")
            .navigationTitle("添加交易")
    }
}

#Preview {
    NavigationStack {
        AddEditTransactionView()
    }
}


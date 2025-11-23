//
//  ReportsView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 报表视图
struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("这里将显示统计报表")
                        .foregroundColor(.secondary)
                } header: {
                    Text("报表")
                }
                
                Section {
                    Text("这里将显示图表")
                        .foregroundColor(.secondary)
                } header: {
                    Text("图表")
                }
            }
            .navigationTitle("报表")
        }
    }
}

#Preview {
    ReportsView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


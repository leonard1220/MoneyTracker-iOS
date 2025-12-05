//
//  DashboardView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 仪表盘视图
struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("这里将显示财务概览")
                        .foregroundColor(.secondary)
                } header: {
                    Text("总览")
                }
                
                Section {
                    Text("这里将显示最近交易记录")
                        .foregroundColor(.secondary)
                } header: {
                    Text("最近交易")
                }
            }
            .navigationTitle("首页")
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


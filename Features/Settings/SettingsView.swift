//
//  SettingsView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 设置视图
struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("这里将显示应用设置")
                        .foregroundColor(.secondary)
                } header: {
                    Text("设置")
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


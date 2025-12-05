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
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        CommonVerifyView()
                    } label: {
                        Image(systemName: "paintpalette")
                    }
                }
            }
            
            List {
                Section {
                    Text("这里将显示应用设置")
                        .foregroundColor(.secondary)
                } header: {
                    Text("通用")
                }
                
                Section {
                    NavigationLink(destination: AccountListView()) {
                        Label {
                            Text("账户管理")
                        } icon: {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.blue.gradient)
                                .cornerRadius(6)
                        }
                    }
                    
                    NavigationLink(destination: CategorySettingsView()) {
                        Label {
                            Text("分类管理")
                        } icon: {
                            Image(systemName: "square.grid.2x2")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.orange.gradient)
                                .cornerRadius(6)
                        }
                    }
                } header: {
                    Text("偏好设置")
                }
                
                Section("开发者选项") {
                    NavigationLink("数据模型验证", destination: ModelTestView())
                    NavigationLink("UI/主题验证", destination: CommonVerifyView())
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


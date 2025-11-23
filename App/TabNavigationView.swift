//
//  TabNavigationView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 主 Tab 导航视图
struct TabNavigationView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
            
            TransactionListView()
                .tabItem {
                    Label("明细", systemImage: "list.bullet")
                }
            
            AccountListView()
                .tabItem {
                    Label("账户", systemImage: "creditcard.fill")
                }
            
            ReportsView()
                .tabItem {
                    Label("报表", systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    TabNavigationView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


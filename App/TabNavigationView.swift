//
//  TabNavigationView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 主 Tab 导航视图
struct TabNavigationView: View {
    @Environment(AppEnvironment.self) private var appEnvironment
    
    var body: some View {
        TabView(selection: Bindable(appEnvironment).selectedTab) {
            DashboardView()
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            TransactionListView()
                .tabItem {
                    Label("明细", systemImage: "list.bullet")
                }
                .tag(1)
            
            AccountListView()
                .tabItem {
                    Label("账户", systemImage: "creditcard.fill")
                }
                .tag(2)
            
            ReportsView()
                .tabItem {
                    Label("报表", systemImage: "chart.bar.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(AppTheme.primary)
    }
}

#Preview {
    TabNavigationView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


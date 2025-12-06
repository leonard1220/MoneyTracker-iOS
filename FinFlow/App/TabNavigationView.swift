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
    @Environment(\.quickActionToPerform) private var quickActionToPerform
    
    @State private var showQuickAdd = false
    @State private var showScanner = false
    @State private var quickAddType: TransactionType = .expense
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Content View
            TabView(selection: Bindable(appEnvironment).selectedTab) {
                DashboardView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar) // Hide native tab bar
                
                TransactionListView()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
                
                PlanningView()
                    .tag(2)
                    .toolbar(.hidden, for: .tabBar)
                
                ReportsView()
                    .tag(3)
                    .toolbar(.hidden, for: .tabBar)
                
                SettingsView()
                    .tag(4)
                    .toolbar(.hidden, for: .tabBar)
            }
            // 关键修复: 添加底部安全区域垫片，防止内容被 Floating Tab Bar 遮挡
            // 高度计算: 64 (Bar Height) + 8 (Bottom Padding) + 20 (Extra Buffer)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 92)
            } 
            
            // 2. Custom Floating Tab Bar
            FloatingTabBar(selectedTab: Bindable(appEnvironment).selectedTab)
                // 确保浮动条在 Sheet 之上不会出现（Sheet 会盖住它，但在主视图层级中它在最上）
        }
        .ignoresSafeArea(.keyboard) // 键盘弹出时不顶起 Tab Bar
        .sheet(isPresented: $showQuickAdd) {
            QuickAddTransactionView()
        }
        .sheet(isPresented: $showScanner) {
            ReceiptScannerView(scannedAmount: .constant(""), scannedNote: .constant(""))
        }
        .onChange(of: quickActionToPerform.wrappedValue) { _, newAction in
            handleQuickAction(newAction)
        }
    }
    
    // MARK: - Handle Quick Actions
    private func handleQuickAction(_ action: QuickAction?) {
        guard let action = action else { return }
        
        switch action {
        case .addExpense:
            quickAddType = .expense
            showQuickAdd = true
        case .addIncome:
            quickAddType = .income
            showQuickAdd = true
        case .scanReceipt:
            showScanner = true
        }
        
        // 重置 action
        quickActionToPerform.wrappedValue = nil
    }
}

#Preview {
    TabNavigationView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}



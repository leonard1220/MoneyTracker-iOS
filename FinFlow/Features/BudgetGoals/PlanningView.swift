//
//  PlanningView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI

enum PlanningTab: String, CaseIterable {
    case budgets = "预算"
    case goals = "目标"
}

struct PlanningView: View {
    @State private var selectedTab: PlanningTab = .budgets
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Tab", selection: $selectedTab) {
                    ForEach(PlanningTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(AppTheme.groupedBackground)
                
                if selectedTab == .budgets {
                     BudgetGoalsViewContainer()
                } else {
                     SavingsGoalsListView()
                }
            }
            .navigationTitle("财务计划")
            .navigationBarTitleDisplayMode(.inline)
            .background(AppTheme.groupedBackground)
        }
    }
}

// Wrapper to prevent NavigationStack inside NavigationStack if BudgetGoalsView has one
// We'll modify BudgetGoalsView slightly to be embedded
struct BudgetGoalsViewContainer: View {
    var body: some View {
        BudgetGoalsView(isEmbedded: true)
    }
}

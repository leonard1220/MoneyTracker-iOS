//
//  BudgetGoalsView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

struct BudgetGoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var budgets: [Budget]
    @Query private var transactions: [Transaction]
    
    @State private var viewModel = BudgetGoalsViewModel()
    @State private var showAddSheet = false
    var isEmbedded: Bool = false
    
    var body: some View {
        content
            .sheet(isPresented: $showAddSheet) {
                AddEditBudgetView()
            }
            .onAppear {
                viewModel.loadBudgets(budgets: budgets, transactions: transactions)
            }
            .onChange(of: transactions) { _, _ in
                viewModel.loadBudgets(budgets: budgets, transactions: transactions)
            }
            .onChange(of: budgets) { _, _ in
                viewModel.loadBudgets(budgets: budgets, transactions: transactions)
            }
    }
    
    @ViewBuilder
    var content: some View {
        if isEmbedded {
            listContent
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        addButton
                    }
                }
        } else {
            NavigationStack {
                listContent
                    .navigationTitle("预算管理")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            addButton
                        }
                    }
            }
        }
    }
    
    var addButton: some View {
        Button {
            showAddSheet = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
    var listContent: some View {
        List {
            ForEach(viewModel.budgetProgresses, id: \.budget.id) { progress in
                BudgetRow(progress: progress)
                    .swipeActions {
                        Button("删除", role: .destructive) {
                            viewModel.deleteBudget(progress.budget, context: modelContext)
                        }
                    }
            }
        }
    }
}

struct BudgetRow: View {
    let progress: BudgetProgress
    
    var color: Color {
        switch progress.status {
        case .normal: return .green
        case .warning: return .orange
        case .exceeded: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let cat = progress.budget.category {
                    Text(cat.iconName) // Emoji icon
                    Text(cat.name)
                        .font(.headline)
                } else {
                    Image(systemName: "globe")
                    Text("总预算")
                        .font(.headline)
                }
                
                Spacer()
                
                Text(progress.percent.formatted(.percent.precision(.fractionLength(0))))
                    .bold()
                    .foregroundColor(color)
            }
            
            ProgressView(value: min(progress.percent, 1.0))
                .tint(color)
            
            HStack {
                Text("已用: \(progress.spent.formattedCurrency)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("剩余: \(progress.remaining.formattedCurrency)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

//
//  SavingsGoalsListView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

struct SavingsGoalsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavingsGoal.createdAt) var goals: [SavingsGoal]
    @State private var showAddSheet = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                ForEach(goals) { goal in
                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                        GoalCard(goal: goal)
                    }
                }
            }
            .padding()
        }
        .overlay {
            if goals.isEmpty {
                ContentUnavailableView("无存钱目标", systemImage: "star", description: Text("点击右上角 + 创建一个目标"))
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddEditGoalView()
        }
    }
}

struct GoalCard: View {
    let goal: SavingsGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(AppTheme.primary.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "target")
                            .foregroundColor(AppTheme.primary)
                    }
                Spacer()
                Text(goal.progress.formatted(.percent.precision(.fractionLength(0))))
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(AppTheme.primary.opacity(0.1))
                    .cornerRadius(8)
            }
            
            Text(goal.name)
                .font(.headline)
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("已存: \(goal.currentAmount.formattedCurrency())")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ProgressView(value: min(goal.progress, 1.0))
                    .tint(AppTheme.primary)
            }
        }
        .padding()
        .background(AppTheme.background)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

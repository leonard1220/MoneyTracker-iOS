//
//  GoalDetailView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Bindable var goal: SavingsGoal
    @State private var amountString: String = ""
    @State private var isDepositing: Bool = true // true = deposit, false = withdraw
    @State private var showOperationSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Circular Progress
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(goal.progress))
                        .stroke(
                            AppTheme.primary,
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut, value: goal.progress)
                    
                    VStack {
                        Text(goal.progress.formatted(.percent.precision(.fractionLength(1))))
                            .font(.largeTitle)
                            .bold()
                        Text("已存")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 200, height: 200)
                .padding(.top, 40)
                
                // Info Grid
                HStack(spacing: 40) {
                    VStack {
                        Text("当前金额")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(goal.currentAmount.formattedCurrency())
                            .font(.title3)
                            .bold()
                    }
                    
                    VStack {
                        Text("目标金额")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(goal.targetAmount.formattedCurrency())
                            .font(.title3)
                            .bold()
                    }
                }
                
                if let date = goal.targetDate {
                    HStack {
                        Image(systemName: "calendar")
                        Text("截止日期: \(date.formattedDate)")
                    }
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                }
                
                // Buttons
                HStack(spacing: 20) {
                    Button {
                        isDepositing = false
                        amountString = ""
                        showOperationSheet = true
                    } label: {
                        Label("取出", systemImage: "minus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                    }
                    
                    Button {
                        isDepositing = true
                        amountString = ""
                        showOperationSheet = true
                    } label: {
                        Label("存入", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(goal.name)
        .sheet(isPresented: $showOperationSheet) {
            NavigationStack {
                Form {
                    TextField("金额", text: $amountString)
                        .keyboardType(.decimalPad)
                        .font(.title)
                }
                .navigationTitle(isDepositing ? "存入资金" : "取出资金")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("确认") {
                            guard let amount = Decimal(string: amountString) else { return }
                            if isDepositing {
                                goal.currentAmount += amount
                            } else {
                                goal.currentAmount -= amount
                            }
                            goal.updatedAt = Date()
                            showOperationSheet = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("取消") { showOperationSheet = false }
                    }
                }
                .presentationDetents([.height(250)])
            }
        }
    }
}

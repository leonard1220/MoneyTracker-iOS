//
//  AddEditGoalView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

struct AddEditGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var targetAmountString: String = ""
    @State private var currentAmountString: String = ""
    @State private var targetDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
    @State private var hasDeadline: Bool = true
    
    var goalToEdit: SavingsGoal?
    
    init(goal: SavingsGoal? = nil) {
        self.goalToEdit = goal
        if let g = goal {
            _name = State(initialValue: g.name)
            _targetAmountString = State(initialValue: g.targetAmount.description)
            _currentAmountString = State(initialValue: g.currentAmount.description)
            _targetDate = State(initialValue: g.targetDate ?? Date())
            _hasDeadline = State(initialValue: g.targetDate != nil)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("目标详情") {
                    TextField("目标名称 (例如: 买车)", text: $name)
                    
                    TextField("目标金额", text: $targetAmountString)
                        .keyboardType(.decimalPad)
                    
                    if goalToEdit == nil {
                        TextField("初始存入 (可选)", text: $currentAmountString)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("时间") {
                    Toggle("设置截止日期", isOn: $hasDeadline)
                    if hasDeadline {
                        DatePicker("截止日期", selection: $targetDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle(goalToEdit == nil ? "新建存钱目标" : "编辑目标")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .disabled(name.isEmpty || targetAmountString.isEmpty)
                }
            }
        }
    }
    
    private func save() {
        guard let targetAmount = Decimal(string: targetAmountString) else { return }
        let currentAmount = Decimal(string: currentAmountString) ?? 0
        
        let deadline = hasDeadline ? targetDate : nil
        
        if let goal = goalToEdit {
            goal.name = name
            goal.targetAmount = targetAmount
            goal.targetDate = deadline
            goal.updatedAt = Date()
        } else {
            let newGoal = SavingsGoal(
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: deadline
            )
            modelContext.insert(newGoal)
        }
        
        dismiss()
    }
}

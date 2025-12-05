//
//  AddEditBudgetView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

struct AddEditBudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Category.sortOrder) var categories: [Category]
    
    @State private var amountString: String = ""
    @State private var selectedCategory: Category?
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var isRecurring = true
    
    var budgetToEdit: Budget?
    
    init(budget: Budget? = nil) {
        self.budgetToEdit = budget
        if let b = budget {
            _amountString = State(initialValue: b.amount.description)
            _selectedCategory = State(initialValue: b.category)
            _startDate = State(initialValue: b.startDate)
            _endDate = State(initialValue: b.endDate)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("目标设置") {
                    TextField("金额", text: $amountString)
                        .keyboardType(.decimalPad)
                    
                    Picker("分类 (可选)", selection: $selectedCategory) {
                        Text("全部分类 (总预算)").tag(nil as Category?)
                        ForEach(categories.filter { $0.type == .expense }) { cat in
                            HStack {
                                Text(cat.iconName)
                                Text(cat.name)
                            }
                            .tag(cat as Category?)
                        }
                    }
                }
                
                Section("时间范围") {
                    DatePicker("开始日期", selection: $startDate, displayedComponents: .date)
                    DatePicker("结束日期", selection: $endDate, displayedComponents: .date)
                }
            }
            .navigationTitle(budgetToEdit == nil ? "新建预算" : "编辑预算")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .disabled(amountString.isEmpty)
                }
            }
        }
    }
    
    private func save() {
        guard let amount = Decimal(string: amountString) else { return }
        
        // Ensure start < end
        if startDate >= endDate {
             // Logic to fix date? Or just ignore for now
        }
        
        if let budget = budgetToEdit {
            budget.amount = amount
            budget.category = selectedCategory
            budget.startDate = startDate
            budget.endDate = endDate
            budget.updatedAt = Date()
        } else {
            let newBudget = Budget(
                category: selectedCategory,
                amount: amount,
                startDate: startDate,
                endDate: endDate
            )
            modelContext.insert(newBudget)
        }
        
        dismiss()
    }
}

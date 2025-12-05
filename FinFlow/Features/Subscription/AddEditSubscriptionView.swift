//
//  AddEditSubscriptionView.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI
import SwiftData

struct AddEditSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var subscriptionToEdit: Subscription?
    
    @State private var name: String = ""
    @State private var priceString: String = ""
    @State private var cycle: String = "Monthly"
    @State private var nextDate: Date = Date()
    @State private var icon: String = "globe"
    @State private var color: String = "#007AFF"
    
    let cycles = ["Monthly", "Yearly", "Weekly"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    TextField("名称 (例如: Netflix)", text: $name)
                    
                    HStack {
                        Text("金额")
                        TextField("0.00", text: $priceString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Picker("周期", selection: $cycle) {
                        ForEach(cycles, id: \.self) { c in
                            Text(cycleDisplayName(c)).tag(c)
                        }
                    }
                    
                    DatePicker("下次扣款", selection: $nextDate, displayedComponents: .date)
                }
                
                Section("图标与颜色") {
                    IconPickerView(selectedIcon: $icon, colorHex: color)
                    ColorPickerView(selectedColor: $color)
                }
            }
            .navigationTitle(subscriptionToEdit == nil ? "添加订阅" : "编辑订阅")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") { save() }
                        .disabled(name.isEmpty || priceString.isEmpty)
                }
            }
            .onAppear {
                if let sub = subscriptionToEdit {
                    name = sub.name
                    priceString = "\(sub.price)"
                    cycle = sub.billingCycle
                    nextDate = sub.nextPaymentDate
                    icon = sub.icon
                    color = sub.color ?? "#007AFF"
                }
            }
        }
    }
    
    private func save() {
        let price = Decimal(string: priceString) ?? 0
        
        if let sub = subscriptionToEdit {
            sub.name = name
            sub.price = price
            sub.billingCycle = cycle
            sub.nextPaymentDate = nextDate
            sub.icon = icon
            sub.color = color
        } else {
            let newSub = Subscription(
                name: name,
                price: price,
                billingCycle: cycle,
                nextPaymentDate: nextDate,
                icon: icon,
                color: color
            )
            modelContext.insert(newSub)
        }
        dismiss()
    }
    
    private func cycleDisplayName(_ cycle: String) -> String {
        switch cycle {
        case "Monthly": return "每月"
        case "Yearly": return "每年"
        case "Weekly": return "每周"
        default: return cycle
        }
    }
}

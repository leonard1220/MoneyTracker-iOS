//
//  ModelTestView.swift
//  MoneyTracker
//
//  Created for Verification.
//

import SwiftUI
import SwiftData

struct ModelTestView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var accounts: [Account]
    
    var body: some View {
        VStack {
            Text("Model Verification")
                .font(.title)
            
            Button("Add Sample Data") {
                addSampleData()
            }
            
            List {
                ForEach(accounts) { account in
                    VStack(alignment: .leading) {
                        Text(account.name).font(.headline)
                        Text("Balance: \(account.balance.description)")
                        Text("Currency: \(account.currency)")
                    }
                }
            }
        }
    }
    
    private func addSampleData() {
        let account = Account(
            name: "Test Bank",
            type: .bank,
            balance: 1000,
            currency: "CNY",
            icon: "building.columns",
            color: "#FF0000"
        )
        
        let category = Category(
            name: "Food",
            type: .expense,
            iconName: "cart",
            color: "#00FF00",
            isSystem: true,
            isDefault: true
        )
        
        let transaction = Transaction(
            amount: 50,
            type: .expense,
            note: "Lunch",
            fromAccount: account,
            category: category
        )
        
        let budget = Budget(
            category: category,
            amount: 2000,
            period: .monthly,
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600*24*30)
        )
        
        let goal = SavingsGoal(
            name: "New Phone",
            targetAmount: 5000,
            account: account
        )
        
        modelContext.insert(account)
        modelContext.insert(category)
        modelContext.insert(transaction)
        modelContext.insert(budget)
        modelContext.insert(goal)
    }
}

#Preview {
    ModelTestView()
        .modelContainer(Persistence.createContainer())
}

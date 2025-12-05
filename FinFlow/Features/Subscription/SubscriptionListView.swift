//
//  SubscriptionListView.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI
import SwiftData

struct SubscriptionListView: View {
    @Query(sort: \Subscription.nextPaymentDate) private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showAddSheet = false
    
    var totalMonthly: Decimal {
        subscriptions.reduce(0) { total, sub in
            if sub.billingCycle == "Monthly" {
                return total + sub.price
            } else if sub.billingCycle == "Yearly" {
                return total + (sub.price / 12)
            } else if sub.billingCycle == "Weekly" {
                return total + (sub.price * 4)
            }
            return total
        }
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 5) {
                    Text("每月固定支出 (估算)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(totalMonthly.formattedCurrency())
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }
                .padding(.vertical, 10)
            }
            
            Section("我的订阅") {
                ForEach(subscriptions) { sub in
                    HStack {
                        Image(systemName: sub.icon)
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color(hex: sub.color ?? "#007AFF"))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(sub.name)
                                .font(.headline)
                            Text("\(sub.billingCycle) • 下次: \(sub.nextPaymentDate.formattedDate)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(sub.price.formattedCurrency())
                            .bold()
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(sub)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                        
                        NavigationLink {
                            AddEditSubscriptionView(subscriptionToEdit: sub)
                        } label: {
                            Label("编辑", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .navigationTitle("订阅管理")
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
            AddEditSubscriptionView()
        }
    }
}

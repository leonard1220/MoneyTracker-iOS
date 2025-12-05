//
//  Subscription.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import Foundation
import SwiftData

@Model
final class Subscription {
    var id: UUID
    var name: String
    var price: Decimal
    var currency: String
    var billingCycle: String // "Monthly", "Yearly", "Weekly"
    var nextPaymentDate: Date
    var icon: String
    var color: String?
    var notes: String?
    
    // Optional: Auto-create transaction?
    var autoRecord: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        price: Decimal,
        currency: String = "CNY",
        billingCycle: String = "Monthly",
        nextPaymentDate: Date = Date(),
        icon: String = "scribble.variable",
        color: String? = nil,
        notes: String? = nil,
        autoRecord: Bool = false
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
        self.billingCycle = billingCycle
        self.nextPaymentDate = nextPaymentDate
        self.icon = icon
        self.color = color
        self.notes = notes
        self.autoRecord = autoRecord
    }
}

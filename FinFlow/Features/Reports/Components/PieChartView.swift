//
//  PieChartView.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    let category: String
    let amount: Decimal
    let color: Color
}

struct PieChartView: View {
    let data: [ChartData]
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Chart(data) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(item.color)
                .annotation(position: .overlay) {
                    if item.amount > 0 {
                        // Only show if slice is big enough? Simplified for now.
                    }
                }
            }
        } else {
            // Fallback for iOS 16
            Chart(data) { item in
                BarMark(
                    x: .value("Amount", item.amount),
                    y: .value("Category", item.category)
                )
                .foregroundStyle(item.color)
            }
        }
    }
}

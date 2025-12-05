//
//  NetWorthTrendView.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI
import Charts
import SwiftData

struct NetWorthTrendView: View {
    @Query(sort: \DailyBalanceSnapshot.date) private var snapshots: [DailyBalanceSnapshot]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("净资产趋势")
                .font(.headline)
                .padding(.horizontal)
            
            if snapshots.isEmpty {
                 ContentUnavailableView("暂无趋势数据", systemImage: "chart.xyaxis.line")
                    .frame(height: 200)
            } else {
                Chart(snapshots) { snapshot in
                    LineMark(
                        x: .value("Date", snapshot.date),
                        y: .value("Net Worth", snapshot.netWorth)
                    )
                    .foregroundStyle(AppTheme.primary)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", snapshot.date),
                        y: .value("Net Worth", snapshot.netWorth)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppTheme.primary.opacity(0.3), AppTheme.primary.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 200)
                .padding()
            }
        }
        .background(AppTheme.background)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

@Model
final class DailyBalanceSnapshot {
    var date: Date
    var totalAssets: Decimal
    var totalLiabilities: Decimal
    
    var netWorth: Decimal {
        totalAssets - totalLiabilities
    }
    
    init(date: Date = Date(), totalAssets: Decimal, totalLiabilities: Decimal) {
        self.date = date
        self.totalAssets = totalAssets
        self.totalLiabilities = totalLiabilities
    }
}

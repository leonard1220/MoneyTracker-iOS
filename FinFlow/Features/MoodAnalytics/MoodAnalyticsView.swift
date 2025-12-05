//
//  MoodAnalyticsView.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI
import Charts
import SwiftData

struct MoodAnalyticsView: View {
    @Query private var transactions: [Transaction]
    
    var stats: [MoodStat] {
        MoodAnalyticsService.analyze(transactions: transactions)
    }
    
    var maxSpendMood: MoodStat? {
        stats.first
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. Insight Card
                if let max = maxSpendMood, max.amount > 0 {
                    VStack(spacing: 10) {
                        Image(systemName: MoodAnalyticsService.moodIcon(max.mood))
                            .font(.system(size: 50))
                            .foregroundColor(Color(hex: max.colorHex))
                        
                        Text("情绪消费洞察")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("当您处于 **\(MoodAnalyticsService.moodDisplayName(max.mood))** 状态时\n花钱最多！")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                        
                        Text("总计: \(max.amount.formattedCurrency())")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color(hex: max.colorHex))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.background)
                    .cornerRadius(16)
                    .padding(.horizontal)
                } else {
                    ContentUnavailableView("暂无情绪消费数据", systemImage: "face.smiling")
                        .padding()
                }
                
                // 2. Chart
                if !stats.isEmpty {
                    VStack(alignment: .leading) {
                        Text("情绪支出分布")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        Chart(stats) { stat in
                            BarMark(
                                x: .value("Mood", MoodAnalyticsService.moodDisplayName(stat.mood)),
                                y: .value("Amount", stat.amount)
                            )
                            .foregroundStyle(Color(hex: stat.colorHex))
                        }
                        .frame(height: 250)
                    }
                    .padding()
                    .background(AppTheme.background)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                
                // 3. List
                VStack(spacing: 0) {
                    ForEach(stats) { stat in
                        HStack {
                            Image(systemName: MoodAnalyticsService.moodIcon(stat.mood))
                                .foregroundColor(Color(hex: stat.colorHex))
                                .frame(width: 30)
                            
                            VStack(alignment: .leading) {
                                Text(MoodAnalyticsService.moodDisplayName(stat.mood))
                                    .font(.subheadline)
                                    .bold()
                                Text("\(stat.count) 笔交易")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(stat.amount.formattedCurrency())
                                .font(.callout)
                                .bold()
                        }
                        .padding()
                        Divider()
                    }
                }
                .background(AppTheme.background)
                .cornerRadius(16)
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle("情绪消费报告")
        .background(AppTheme.groupedBackground)
    }
}

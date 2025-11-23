//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

@main
struct MoneyTrackerApp: App {
    // SwiftData 模型容器
    let container: ModelContainer
    
    init() {
        // 配置 SwiftData 模型容器
        let schema = Schema([
            UserSettings.self,
            Account.self,
            Category.self,
            Transaction.self,
            Budget.self,
            Goal.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("无法创建 ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}


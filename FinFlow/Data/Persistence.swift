//
//  Persistence.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftData

/// SwiftData 持久化服务封装
class Persistence {
    static let shared = Persistence()
    
    private init() {}
    
    /// 创建 SwiftData 模型容器
    static func createContainer() -> ModelContainer {
        let schema = Schema([
            Account.self,
            Category.self,
            Transaction.self,
            Budget.self,
            SavingsGoal.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("无法创建 ModelContainer: \(error)")
        }
    }
}



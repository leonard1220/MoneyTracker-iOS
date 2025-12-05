//
//  ModelPreviewData.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 预览数据提供者，用于 SwiftUI Preview
@MainActor
class ModelPreviewData {
    
    /// 创建预览用的 ModelContainer
    static func createPreviewContainer() -> ModelContainer {
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
            isStoredInMemoryOnly: true
        )
        
        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            // 插入预览数据
            let context = container.mainContext
            insertPreviewData(into: context)
            
            return container
        } catch {
            fatalError("无法创建预览 ModelContainer: \(error)")
        }
    }
    
    /// 插入预览数据到上下文
    static func insertPreviewData(into context: ModelContext) {
        // 用户设置
        let settings = UserSettings(
            defaultCurrency: "MYR",
            timezoneIdentifier: "Asia/Kuala_Lumpur",
            firstLaunchAt: Date()
        )
        context.insert(settings)
        
        // 账户
        let cashAccount = Account(
            name: "现金",
            type: .cash,
            balance: 500.00
        )
        
        let bankAccount = Account(
            name: "Maybank 主账户",
            type: .bank,
            balance: 5000.00
        )
        
        let ewalletAccount = Account(
            name: "Touch 'n Go",
            type: .ewallet,
            balance: 100.00
        )
        
        let creditAccount = Account(
            name: "Maybank 信用卡",
            type: .credit,
            balance: -2000.00,
            creditLimit: 10000.00
        )
        
        context.insert(cashAccount)
        context.insert(bankAccount)
        context.insert(ewalletAccount)
        context.insert(creditAccount)
        
        // 分类 - 收入
        let salaryCategory = Category(
            name: "工资",
            type: .income,
            iconName: "dollarsign.circle.fill",
            colorHex: "#4CAF50"
        )
        
        let investmentCategory = Category(
            name: "投资收益",
            type: .income,
            iconName: "chart.line.uptrend.xyaxis",
            colorHex: "#2196F3"
        )
        
        // 分类 - 支出
        let foodCategory = Category(
            name: "餐饮",
            type: .expense,
            iconName: "fork.knife",
            colorHex: "#FF9800"
        )
        
        let transportCategory = Category(
            name: "交通",
            type: .expense,
            iconName: "car.fill",
            colorHex: "#9C27B0"
        )
        
        let shoppingCategory = Category(
            name: "购物",
            type: .expense,
            iconName: "bag.fill",
            colorHex: "#E91E63"
        )
        
        let entertainmentCategory = Category(
            name: "娱乐",
            type: .expense,
            iconName: "gamecontroller.fill",
            colorHex: "#00BCD4"
        )
        
        // 分类 - 转账
        let transferCategory = Category(
            name: "转账",
            type: .transfer,
            iconName: "arrow.left.arrow.right",
            colorHex: "#607D8B"
        )
        
        context.insert(salaryCategory)
        context.insert(investmentCategory)
        context.insert(foodCategory)
        context.insert(transportCategory)
        context.insert(shoppingCategory)
        context.insert(entertainmentCategory)
        context.insert(transferCategory)
        
        // 交易 - 收入
        let salaryTransaction = Transaction(
            amount: 5000.00,
            type: .income,
            date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            remark: "11月工资",
            mood: "happy",
            toAccount: bankAccount,
            category: salaryCategory
        )
        
        let investmentTransaction = Transaction(
            amount: 500.00,
            type: .income,
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            remark: "股票分红",
            mood: "happy",
            toAccount: bankAccount,
            category: investmentCategory
        )
        
        // 交易 - 支出
        let foodTransaction1 = Transaction(
            amount: 25.50,
            type: .expense,
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            remark: "午餐",
            mood: "need",
            fromAccount: cashAccount,
            category: foodCategory
        )
        
        let foodTransaction2 = Transaction(
            amount: 45.00,
            type: .expense,
            date: Date(),
            remark: "晚餐",
            mood: "happy",
            fromAccount: ewalletAccount,
            category: foodCategory
        )
        
        let transportTransaction = Transaction(
            amount: 10.00,
            type: .expense,
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            remark: "地铁",
            mood: "need",
            fromAccount: ewalletAccount,
            category: transportCategory
        )
        
        let shoppingTransaction = Transaction(
            amount: 299.00,
            type: .expense,
            date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
            remark: "买衣服",
            mood: "impulse",
            fromAccount: creditAccount,
            category: shoppingCategory
        )
        
        let entertainmentTransaction = Transaction(
            amount: 80.00,
            type: .expense,
            date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(),
            remark: "看电影",
            mood: "happy",
            fromAccount: bankAccount,
            category: entertainmentCategory
        )
        
        // 交易 - 转账
        let transferTransaction = Transaction(
            amount: 200.00,
            type: .transfer,
            date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            remark: "给朋友转账",
            fromAccount: bankAccount,
            toAccount: ewalletAccount,
            category: transferCategory
        )
        
        context.insert(salaryTransaction)
        context.insert(investmentTransaction)
        context.insert(foodTransaction1)
        context.insert(foodTransaction2)
        context.insert(transportTransaction)
        context.insert(shoppingTransaction)
        context.insert(entertainmentTransaction)
        context.insert(transferTransaction)
        
        // 预算
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        let foodBudget = Budget(
            category: foodCategory,
            month: currentMonth,
            year: currentYear,
            amount: 500.00
        )
        
        let transportBudget = Budget(
            category: transportCategory,
            month: currentMonth,
            year: currentYear,
            amount: 200.00
        )
        
        let shoppingBudget = Budget(
            category: shoppingCategory,
            month: currentMonth,
            year: currentYear,
            amount: 1000.00
        )
        
        context.insert(foodBudget)
        context.insert(transportBudget)
        context.insert(shoppingBudget)
        
        // 储蓄目标
        let vacationGoal = Goal(
            name: "旅行基金",
            targetAmount: 5000.00,
            currentAmount: 2000.00,
            deadline: calendar.date(byAdding: .month, value: 6, to: currentDate)
        )
        
        let emergencyGoal = Goal(
            name: "应急基金",
            targetAmount: 10000.00,
            currentAmount: 5000.00,
            deadline: calendar.date(byAdding: .year, value: 1, to: currentDate)
        )
        
        context.insert(vacationGoal)
        context.insert(emergencyGoal)
        
        // 保存上下文
        try? context.save()
    }
    
    /// 创建示例账户
    static func sampleAccount() -> Account {
        Account(
            name: "Maybank 主账户",
            type: .bank,
            balance: 5000.00
        )
    }
    
    /// 创建示例分类
    static func sampleCategory() -> Category {
        Category(
            name: "餐饮",
            type: .expense,
            iconName: "fork.knife",
            colorHex: "#FF9800"
        )
    }
    
    /// 创建示例交易
    static func sampleTransaction() -> Transaction {
        Transaction(
            amount: 25.50,
            type: .expense,
            date: Date(),
            remark: "午餐",
            mood: "need",
            fromAccount: sampleAccount(),
            category: sampleCategory()
        )
    }
    
    /// 创建示例预算
    static func sampleBudget() -> Budget {
        let calendar = Calendar.current
        let currentDate = Date()
        return Budget(
            category: sampleCategory(),
            month: calendar.component(.month, from: currentDate),
            year: calendar.component(.year, from: currentDate),
            amount: 500.00
        )
    }
    
    /// 创建示例目标
    static func sampleGoal() -> Goal {
        Goal(
            name: "旅行基金",
            targetAmount: 5000.00,
            currentAmount: 2000.00,
            deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date())
        )
    }
}


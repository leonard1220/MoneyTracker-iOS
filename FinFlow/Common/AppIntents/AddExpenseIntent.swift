//
//  AddExpenseIntent.swift
//  FinFlow
//
//  Siri 快捷指令 - 快速记账
//

import AppIntents
import SwiftData

@available(iOS 17.0, *)
struct AddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "记一笔支出"
    static var description = IntentDescription("快速记录一笔支出")
    
    static var openAppWhenRun: Bool = false
    
    @Parameter(title: "金额")
    var amount: Decimal
    
    @Parameter(title: "分类", optionsProvider: CategoryOptionsProvider())
    var category: String?
    
    @Parameter(title: "备注")
    var note: String?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // 获取 ModelContext
        let container = try ModelContainer(for: Transaction.self, Account.self, Category.self)
        let context = ModelContext(container)
        
        // 获取默认账户
        let accountDescriptor = FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)])
        guard let defaultAccount = try context.fetch(accountDescriptor).first else {
            return .result(dialog: "请先在应用中创建账户")
        }
        
        // 查找分类
        var selectedCategory: Category?
        if let categoryName = category {
            let categoryDescriptor = FetchDescriptor<Category>(
                predicate: #Predicate { $0.name == categoryName }
            )
            selectedCategory = try context.fetch(categoryDescriptor).first
        }
        
        // 创建交易
        let transaction = Transaction(
            amount: amount,
            type: .expense,
            date: Date(),
            note: note,
            mood: nil,
            fromAccount: defaultAccount,
            toAccount: nil,
            targetAccount: nil,
            category: selectedCategory
        )
        
        // 保存
        _ = TransactionService.saveTransaction(transaction, context: context)
        
        let message = "已记录支出 RM \(amount)" + (categoryName != nil ? " - \(categoryName!)" : "")
        return .result(dialog: message)
    }
}

@available(iOS 17.0, *)
struct AddIncomeIntent: AppIntent {
    static var title: LocalizedStringResource = "记一笔收入"
    static var description = IntentDescription("快速记录一笔收入")
    
    static var openAppWhenRun: Bool = false
    
    @Parameter(title: "金额")
    var amount: Decimal
    
    @Parameter(title: "分类", optionsProvider: IncomeCategoryOptionsProvider())
    var category: String?
    
    @Parameter(title: "备注")
    var note: String?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let container = try ModelContainer(for: Transaction.self, Account.self, Category.self)
        let context = ModelContext(container)
        
        let accountDescriptor = FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)])
        guard let defaultAccount = try context.fetch(accountDescriptor).first else {
            return .result(dialog: "请先在应用中创建账户")
        }
        
        var selectedCategory: Category?
        if let categoryName = category {
            let categoryDescriptor = FetchDescriptor<Category>(
                predicate: #Predicate { $0.name == categoryName }
            )
            selectedCategory = try context.fetch(categoryDescriptor).first
        }
        
        let transaction = Transaction(
            amount: amount,
            type: .income,
            date: Date(),
            note: note,
            mood: nil,
            fromAccount: nil,
            toAccount: defaultAccount,
            targetAccount: nil,
            category: selectedCategory
        )
        
        _ = TransactionService.saveTransaction(transaction, context: context)
        
        let message = "已记录收入 RM \(amount)" + (categoryName != nil ? " - \(categoryName!)" : "")
        return .result(dialog: message)
    }
}

// MARK: - Category Options Provider
@available(iOS 17.0, *)
struct CategoryOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let container = try ModelContainer(for: Category.self)
        let context = ModelContext(container)
        
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.type == CategoryType.expense },
            sortBy: [SortDescriptor(\.name)]
        )
        
        let categories = try context.fetch(descriptor)
        return categories.map { $0.name }
    }
}

@available(iOS 17.0, *)
struct IncomeCategoryOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let container = try ModelContainer(for: Category.self)
        let context = ModelContext(container)
        
        let descriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.type == CategoryType.income },
            sortBy: [SortDescriptor(\.name)]
        )
        
        let categories = try context.fetch(descriptor)
        return categories.map { $0.name }
    }
}

// MARK: - App Shortcuts Provider
@available(iOS 17.0, *)
struct FinFlowShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddExpenseIntent(),
            phrases: [
                "记一笔支出在 \(.applicationName)",
                "用 \(.applicationName) 记账",
                "在 \(.applicationName) 记录支出"
            ],
            shortTitle: "记支出",
            systemImageName: "arrow.up.right"
        )
        
        AppShortcut(
            intent: AddIncomeIntent(),
            phrases: [
                "记一笔收入在 \(.applicationName)",
                "用 \(.applicationName) 记录收入"
            ],
            shortTitle: "记收入",
            systemImageName: "arrow.down.left"
        )
    }
}

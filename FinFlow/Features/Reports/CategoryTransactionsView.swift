
import SwiftUI
import SwiftData

struct CategoryTransactionsView: View {
    let categoryName: String
    let month: Date
    
    @Query private var transactions: [Transaction]
    @Environment(\.modelContext) private var modelContext
    
    init(categoryName: String, month: Date) {
        self.categoryName = categoryName
        self.month = month
        
        let calendar = Calendar.current
        // Determine date range for the selected month
        let components = calendar.dateComponents([.year, .month], from: month)
        let startOfMonth = calendar.date(from: components)!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        // Construct predicate
        // Note: We are filtering by category NAME as that's what the chart provides.
        // It's safer to use Category ID, but ChartData was built with names.
        let predicate = #Predicate<Transaction> { transaction in
            if let cat = transaction.category {
                return cat.name == categoryName &&
                       transaction.date >= startOfMonth &&
                       transaction.date < endOfMonth
            } else {
                return categoryName == "无分类" && 
                       transaction.date >= startOfMonth &&
                       transaction.date < endOfMonth
            }
        }
        
        _transactions = Query(filter: predicate, sort: \.date, order: .reverse)
    }
    
    var body: some View {
        Group {
            if transactions.isEmpty {
                ContentUnavailableView("无交易记录", systemImage: "list.bullet.clipboard")
            } else {
                List {
                    ForEach(transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                    }
                }
            }
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

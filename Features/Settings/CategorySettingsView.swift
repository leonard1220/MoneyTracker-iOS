//
//  CategorySettingsView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 分类管理视图
struct CategorySettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Category.sortOrder, order: .forward) private var allCategories: [Category]
    
    @State private var selectedType: CategoryType = .expense
    @State private var showAddCategory = false
    @State private var categoryToEdit: Category?
    
    // 过滤当前选定类型的分类
    var filteredCategories: [Category] {
        allCategories.filter { $0.type == selectedType }
    }
    
    var body: some View {
        List {
            Picker("类型", selection: $selectedType) {
                Text("支出").tag(CategoryType.expense)
                Text("收入").tag(CategoryType.income)
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .padding()
            
            ForEach(filteredCategories) { category in
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: category.color ?? "#007AFF").opacity(0.2))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: category.iconName ?? "tag")
                            .foregroundColor(Color(hex: category.color ?? "#007AFF"))
                            .font(.system(size: 16))
                    }
                    
                    Text(category.name)
                        .font(.body)
                    
                    Spacer()
                    
                    if category.isSystem {
                        Text("Default")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(4)
                            .foregroundColor(.secondary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    // 只有用户分类允许编辑（或者允许编辑系统分类的样式但不允许改名/删除？这里简单起见允许编辑）
                    categoryToEdit = category
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if !category.isSystem {
                        Button(role: .destructive) {
                            deleteCategory(category)
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("分类管理")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddCategory = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddCategory) {
            NavigationStack {
                AddEditCategoryView()
            }
        }
        .sheet(item: $categoryToEdit) { category in
            NavigationStack {
                AddEditCategoryView(categoryToEdit: category)
            }
        }
    }
    
    private func deleteCategory(_ category: Category) {
        // 检查是否有关联交易？ (SwiftData Relationship deleteRule: nullify 会自动处理关联)
        // 但为了UX，最好提示用户
        modelContext.delete(category)
    }
}

#Preview {
    NavigationStack {
        CategorySettingsView()
            .modelContainer(ModelPreviewData.createPreviewContainer())
    }
}

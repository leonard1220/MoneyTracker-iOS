//
//  AddEditCategoryView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 添加/编辑分类视图
struct AddEditCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // 编辑模式下的现有分类
    var categoryToEdit: Category?
    
    // 表单状态
    @State private var name: String = ""
    @State private var type: CategoryType = .expense
    @State private var icon: String = "tag"
    @State private var color: String = "#007AFF"
    
    var isEditing: Bool {
        categoryToEdit != nil
    }
    
    var body: some View {
        Form {
            Section("基本信息") {
                TextField("分类名称", text: $name)
                
                if !isEditing {
                    // 仅在创建时允许选择类型，避免逻辑复杂化
                    Picker("类型", selection: $type) {
                        Text("支出").tag(CategoryType.expense)
                        Text("收入").tag(CategoryType.income)
                    }
                    .pickerStyle(.segmented)
                } else {
                    HStack {
                        Text("类型")
                        Spacer()
                        Text(categoryToEdit?.type.rawValue ?? "")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section("图标与颜色") {
                VStack(alignment: .leading) {
                    Text("选择图标")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    IconPickerView(selectedIcon: $icon, colorHex: color)
                }
                
                VStack(alignment: .leading) {
                    Text("选择颜色")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ColorPickerView(selectedColor: $color)
                }
            }
        }
        .navigationTitle(isEditing ? "编辑分类" : "添加分类")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") {
                    saveCategory()
                }
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            if let category = categoryToEdit {
                loadCategoryData(category)
            }
        }
    }
    
    private func loadCategoryData(_ category: Category) {
        name = category.name
        type = category.type
        icon = category.iconName ?? "tag"
        color = category.color ?? "#007AFF"
    }
    
    private func saveCategory() {
        if let category = categoryToEdit {
            // 更新
            category.name = name
            // type 不允许修改
            category.iconName = icon
            category.color = color
        } else {
            // 新增
            let newCategory = Category(
                name: name,
                type: type,
                iconName: icon,
                color: color,
                isSystem: false, // 用户创建的都是非系统分类
                isDefault: false
            )
            modelContext.insert(newCategory)
        }
        
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddEditCategoryView()
            .modelContainer(ModelPreviewData.createPreviewContainer())
    }
}

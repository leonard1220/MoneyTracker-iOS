//
//  CategoriesView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 分类列表视图
struct CategoriesView: View {
    var body: some View {
        Text("Categories")
            .navigationTitle("分类")
    }
}

#Preview {
    NavigationStack {
        CategoriesView()
    }
}


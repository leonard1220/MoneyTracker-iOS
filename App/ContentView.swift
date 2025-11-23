//
//  ContentView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

/// 应用主视图
struct ContentView: View {
    var body: some View {
        TabNavigationView()
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelPreviewData.createPreviewContainer())
}


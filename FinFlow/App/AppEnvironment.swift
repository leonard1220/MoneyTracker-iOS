//
//  AppEnvironment.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI
import SwiftData

/// 应用环境配置
@Observable
class AppEnvironment {
    // 当前选中的 Tab
    var selectedTab: Int = 0
    
    // 是否显示欢迎页
    var showOnboarding: Bool = false
    
    // 可以在这里添加更多全局状态
}


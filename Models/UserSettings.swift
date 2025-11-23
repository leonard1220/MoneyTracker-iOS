//
//  UserSettings.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import Foundation
import SwiftData

/// 用户设置数据模型（仅存储本机设置）
@Model
final class UserSettings {
    var id: UUID
    var defaultCurrency: String
    var timezoneIdentifier: String
    var firstLaunchAt: Date?
    
    init(
        id: UUID = UUID(),
        defaultCurrency: String = "MYR",
        timezoneIdentifier: String = "Asia/Kuala_Lumpur",
        firstLaunchAt: Date? = nil
    ) {
        self.id = id
        self.defaultCurrency = defaultCurrency
        self.timezoneIdentifier = timezoneIdentifier
        self.firstLaunchAt = firstLaunchAt
    }
}


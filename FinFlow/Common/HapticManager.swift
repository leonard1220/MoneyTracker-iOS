//
//  HapticManager.swift
//  FinFlow
//
//  Created on 2025-12-06.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    /// 轻微的点击反馈 (Tab切换, 按钮点击)
    func lightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 中等强度的反馈 (确认操作, 记账)
    func mediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 强烈的反馈 (删除, 错误)
    func heavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 选择变动反馈 (滚动选择器)
    func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// 成功通知反馈
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

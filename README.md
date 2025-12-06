# 🌑 FinFlow – A Minimalist Dark-Themed Personal Finance App (iOS)

A clean, elegant, and modern personal finance tracker built with a premium dark UI, designed to make financial management feel calm, clear, and effortless.

FinFlow 是一款专注于 **极简主义**、**深黑主题**、**霓虹点缀色** 的 iOS 记账应用。  
整个界面采用 “深夜金融交易面板” 视觉风格：

- **纯净深黑背景**
- **紫色点缀主色**
- **清晰、集中的信息层级**
- **沉浸式视觉体验**

旨在让用户以最舒适、零负担的方式记录支出、追踪资产、理解财务健康状况。

---

## ✨ 核心特性（Features）

### 📊 首页 Dashboard
- 当日/当月财务总览
- 快速查看收支趋势
- 暗黑系折线图 & 圆环图
- 最新交易列表

### ⚡ 快捷记账（Quick Add）**NEW!**
**降低记账门槛，让坚持变得轻松！**

- **🚀 3 步快速记账**: 金额 → 分类 → 保存（仅需 5 秒）
- **🎯 快捷金额按钮**: 常用金额一键输入（10, 20, 50, 100...）
- **📸 OCR 票据扫描**: 拍照自动识别金额和商家
- **🗣️ Siri 语音记账**: "嘿 Siri，用 FinFlow 记一笔支出 50 元"
- **📱 长按图标快捷操作**: 主屏幕 3D Touch 快速记账
- **🎨 双模式切换**: 快速模式 + 详细模式自由切换

**多种入口，随时随地记账:**
- Dashboard 快捷按钮
- 主屏幕长按图标
- Siri 语音指令
- 浮动快捷按钮（可选）

### 💸 轻松记录收支（Add Transaction）
- 快速输入金额
- 支持多账户（现金 / 银行卡 / eWallet）
- 可自定义分类
- 备注、日期、标签（如心情）

### 📁 分类与账户管理
- 自定义分类
- 多账户支持

### 📈 高级报表（Reports）
- 月度支出分析
- 分类占比饼图
- 趋势折线图
- 年度统计 (Planning)

### 💎 Premium（高级版）功能
_(开发中 / 将在后续版本推出)_
采用 StoreKit 2，支持：
- 月订阅
- 年订阅
- 一次性终身买断

Premium 解锁以下强力功能：
- ✔ 无限账户
- ✔ 无限分类
- ✔ 无限交易记录
- ✔ 年度报表 / 深度趋势图
- ✔ 数据导出（CSV / PDF）
- ✔ 隐私保护（Face ID / Touch ID 上锁）
- ✔ 未来版本：iCloud 同步
- ✔ 高级主题（可选）

---

## 🎨 设计理念（Design Philosophy）

FinFlow 的 UI 遵循以下视觉体系：

### � Dark Minimalism
- **基础背景**: `#0C0D10`
- **Surface**: `#14161C`
- 内容层级通过亮度差呈现，而不是阴影

### 💜 Singular Accent Color
- **主色**：紫色 `#7B4DFF`
- 少即是多，强调极简、克制、品牌统一性

### � Data-first Visuals
- 图表采用青蓝 (#4BC9FF) + 紫色强调
- 使用沉稳的浅灰文字
- 金额采用等宽字体（monospacedDigit）提升专业感

### 🪶 Motion
- Spring 弹性
- 0.18–0.28s 动画区间
- 不炫技，只营造流畅体验

---

## 🧱 技术栈（Tech Stack）

| 组件 | 描述 |
| --- | --- |
| **SwiftUI** | UI 构建框架 |
| **SwiftData** | 本地数据库管理 |
| **Swift Charts** | 报表图表支持 |
| **StoreKit 2** | 订阅与内购系统 (Planned) |
| **MVVM** | 架构模式 |
| **CloudKit** | 数据同步 (Planned) |

---

## � 项目结构（Project Structure）

```
FinFlow/
│
├─ App/
│   ├─ FinFlowApp.swift
│   └─ AppEnvironment.swift
│
├─ Models/
│   ├─ Account.swift
│   ├─ Category.swift
│   └─ Transaction.swift
│
├─ Features/
│   ├─ Dashboard/
│   ├─ Transactions/ (Add/Listen)
│   ├─ Reports/
│   ├─ Accounts/
│   ├─ DataExport/
│   └─ Settings/
│
├─ Common/
│   ├─ Theme/
│   │    └─ AppTheme.swift (Colors, Typography)
│   ├─ Components/
│   │    ├─ CardBackground.swift
│   │    ├─ PrimaryButton.swift
│   │    └─ NumberTicker.swift
│   └─ Extensions/
```

---

## � Roadmap（开发计划）

### ✅ v0.1 Foundation
- UI 基础框架
- SwiftData 模型
- Dashboard 初版

### ✅ v0.2 Core Features
- Add Transaction
- Accounts / Categories 管理
- 基础报表（三大图表）

### 💎 v0.3 Premium + StoreKit (Upcoming)
- StoreKit 2
- PremiumManager
- 限制免费用户数量
- Premium 付费页

### ☁️ v0.4 Sync
- CloudKit iCloud 同步
- 完整备份 & 恢复系统

### 🎨 v1.0 发布前优化
- 更强 UI 主题支持
- 完整动效系统
- App Store 截图生成
- Logo & App Icon（深黑主题）

---

## 🚀 如何运行（Run the Project）

由于 iOS APP 开发通常需要 Mac，但本项目配置了 **GitHub Actions** 以支持 Windows 用户进行构建。

### 方法 1：GitHub Actions (此项目推荐)
1. Fork 本项目。
2. 只要 Push 代码，GitHub Action 会自动构建 `.ipa`。
3. 从 Actions 页面下载 Artifacts。
4. 使用 Sideloadly 安装到 iPhone。

### 方法 2：MacOS
1. `git clone` 项目。
2. 用 Xcode 打开 `.xcodeproj`。
3. 如果是模拟器，直接 Run。
4. 如果是真机，配置 Signing Team 后 Run。

---

## � License

MIT License

---

## 🙌 贡献（Contributing）

欢迎提交 PR！
也欢迎 Issues（Bug / UI 改进 / 新功能建议）。

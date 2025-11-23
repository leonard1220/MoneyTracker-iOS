# MoneyTracker iOS

一个现代化的原生 iOS 记账应用，使用 SwiftUI + SwiftData + Swift Charts 构建。

## 📱 项目简介

MoneyTracker 是一个功能完整的个人财务管理应用，帮助用户轻松记录和管理日常收支，通过直观的报表和图表了解财务状况。

## ✨ 核心功能

### 已规划功能

- ✅ **账户管理**: 支持现金、银行、电子钱包、信用卡等多种账户类型
- ✅ **分类管理**: 自定义收入和支出分类
- ✅ **交易记录**: 添加、编辑、删除交易记录
- ✅ **报表统计**: 月度统计、分类统计
- ✅ **数据可视化**: 柱状图、饼图展示财务数据
- 🔄 **预算管理**: 预留结构，后续实现
- 🔄 **储蓄目标**: 预留结构，后续实现

## 🛠️ 技术栈

- **UI 框架**: SwiftUI
- **数据持久化**: SwiftData
- **数据可视化**: Swift Charts
- **响应式编程**: Combine
- **架构模式**: MVVM
- **模块化**: Feature-Based 组织

## 📋 系统要求

- **最低版本**: iOS 17.0+
- **推荐设备**: iPhone 12 及以上
- **开发工具**: Xcode 15.0+

> 详细版本要求说明请查看 [IOS_VERSION_REQUIREMENTS.md](./IOS_VERSION_REQUIREMENTS.md)

## 📂 项目结构

项目采用 Feature-Based 模块化架构：

```
MoneyTracker-iOS/
├── MoneyTracker/
│   ├── App/              # 应用入口
│   ├── Core/             # 核心层（Models, Services, Utilities）
│   ├── Features/         # 功能模块
│   │   ├── Accounts/     # 账户管理
│   │   ├── Transactions/ # 交易记录
│   │   ├── Reports/      # 报表统计
│   │   ├── Budget/       # 预算管理（预留）
│   │   └── Settings/     # 设置
│   └── Shared/           # 共享组件
├── MoneyTrackerTests/    # 单元测试
└── MoneyTrackerUITests/  # UI 测试
```

> 详细项目结构请查看 [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md)

## 📖 文档

- [ARCHITECTURE.md](./ARCHITECTURE.md) - 架构设计文档
- [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) - 项目结构说明
- [IOS_VERSION_REQUIREMENTS.md](./IOS_VERSION_REQUIREMENTS.md) - iOS 版本要求说明

## 🚀 开发计划

### Phase 1: 基础架构 ✅
- [x] 项目结构规划
- [x] 架构文档编写
- [ ] 数据模型定义
- [ ] 基础服务层实现
- [ ] 主界面框架

### Phase 2: 核心功能
- [ ] 账户管理
- [ ] 交易记录
- [ ] 分类管理

### Phase 3: 报表功能
- [ ] 月度统计
- [ ] 分类统计
- [ ] 图表实现

### Phase 4: 高级功能
- [ ] 预算管理
- [ ] 储蓄目标
- [ ] 数据导出

### Phase 5: 优化与发布
- [ ] 性能优化
- [ ] UI/UX 优化
- [ ] 测试完善
- [ ] App Store 准备

## 🏗️ 架构设计

### MVVM 模式

- **Model**: SwiftData 数据模型
- **View**: SwiftUI 视图
- **ViewModel**: ObservableObject 类，处理业务逻辑

### 数据流

```
View → ViewModel → Service → ModelContext → SwiftData
  ↑                                              ↓
  ←─────────────── @Published ──────────────────┘
```

### 模块依赖

```
App
  ↓
Features (Accounts, Transactions, Reports, Budget, Settings)
  ↓
Core (Models, Services, Utilities)
  ↓
SwiftData / SwiftUI / Swift Charts
```

## 📊 数据模型

### 核心模型

- **Account**: 账户（现金、银行、电子钱包、信用卡等）
- **Transaction**: 交易记录（收入、支出、转账）
- **Category**: 分类（收入分类、支出分类）
- **Budget**: 预算（预留）
- **SavingsGoal**: 储蓄目标（预留）

> 详细数据模型设计请查看 [ARCHITECTURE.md](./ARCHITECTURE.md)

## 🎨 UI/UX 设计

- **Material Design 风格**: 现代化的卡片式设计
- **深色模式支持**: 完整的深色模式适配
- **无障碍支持**: VoiceOver 和动态字体支持
- **响应式布局**: 适配不同屏幕尺寸

## 🔐 隐私与安全

- 所有数据存储在本地设备
- 不收集用户隐私信息
- 未来可选的端到端加密

## 🧪 测试

- **单元测试**: 核心服务和 ViewModel
- **集成测试**: 数据操作流程
- **UI 测试**: 关键用户流程

## 📝 开发规范

- **代码风格**: 遵循 Swift API 设计指南
- **命名规范**: 使用清晰的描述性命名
- **Git 提交**: 使用语义化提交信息

## 🤝 贡献

本项目正在开发中，欢迎提出建议和反馈。

## 📄 许可证

待定

---

**项目状态**: 🚧 开发中  
**当前版本**: 0.1.0  
**最后更新**: 2024-11-23


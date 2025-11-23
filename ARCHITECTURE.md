# MoneyTracker iOS 架构文档

## 📱 项目概述

MoneyTracker 是一个原生 iOS 记账应用，采用现代化的 Swift 技术栈构建，提供完整的个人财务管理功能。

## 🎯 技术选型

### 核心技术栈

- **SwiftUI**: 声明式 UI 框架，用于构建所有用户界面
- **SwiftData**: 数据持久化框架，替代 Core Data，提供类型安全的数据模型
- **Swift Charts**: 数据可视化框架，用于生成报表图表
- **Combine**: 响应式编程框架，用于数据流管理

### 架构模式

- **MVVM (Model-View-ViewModel)**: 主要架构模式
  - **Model**: SwiftData 数据模型
  - **View**: SwiftUI 视图
  - **ViewModel**: ObservableObject 类，处理业务逻辑和状态管理

- **Feature-Based 模块化**: 按功能模块组织代码
  - Accounts (账户管理)
  - Transactions (交易记录)
  - Reports (报表统计)
  - Budget (预算管理)
  - Settings (设置)

## 📂 项目结构

项目采用 Feature-Based 模块化架构，目录结构如下：

```
MoneyTracker-iOS/
├── App/                                   # 应用入口层
│   ├── MoneyTrackerApp.swift              # App 主入口，配置 SwiftData 容器
│   ├── AppEnvironment.swift               # 应用环境配置（全局状态）
│   └── ContentView.swift                  # 临时主视图（后续替换为 TabNavigationView）
│
├── Models/                                # SwiftData 数据模型
│   ├── Account.swift                      # 账户模型
│   ├── Transaction.swift                  # 交易模型
│   ├── Category.swift                     # 分类模型
│   ├── Budget.swift                       # 预算模型
│   └── SavingsGoal.swift                  # 储蓄目标模型
│
├── Data/                                  # 数据持久化层
│   └── Persistence.swift                  # SwiftData 容器封装
│
├── Features/                              # 功能模块（按业务划分）
│   ├── Dashboard/                         # 仪表盘模块
│   │   ├── DashboardView.swift                # 仪表盘视图
│   │   └── DashboardViewModel.swift         # 仪表盘视图模型
│   │
│   ├── Transactions/                      # 交易记录模块
│   │   ├── TransactionsView.swift           # 交易列表视图
│   │   ├── TransactionsViewModel.swift      # 交易视图模型
│   │   └── AddEditTransactionView.swift      # 添加/编辑交易视图
│   │
│   ├── Accounts/                          # 账户管理模块
│   │   ├── AccountsView.swift               # 账户列表视图
│   │   ├── AccountsViewModel.swift          # 账户视图模型
│   │   └── AddEditAccountView.swift         # 添加/编辑账户视图
│   │
│   ├── Categories/                        # 分类管理模块
│   │   ├── CategoriesView.swift             # 分类列表视图
│   │   └── CategoriesViewModel.swift        # 分类视图模型
│   │
│   ├── Reports/                           # 报表统计模块
│   │   ├── ReportsView.swift                # 报表主视图
│   │   └── ReportsViewModel.swift           # 报表视图模型
│   │
│   ├── BudgetGoals/                       # 预算和目标模块（预留）
│   │   ├── BudgetGoalsView.swift            # 预算和目标视图
│   │   └── BudgetGoalsViewModel.swift       # 预算和目标视图模型
│   │
│   └── Settings/                          # 设置模块
│       ├── SettingsView.swift               # 设置主视图
│       └── SettingsViewModel.swift          # 设置视图模型
│
└── Common/                                # 共享组件和工具
    ├── Components/                        # 可复用 UI 组件
    │   ├── EmptyStateView.swift            # 空状态视图
    │   └── LoadingView.swift               # 加载视图
    │
    ├── Extensions/                        # Swift 类型扩展
    │   ├── Date+Extensions.swift           # 日期扩展
    │   ├── Double+Extensions.swift         # 金额扩展
    │   └── String+Extensions.swift         # 字符串扩展
    │
    └── Theme/                             # 主题配置
        └── AppTheme.swift                  # 应用主题（颜色、字体等）
```

### 目录说明

#### App/
应用入口层，负责：
- 应用生命周期管理
- SwiftData ModelContainer 初始化
- 全局环境配置

#### Models/
所有 SwiftData 数据模型，使用 `@Model` 宏定义：
- `Account`: 账户模型（现金、银行、电子钱包、信用卡等）
- `Transaction`: 交易模型（收入、支出、转账）
- `Category`: 分类模型
- `Budget`: 预算模型（预留）
- `SavingsGoal`: 储蓄目标模型（预留）

#### Data/
数据持久化层：
- `Persistence.swift`: 封装 SwiftData ModelContainer 的创建逻辑

#### Features/
按业务功能划分的模块，每个模块包含：
- **View**: SwiftUI 视图文件
- **ViewModel**: 业务逻辑和状态管理（使用 `@Observable` 宏）

模块列表：
- **Dashboard**: 仪表盘，展示财务概览
- **Transactions**: 交易记录管理
- **Accounts**: 账户管理
- **Categories**: 分类管理
- **Reports**: 报表统计
- **BudgetGoals**: 预算和储蓄目标（预留）
- **Settings**: 应用设置

#### Common/
跨模块共享的组件和工具：
- **Components**: 可复用的 UI 组件
- **Extensions**: Swift 类型扩展（日期、金额、字符串等）
- **Theme**: 应用主题配置（颜色、字体、间距等）

### 架构特点

1. **模块化设计**: 每个 Feature 模块独立，低耦合
2. **MVVM 模式**: View 和 ViewModel 分离，便于测试和维护
3. **代码复用**: Common 层提供共享组件和工具
4. **可扩展性**: 预留 BudgetGoals 模块结构，便于后续扩展

## 🗄️ 数据模型设计

### Account (账户)

```swift
@Model
class Account {
    var id: UUID
    var name: String
    var type: AccountType        // 现金、银行、电子钱包、信用卡
    var balance: Double
    var currency: String          // 货币类型（默认 CNY）
    var icon: String              // 图标名称
    var color: String             // 主题色
    var createdAt: Date
    var updatedAt: Date
    var transactions: [Transaction]? // 关联交易
    
    // 计算属性
    var formattedBalance: String
}
```

### Transaction (交易)

```swift
@Model
class Transaction {
    var id: UUID
    var amount: Double
    var type: TransactionType    // 收入、支出、转账
    var category: Category?
    var account: Account?
    var targetAccount: Account?   // 转账目标账户
    var note: String?
    var date: Date
    var createdAt: Date
    var updatedAt: Date
    
    // 计算属性
    var formattedAmount: String
    var isIncome: Bool
    var isExpense: Bool
    var isTransfer: Bool
}
```

### Category (分类)

```swift
@Model
class Category {
    var id: UUID
    var name: String
    var type: TransactionType    // 收入或支出
    var icon: String
    var color: String
    var isSystem: Bool            // 是否为系统分类
    var isDefault: Bool           // 是否为默认分类
    var sortOrder: Int
    var transactions: [Transaction]?
    var createdAt: Date
}
```

### Budget (预算) - 预留结构

```swift
@Model
class Budget {
    var id: UUID
    var category: Category?
    var amount: Double
    var period: BudgetPeriod      // 月度、年度
    var startDate: Date
    var endDate: Date
    var createdAt: Date
    var updatedAt: Date
    
    // 计算属性
    var spentAmount: Double
    var remainingAmount: Double
    var progress: Double
}
```

### SavingsGoal (储蓄目标) - 预留结构

```swift
@Model
class SavingsGoal {
    var id: UUID
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var targetDate: Date?
    var account: Account?
    var createdAt: Date
    var updatedAt: Date
    
    // 计算属性
    var progress: Double
    var remainingAmount: Double
}
```

## 📱 页面结构

### 主界面 (Tab Navigation)

1. **交易 (Transactions)**
   - 交易列表（按日期分组）
   - 筛选和搜索功能
   - 添加交易按钮

2. **报表 (Reports)**
   - 月度统计概览
   - 分类统计
   - 图表展示（柱状图、饼图）

3. **账户 (Accounts)**
   - 账户列表（卡片式展示）
   - 账户余额总览
   - 账户详情

4. **设置 (Settings)**
   - 分类管理
   - 应用设置
   - 关于页面

### 核心页面流程

```
App Launch
    ↓
TabNavigationView
    ├── TransactionsView
    │   ├── TransactionList
    │   ├── AddEditTransactionView
    │   └── TransactionDetailView
    │
    ├── ReportsView
    │   ├── MonthlyReportView
    │   ├── CategoryReportView
    │   └── ChartView (Bar/Pie)
    │
    ├── AccountsView
    │   ├── AccountList
    │   ├── AddEditAccountView
    │   └── AccountDetailView
    │
    └── SettingsView
        ├── CategorySettingsView
        └── AboutView
```

## 🔧 技术实现细节

### SwiftData 配置

- 使用 `@Model` 宏定义数据模型
- 通过 `ModelContainer` 初始化数据容器
- 使用 `@Query` 在视图中查询数据
- 通过 `ModelContext` 执行增删改查操作

### ViewModel 模式

- 继承 `ObservableObject`
- 使用 `@Published` 属性包装器
- 注入 `ModelContext` 进行数据操作
- 处理业务逻辑和状态管理

### 数据流

```
View → ViewModel → Service → ModelContext → SwiftData
  ↑                                              ↓
  ←─────────────── @Published ──────────────────┘
```

### 图表实现

- 使用 Swift Charts 框架
- `BarChart` 用于月度统计
- `PieChart` 用于分类占比
- 自定义图表样式和交互

## 📊 数据持久化策略

- **本地存储**: SwiftData 自动管理 SQLite 数据库
- **数据迁移**: 使用 SwiftData 的版本迁移机制
- **备份**: 考虑未来集成 iCloud 同步

## 🎨 UI/UX 设计原则

- **Material Design 风格**: 现代化的卡片式设计
- **深色模式支持**: 完整的深色模式适配
- **无障碍支持**: VoiceOver 和动态字体支持
- **响应式布局**: 适配不同屏幕尺寸

## 🔐 安全与隐私

- 所有数据存储在本地设备
- 不收集用户隐私信息
- 未来可选的端到端加密

## 📈 性能优化

- 使用 `@Query` 的 `animation` 参数优化列表更新
- 图表数据缓存和懒加载
- 图片资源优化和缓存

## 🧪 测试策略

- **单元测试**: 核心服务和 ViewModel
- **集成测试**: 数据操作流程
- **UI 测试**: 关键用户流程

## 📱 系统要求

### 推荐最低版本：iOS 17.0+

**原因：**

1. **SwiftData 支持**: SwiftData 是 iOS 17+ 引入的新框架，提供现代化的数据持久化解决方案
2. **Swift Charts**: Swift Charts 在 iOS 16+ 可用，但 iOS 17+ 有更好的性能和功能
3. **SwiftUI 改进**: iOS 17+ 对 SwiftUI 有重大改进，包括更好的动画、导航和性能优化
4. **开发效率**: 使用最新的 API 可以简化开发，减少兼容性代码
5. **未来兼容性**: 选择 iOS 17+ 可以确保应用能够使用未来几年的新特性

### 目标设备

- iPhone: iPhone 12 及以上（推荐）
- iPad: 支持 iPadOS 17+（可选，未来扩展）

## 🚀 开发计划

### Phase 1: 基础架构 (当前阶段)
- [x] 项目结构规划
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

## 📝 开发规范

- **代码风格**: 遵循 Swift API 设计指南
- **命名规范**: 使用清晰的描述性命名
- **注释**: 关键逻辑添加注释
- **Git 提交**: 使用语义化提交信息

---

**文档版本**: 1.0  
**最后更新**: 2024-11-23  
**维护者**: iOS 开发团队


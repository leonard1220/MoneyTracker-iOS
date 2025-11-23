# MoneyTracker iOS 项目结构说明

## 📁 详细目录结构

### 根目录
```
MoneyTracker-iOS/
├── MoneyTracker/              # 主应用目录
├── MoneyTrackerTests/         # 单元测试
├── MoneyTrackerUITests/       # UI 测试
├── ARCHITECTURE.md            # 架构文档
├── PROJECT_STRUCTURE.md       # 项目结构文档（本文件）
├── README.md                  # 项目说明
└── .gitignore                 # Git 忽略文件
```

## 🎯 模块划分原则

### 1. App 层
**位置**: `MoneyTracker/App/`

**职责**: 
- 应用入口和生命周期管理
- 全局配置初始化
- SwiftData ModelContainer 初始化

**文件**:
- `MoneyTrackerApp.swift`: App 主入口，配置 SwiftData 容器
- `AppDelegate.swift`: 如需要处理系统事件

### 2. Core 层
**位置**: `MoneyTracker/Core/`

**职责**: 
- 数据模型定义（SwiftData Models）
- 核心业务服务
- 通用工具和扩展
- 资源文件

#### 2.1 Models (`Core/Models/`)
所有 SwiftData 数据模型，使用 `@Model` 宏：
- `Account.swift`: 账户模型
- `Transaction.swift`: 交易模型
- `Category.swift`: 分类模型
- `Budget.swift`: 预算模型（预留）
- `SavingsGoal.swift`: 储蓄目标模型（预留）

#### 2.2 Services (`Core/Services/`)
业务逻辑服务层，处理数据操作：
- `DataService.swift`: SwiftData 基础操作封装
- `AccountService.swift`: 账户相关业务逻辑
- `TransactionService.swift`: 交易相关业务逻辑
- `ReportService.swift`: 报表统计业务逻辑

#### 2.3 Utilities (`Core/Utilities/`)
工具类和扩展：
- `Extensions/`: Swift 类型扩展
  - `Date+Extensions.swift`: 日期格式化、计算
  - `Double+Extensions.swift`: 金额格式化
  - `String+Extensions.swift`: 字符串工具
- `Constants.swift`: 应用常量（颜色、尺寸等）
- `Formatters.swift`: 格式化工具（货币、日期等）

#### 2.4 Resources (`Core/Resources/`)
- `Assets.xcassets/`: 图片、图标资源
- `Localizable.strings`: 多语言支持（如需要）

### 3. Features 层
**位置**: `MoneyTracker/Features/`

**职责**: 
- 按功能模块组织代码
- 每个模块包含 Models、ViewModels、Views、Components
- 模块间低耦合，高内聚

#### 3.1 Accounts 模块 (`Features/Accounts/`)
账户管理功能：

**Models**:
- `AccountType.swift`: 账户类型枚举（现金、银行、电子钱包、信用卡等）

**ViewModels**:
- `AccountsViewModel.swift`: 账户列表、添加、编辑、删除逻辑

**Views**:
- `AccountsView.swift`: 账户列表主视图
- `AccountDetailView.swift`: 账户详情（显示交易历史）
- `AddEditAccountView.swift`: 添加/编辑账户表单

**Components**:
- `AccountCardView.swift`: 账户卡片组件（可复用）

#### 3.2 Transactions 模块 (`Features/Transactions/`)
交易记录功能：

**Models**:
- `TransactionType.swift`: 交易类型枚举（收入、支出、转账）
- `TransactionFilter.swift`: 筛选器模型

**ViewModels**:
- `TransactionsViewModel.swift`: 交易列表、筛选、搜索逻辑

**Views**:
- `TransactionsView.swift`: 交易列表主视图（按日期分组）
- `TransactionDetailView.swift`: 交易详情
- `AddEditTransactionView.swift`: 添加/编辑交易表单

**Components**:
- `TransactionRowView.swift`: 交易行组件
- `TransactionFormView.swift`: 交易表单组件（金额、分类、账户选择等）

#### 3.3 Reports 模块 (`Features/Reports/`)
报表统计功能：

**Models**:
- `ReportPeriod.swift`: 报表周期枚举（日、周、月、年）
- `ChartData.swift`: 图表数据模型

**ViewModels**:
- `ReportsViewModel.swift`: 报表数据计算、图表数据准备

**Views**:
- `ReportsView.swift`: 报表主视图
- `MonthlyReportView.swift`: 月度报表详情
- `CategoryReportView.swift`: 分类报表详情
- `ChartView.swift`: 图表容器视图

**Components**:
- `BarChartView.swift`: 柱状图组件（使用 Swift Charts）
- `PieChartView.swift`: 饼图组件（使用 Swift Charts）
- `ReportSummaryCard.swift`: 报表摘要卡片

#### 3.4 Budget 模块 (`Features/Budget/`)
预算管理功能（预留，后续实现）：

**Models**:
- `BudgetPeriod.swift`: 预算周期枚举

**ViewModels**:
- `BudgetViewModel.swift`: 预算管理逻辑

**Views**:
- `BudgetView.swift`: 预算列表
- `AddEditBudgetView.swift`: 添加/编辑预算

#### 3.5 Settings 模块 (`Features/Settings/`)
设置功能：

**ViewModels**:
- `SettingsViewModel.swift`: 设置相关逻辑

**Views**:
- `SettingsView.swift`: 设置主视图
- `CategorySettingsView.swift`: 分类管理（添加、编辑、删除分类）
- `AboutView.swift`: 关于页面

**Components**:
- `SettingsRowView.swift`: 设置行组件

### 4. Shared 层
**位置**: `MoneyTracker/Shared/`

**职责**: 
- 跨模块共享的组件和工具
- 基础 ViewModel
- 通用 UI 组件

#### 4.1 Components (`Shared/Components/`)
可复用的 UI 组件：

**Navigation**:
- `TabNavigationView.swift`: Tab 导航容器

**Forms**:
- `CurrencyTextField.swift`: 金额输入框（带格式化）
- `DatePickerView.swift`: 日期选择器组件

**UI**:
- `EmptyStateView.swift`: 空状态视图（无数据时显示）
- `LoadingView.swift`: 加载指示器
- `ErrorView.swift`: 错误提示视图

#### 4.2 ViewModels (`Shared/ViewModels/`)
- `BaseViewModel.swift`: 基础 ViewModel 类（如需要共享逻辑）

## 📦 文件命名规范

### Swift 文件
- **View**: 以 `View` 结尾，如 `AccountsView.swift`
- **ViewModel**: 以 `ViewModel` 结尾，如 `AccountsViewModel.swift`
- **Model**: 使用单数形式，如 `Account.swift`
- **Service**: 以 `Service` 结尾，如 `AccountService.swift`
- **Component**: 以组件类型结尾，如 `AccountCardView.swift`
- **Extension**: 格式为 `Type+ExtensionName.swift`，如 `Date+Extensions.swift`

### 资源文件
- 图片：使用描述性名称，如 `icon_cash.png`
- 颜色：在 Assets 中定义，如 `primaryColor`

## 🔗 模块依赖关系

```
App
  ↓
Features (Accounts, Transactions, Reports, Budget, Settings)
  ↓
Core (Models, Services, Utilities)
  ↓
SwiftData / SwiftUI / Swift Charts
```

**依赖规则**:
- Features 可以依赖 Core 和 Shared
- Features 之间不直接依赖（通过 Core 层通信）
- Shared 可以依赖 Core
- Core 不依赖 Features 和 Shared

## 📝 代码组织最佳实践

### 1. 单一职责原则
每个文件只负责一个明确的功能。

### 2. 模块化设计
功能相关的代码放在同一个模块内，减少跨模块依赖。

### 3. 可复用性
通用组件放在 Shared 层，避免重复代码。

### 4. 测试友好
ViewModel 和 Service 层易于单元测试，View 层易于 UI 测试。

### 5. 可扩展性
预留 Budget 和 SavingsGoal 模块结构，便于后续扩展。

## 🚀 开发工作流

### 添加新功能
1. 在对应的 Feature 模块下创建文件
2. 如需要新的数据模型，在 `Core/Models/` 添加
3. 如需要新的服务，在 `Core/Services/` 添加
4. 如需要共享组件，在 `Shared/Components/` 添加

### 添加新模块
1. 在 `Features/` 下创建新模块文件夹
2. 按照 Models/ViewModels/Views/Components 结构组织
3. 在 `TabNavigationView` 或相应位置添加导航

## 📊 文件统计（预估）

- **Models**: ~5 个文件
- **Services**: ~4 个文件
- **ViewModels**: ~6 个文件
- **Views**: ~15 个文件
- **Components**: ~12 个文件
- **Utilities**: ~5 个文件
- **总计**: ~47 个 Swift 文件

---

**文档版本**: 1.0  
**最后更新**: 2024-11-23


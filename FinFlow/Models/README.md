# 数据模型说明

本文档说明 MoneyTracker 应用的所有 SwiftData 数据模型。

## 📦 模型列表

### 1. UserSettings
用户设置模型（仅存储本机设置，不做真正多用户）

**字段**:
- `id: UUID` - 唯一标识符
- `defaultCurrency: String` - 默认货币（默认 "MYR"）
- `timezoneIdentifier: String` - 时区标识（默认 "Asia/Kuala_Lumpur"）
- `firstLaunchAt: Date?` - 首次启动时间

**文件**: `UserSettings.swift`

---

### 2. Account
账户模型

**字段**:
- `id: UUID` - 唯一标识符
- `name: String` - 账户名称（如：Maybank 主账户）
- `type: AccountType` - 账户类型（cash / bank / ewallet / credit / loan）
- `balance: Decimal` - 账户余额
- `creditLimit: Decimal?` - 信用额度（仅信用卡/贷款类型）
- `createdAt: Date` - 创建时间

**关系**:
- `fromTransactions: [Transaction]?` - 从该账户转出的交易
- `toTransactions: [Transaction]?` - 转入该账户的交易

**文件**: `Account.swift`

**相关枚举**: `AccountType.swift`

---

### 3. Category
分类模型

**字段**:
- `id: UUID` - 唯一标识符
- `name: String` - 分类名称
- `type: CategoryType` - 分类类型（income / expense / transfer）
- `iconName: String?` - 图标名称
- `colorHex: String?` - 颜色十六进制值
- `createdAt: Date` - 创建时间

**关系**:
- `transactions: [Transaction]?` - 属于该分类的交易

**文件**: `Category.swift`

**相关枚举**: `CategoryType.swift`

---

### 4. Transaction
交易模型

**字段**:
- `id: UUID` - 唯一标识符
- `amount: Decimal` - 交易金额
- `type: TransactionType` - 交易类型（income / expense / transfer）
- `date: Date` - 交易日期
- `remark: String?` - 备注
- `mood: String?` - 心情（happy / stressed / impulse / need）
- `fromAccount: Account?` - 转出账户（支出/转账）
- `toAccount: Account?` - 转入账户（收入/转账）
- `category: Category?` - 分类
- `createdAt: Date` - 创建时间

**文件**: `Transaction.swift`

**相关枚举**: `TransactionType.swift`

---

### 5. Budget
预算模型

**字段**:
- `id: UUID` - 唯一标识符
- `category: Category?` - 关联分类
- `month: Int` - 月份（1-12）
- `year: Int` - 年份
- `amount: Decimal` - 预算金额

**文件**: `Budget.swift`

---

### 6. Goal
储蓄目标模型

**字段**:
- `id: UUID` - 唯一标识符
- `name: String` - 目标名称
- `targetAmount: Decimal` - 目标金额
- `currentAmount: Decimal` - 当前金额
- `deadline: Date?` - 截止日期
- `createdAt: Date` - 创建时间

**文件**: `Goal.swift`

---

## 📋 枚举类型

### AccountType
账户类型枚举

**值**:
- `cash` - 现金
- `bank` - 银行
- `ewallet` - 电子钱包
- `credit` - 信用卡
- `loan` - 贷款

**文件**: `AccountType.swift`

---

### CategoryType
分类类型枚举

**值**:
- `income` - 收入
- `expense` - 支出
- `transfer` - 转账

**文件**: `CategoryType.swift`

---

### TransactionType
交易类型枚举

**值**:
- `income` - 收入
- `expense` - 支出
- `transfer` - 转账

**文件**: `TransactionType.swift`

---

## 🔧 技术细节

### 数据类型选择

- **金额字段使用 `Decimal`**: 更精确的金额计算，避免浮点数精度问题
- **日期字段使用 `Date`**: 标准日期时间类型
- **可选字段使用 `?`**: 允许为空值

### SwiftData 关系

- 使用 `@Relationship` 定义模型间的关系
- `deleteRule: .nullify` 确保删除时不会级联删除关联数据
- 双向关系通过 `inverse` 参数定义

### 默认值构造函数

所有模型都提供了带默认值的构造函数，方便创建实例：

```swift
let account = Account(
    name: "Maybank 主账户",
    type: .bank,
    balance: 5000.00
)
```

---

## 📊 预览数据

`ModelPreviewData.swift` 提供了预览数据功能，用于 SwiftUI Preview：

- `createPreviewContainer()` - 创建包含预览数据的 ModelContainer
- `insertPreviewData(into:)` - 插入预览数据到上下文
- `sampleAccount()` - 创建示例账户
- `sampleCategory()` - 创建示例分类
- `sampleTransaction()` - 创建示例交易
- `sampleBudget()` - 创建示例预算
- `sampleGoal()` - 创建示例目标

### 使用示例

```swift
#Preview {
    let container = ModelPreviewData.createPreviewContainer()
    return TransactionsView()
        .modelContainer(container)
}
```

---

## 📝 文件清单

```
Models/
├── AccountType.swift          # 账户类型枚举
├── CategoryType.swift         # 分类类型枚举
├── TransactionType.swift      # 交易类型枚举
├── UserSettings.swift         # 用户设置模型
├── Account.swift              # 账户模型
├── Category.swift             # 分类模型
├── Transaction.swift          # 交易模型
├── Budget.swift               # 预算模型
├── Goal.swift                 # 储蓄目标模型
├── ModelPreviewData.swift     # 预览数据提供者
└── README.md                  # 本文件
```

---

**最后更新**: 2024-11-23


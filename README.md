# FinFlow (iOS Money Tracker)

**FinFlow** is a modern, privacy-focused personal finance tracker built natively for iOS using **SwiftUI** and **SwiftData**.

It allows users to track expenses, manage accounts, analyze spending with charts, and set budget goals—all without needing an internet connection (Offline-First).

> **Note**: This project includes a fully automated **CI/CD pipeline** that allows **Windows users** to build the iOS app using GitHub Actions without needing a Mac.

---

## 📱 Features

### 1. 📊 Dashboard & Analytics
- **Real-time Overview**: Live total balance with smooth counting animations.
- **Monthly Reports**: Visual Pie Charts and Bar Charts showing where your money goes.
- **Trend Analysis**: Compare income vs. expense for the current month.

### 2. 💰 Core Management
- **Transactions**: Fast logging of Income, Expense, and Transfers.
- **Accounts**: Manage multiple asset types (Cash, Bank, Credit Card).
- **Categories**: Custom icons and colors for every spending category.

### 3. 🎯 Planning & Goals
- **Budgets**: Set monthly spending limits (Global or Category-specific) and track progress (Green/Orange/Red indicators).
- **Savings Goals**: Create visualization targets for big purchases (e.g., "New Car") and track deposits.

### 4. 🔒 Data & Export
- **Data Privacy**: All data is stored locally on-device using **SwiftData**.
- **Export**: Export all transaction records to **CSV** for analysis in Excel or Numbers.

---

## 🛠 Tech Stack

- **Lanuage**: Swift 5.10+
- **Framework**: SwiftUI (MVVM Architecture)
- **Database**: SwiftData
- **Charts**: Swift Charts
- **Minimum Target**: iOS 16.0

---

## 🚀 Installation (For Windows Users)

Since we don't have a Mac, we use **GitHub Actions** to build the app in the cloud.

### Step 1: Download
1. Go to the **Actions** tab in this repository.
2. Click on the latest successful workflow run (Green Checkmark).
3. Scroll down to **Artifacts** and download `FinFlow-Unsigned-IPA`.

### Step 2: Install on iPhone/iPad
1. Download [Sideloadly](https://sideloadly.io/) on your PC.
2. Connect your device via USB.
3. Drag the `FinFlow.ipa` file into Sideloadly.
4. Enter your Apple ID (to sign the app for 7 days) and click **Start**.
5. On your iPhone, go to **Settings > General > VPN & Device Management** and "Trust" your email to run the app.

---

## 📂 Project Structure

The project was restructured for modularity:

```
FinFlow/
├── App/                # Entry point & Global Environment
├── Features/           # Core Feature Modules
│   ├── Dashboard/      # Home Screen
│   ├── Transactions/   # Add/List Transactions
│   ├── Accounts/       # Account Management
│   ├── Reports/        # Charts & Analytics
│   ├── BudgetGoals/    # Budgets & Savings
│   └── Settings/       # App Settings
├── Models/             # SwiftData Models (Schema)
├── Common/             # Reusable UI Components & Helpers
└── Assets.xcassets/    # Icons & Colors
```

---

## 📜 License

MIT License. Free for personal use.

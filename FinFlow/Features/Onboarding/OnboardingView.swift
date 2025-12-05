//
//  OnboardingView.swift
//  FinFlow
//
//  Created on 2024-12-06.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @Environment(\.modelContext) private var modelContext
    @Environment(UserSettings.self) private var userSettings
    
    @State private var currentPage = 0
    @State private var selectedLanguage = "zh-Hans" 
    @State private var selectedCurrency = "CNY"
    
    // First Account Data
    @State private var initialAccountName = "现金钱包"
    @State private var initialBalance = "0"
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button("跳过") {
                        completeOnboarding()
                    }
                    .foregroundColor(.secondary)
                    .padding()
                    .opacity(currentPage == 3 ? 0 : 1)
                }
                
                TabView(selection: $currentPage) {
                    // Page 1: Welcome & Language
                    VStack(spacing: 30) {
                        Image(systemName: "globe")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.primary)
                        
                        Text("欢迎使用 FinFlow")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("请选择您的语言\nPlease select your language")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 20) {
                            LanguageButton(title: "中文", isSelected: selectedLanguage == "zh-Hans") {
                                selectedLanguage = "zh-Hans"
                            }
                            
                            LanguageButton(title: "English", isSelected: selectedLanguage == "en") {
                                selectedLanguage = "en"
                            }
                        }
                        .padding(.top)
                    }
                    .tag(0)
                    
                    // Page 2: Design Philosophy
                    VStack(spacing: 30) {
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.yellow)
                        
                        Text("专注暗黑模式")
                            .font(.title)
                            .bold()
                        
                        Text("FinFlow 默认采用深色设计，保护视力，专注记账。")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .tag(1)
                    
                // Page 3: Currency & First Account
                    VStack(spacing: 30) {
                        Image(systemName: "wallet.pass.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.accent)
                        
                        Text("偏好设置")
                            .font(.title)
                            .bold()
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("选择货币")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                ForEach(["CNY", "USD", "EUR", "JPY"], id: \.self) { curr in
                                    Button {
                                        selectedCurrency = curr
                                    } label: {
                                        Text(curr)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(selectedCurrency == curr ? AppTheme.primary : AppTheme.background)
                                            .foregroundColor(selectedCurrency == curr ? .white : .primary)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(AppTheme.primary.opacity(0.3), lineWidth: 1)
                                            )
                                    }
                                }
                            }

                            Divider().padding(.vertical, 5)

                            Text("首个账户名称")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("例如：现金", text: $initialAccountName)
                                .textFieldStyle(.roundedBorder)
                            
                            Text("初始余额")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            TextField("0.00", text: $initialBalance)
                                .keyboardType(.decimalPad) // Use decimalPad directly
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                        .background(AppTheme.groupedBackground)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .tag(2)
                    
                    // Page 4: Ready
                    VStack(spacing: 30) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        
                        Text("准备就绪")
                            .font(.title)
                            .bold()
                        
                        Text("开始您的记账之旅吧！\n点击下方按钮进入首页。")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button {
                            createInitialAccount()
                            completeOnboarding()
                        } label: {
                            Text("开始使用")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.primary)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                    }
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                
                // Navigation Buttons (Next)
                if currentPage < 3 {
                    Button {
                        withAnimation {
                            currentPage += 1
                        }
                    } label: {
                        Text("下一步")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func createInitialAccount() {
        let balance = Decimal(string: initialBalance) ?? 0
        let account = Account(
            name: initialAccountName.isEmpty ? "现金" : initialAccountName,
            type: .cash,
            balance: balance,
            currency: selectedCurrency == "CNY" ? "CNY" : selectedCurrency, // Simple logic
            color: "#4CAF50"
        )
        modelContext.insert(account)
    }
    
    private func completeOnboarding() {
        // Save Language Preference
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        
        // Save Currency Preference
        let symbol = selectedCurrency == "CNY" ? "¥" : (selectedCurrency == "USD" ? "$" : (selectedCurrency == "EUR" ? "€" : (selectedCurrency == "JPY" ? "¥" : "¥")))
        userSettings.currencySymbol = symbol
        
        UserDefaults.standard.synchronize()
        
        // Mark as completed
        hasCompletedOnboarding = true
    }
}

struct LanguageButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .bold()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? AppTheme.primary : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

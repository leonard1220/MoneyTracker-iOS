import SwiftUI
import SwiftData

@main
struct FinFlowApp: App {
    // Global App Environment
    @State private var appEnvironment = AppEnvironment()
    @State private var premiumManager = PremiumManager()
    @State private var userSettings = UserSettings()
    
    // SwiftData Container
    let container: ModelContainer
    
    // Quick Action Handler
    @State private var quickActionToPerform: QuickAction?
    
    init() {
        let schema = Schema([
            Account.self,
            Category.self,
            Transaction.self,
            Budget.self,
            SavingsGoal.self,
            Subscription.self,
            DailyBalanceSnapshot.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
            // Seed Default Categories
            CategorySeeder.seedDefaultCategories(modelContext: container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        // Setup Quick Actions
        setupQuickActions()
    }
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView(isActive: $showSplash)
                        .transition(.opacity)
                        .zIndex(1) // 确保在最上层
                } else {
                    Group {
                        if hasCompletedOnboarding {
                            TabNavigationView()
                                .environment(appEnvironment)
                                .environment(premiumManager)
                                .environment(userSettings)
                                .environment(\.quickActionToPerform, $quickActionToPerform)
                                .modelContainer(container)
                                .onAppear {
                                    BalanceSnapshotService.takeSnapshot(modelContext: container.mainContext)
                                }
                        } else {
                            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                                .environment(userSettings)
                                .modelContainer(container)
                        }
                    }
                    .transition(.opacity)
                    .zIndex(0)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showSplash)
            .preferredColorScheme(.dark) // 1. Default Dark Mode
            .onOpenURL { url in
                handleQuickAction(from: url)
            }
        }
    }
    
    // MARK: - Quick Actions Setup
    private func setupQuickActions() {
        let addExpense = UIApplicationShortcutItem(
            type: "com.finflow.addExpense",
            localizedTitle: "记支出",
            localizedSubtitle: "快速记录一笔支出",
            icon: UIApplicationShortcutIcon(systemImageName: "arrow.up.right"),
            userInfo: nil
        )
        
        let addIncome = UIApplicationShortcutItem(
            type: "com.finflow.addIncome",
            localizedTitle: "记收入",
            localizedSubtitle: "快速记录一笔收入",
            icon: UIApplicationShortcutIcon(systemImageName: "arrow.down.left"),
            userInfo: nil
        )
        
        let scanReceipt = UIApplicationShortcutItem(
            type: "com.finflow.scanReceipt",
            localizedTitle: "扫描票据",
            localizedSubtitle: "拍照识别收据",
            icon: UIApplicationShortcutIcon(systemImageName: "doc.text.viewfinder"),
            userInfo: nil
        )
        
        UIApplication.shared.shortcutItems = [addExpense, addIncome, scanReceipt]
    }
    
    // MARK: - Handle Quick Actions
    private func handleQuickAction(from url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let action = components.host else {
            return
        }
        
        switch action {
        case "addExpense":
            quickActionToPerform = .addExpense
        case "addIncome":
            quickActionToPerform = .addIncome
        case "scanReceipt":
            quickActionToPerform = .scanReceipt
        default:
            break
        }
    }
}

// MARK: - Quick Action Types
enum QuickAction {
    case addExpense
    case addIncome
    case scanReceipt
}

// MARK: - Environment Key for Quick Actions
private struct QuickActionKey: EnvironmentKey {
    static let defaultValue: Binding<QuickAction?> = .constant(nil)
}

extension EnvironmentValues {
    var quickActionToPerform: Binding<QuickAction?> {
        get { self[QuickActionKey.self] }
        set { self[QuickActionKey.self] = newValue }
    }
}

// MARK: - Haptic Manager (Merged)
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func lightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func mediumImpact() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func heavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}

// MARK: - Splash View (Merged)
struct SplashView: View {
    @Binding var isActive: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var showText = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0C0D10").ignoresSafeArea()
            
            VStack {
                ZStack {
                    Circle()
                        .fill(AppTheme.primary)
                        .frame(width: 120, height: 120)
                        .blur(radius: 60)
                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppTheme.accent)
                        .frame(width: 100, height: 100)
                        .blur(radius: 50)
                        .offset(x: 30, y: -30)
                        .scaleEffect(size)
                        .opacity(opacity * 0.8)
                    
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: AppTheme.primary.opacity(0.8), radius: 20, x: 0, y: 0)
                }
                .scaleEffect(size)
                
                if showText {
                    VStack(spacing: 8) {
                        Text("FinFlow")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: AppTheme.primary.opacity(0.5), radius: 10)
                        
                        Text("Financial Flow in Dark")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                            .letterSpacing(2)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .padding(.top, 30)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                size = 1.1
                opacity = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showText = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isActive = false
                }
            }
        }
    }
}

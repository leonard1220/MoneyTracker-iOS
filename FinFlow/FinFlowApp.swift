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

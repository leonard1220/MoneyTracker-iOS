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
    
    init() {
        let schema = Schema([
            UserSettings.self,
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
    }
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    TabNavigationView()
                        .environment(appEnvironment)
                        .environment(premiumManager)
                        .environment(userSettings)
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
            .preferredColorScheme(.dark) // 1. Default Dark Mode
        }
    }
}

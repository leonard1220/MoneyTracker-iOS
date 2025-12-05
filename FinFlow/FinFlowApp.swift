import SwiftUI
import SwiftData

@main
struct FinFlowApp: App {
    // Global App Environment
    @State private var appEnvironment = AppEnvironment()
    
    // SwiftData Container
    let container: ModelContainer
    
    init() {
        let schema = Schema([
            UserSettings.self,
            Account.self,
            Category.self,
            Transaction.self,
            Budget.self,
            SavingsGoal.self
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
                        .modelContainer(container)
                } else {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .modelContainer(container)
                }
            }
            .preferredColorScheme(.dark) // 1. Default Dark Mode
        }
    }
}

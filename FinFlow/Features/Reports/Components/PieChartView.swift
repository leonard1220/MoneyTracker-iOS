
import SwiftUI
import Charts

struct ChartData: Identifiable, Equatable {
    let id = UUID()
    let category: String
    let amount: Decimal
    let color: Color
}

struct PieChartView: View {
    let data: [ChartData]
    let totalAmount: Decimal // For center text
    let typeTitle: String // "支出" or "收入"
    
    @State private var selectedAngle: Double?
    
    // Neon Palette for fallback or enhancement
    private let neons = [
        Color(hex: "#FF00FF"), // Magenta
        Color(hex: "#00FFFF"), // Cyan
        Color(hex: "#FFFF00"), // Yellow
        Color(hex: "#FF4500"), // OrangeRed
        Color(hex: "#7B4DFF"), // Purple
        Color(hex: "#32CD32")  // Lime
    ]
    
    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) {
                Chart(data) { item in
                    SectorMark(
                        angle: .value("Amount", item.amount),
                        innerRadius: .ratio(0.65), // Thinner donut
                        outerRadius: selectedAngle != nil ? .ratio(1.0) : .ratio(0.95), // Hover effect
                        angularInset: 2.0 // Gaps between slices
                    )
                    .cornerRadius(6)
                    .foregroundStyle(item.color.gradient) // Gradient for depth
                    .shadow(color: item.color.opacity(0.5), radius: 5, x: 0, y: 0) // Neon glow
                    
                    // Optional: Custom sorting or annotation
                }
                .chartBackground { proxy in
                    GeometryReader { geo in
                        VStack(spacing: 4) {
                            Text(typeTitle)
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(totalAmount.formattedCurrency())
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primary)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                .chartLegend(position: .bottom, alignment: .center, spacing: 20)
                
            } else {
                // Fallback for older iOS
                Chart(data) { item in
                    BarMark(
                        x: .value("Amount", item.amount),
                        y: .value("Category", item.category)
                    )
                    .foregroundStyle(item.color)
                }
            }
        }
    }
}


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
    @Binding var selectedCategory: String?
    
    @State private var selectedAngle: Double? // For visual highlight only (Drag)
    
    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) {
                Chart(data) { item in
                    SectorMark(
                        angle: .value("Amount", item.amount),
                        innerRadius: .ratio(0.65), 
                        outerRadius: selectedAngle != nil ? .ratio(1.0) : .ratio(0.95),
                        angularInset: 2.0
                    )
                    .cornerRadius(6)
                    .foregroundStyle(item.color.gradient)
                    .shadow(color: item.color.opacity(0.5), radius: 5, x: 0, y: 0)
                }
                .chartBackground { proxy in
                    GeometryReader { geo in
                        // Center Text
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
                        
                        // Tap Gesture Layer
                        // Note: We place this AFTER text so it's on top of Z-Order if needed,
                        // but chartBackground is behind marks?
                        // No, chartBackground is behind. chartOverlay is in front.
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .onTapGesture { location in
                                handleTap(at: location, in: geo.size)
                            }
                    }
                }
                .chartLegend(position: .bottom, alignment: .center, spacing: 20)
                // We are NOT using chartAngleSelection for Navigation, 
                // but we could use it for visual helper if desired.
                // .chartAngleSelection(value: $selectedAngle) 
                
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
    
    // Tap Logic
    private func handleTap(at location: CGPoint, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let dx = location.x - center.x
        let dy = location.y - center.y
        
        // Calculate angle from 3 o'clock (0 rad)
        var angle = atan2(dy, dx)
        
        // Rotate to match Chart (12 o'clock = 0)
        // Chart starts 12 o'clock and goes clockwise.
        // atan2:
        // 3 o'clock = 0
        // 6 o'clock = pi/2
        // 9 o'clock = pi
        // 12 o'clock = -pi/2
        
        // We want 12 o'clock to be start (0).
        // So we add pi/2 to angle.
        angle += .pi / 2
        
        // Normalize
        if angle < 0 { angle += 2 * .pi }
        
        let total = data.reduce(0) { $0 + Double(truncating: $1.amount as NSNumber) }
        guard total > 0 else { return }
        
        let value = total * (angle / (2 * .pi))
        
        var currentStart = 0.0
        for item in data {
            let itemAmount = Double(truncating: item.amount as NSNumber)
            if value >= currentStart && value < currentStart + itemAmount {
                // Found it!
                selectedCategory = item.category
                return
            }
            currentStart += itemAmount
        }
    }
}

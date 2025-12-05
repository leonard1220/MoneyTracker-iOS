//
//  IconPickerView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    let colorHex: String
    
    let icons = [
        "creditcard", "banknote", "building.columns", "wallet.pass",
        "cart", "basket", "bag", "gift",
        "house", "car", "tram", "airplane",
        "cross.case", "heart", "star", "tag"
    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 45))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(icons, id: \.self) { icon in
                ZStack {
                    Circle()
                        .fill(selectedIcon == icon ? Color(hex: colorHex) : Color(uiColor: .systemGray6))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: icon)
                        .foregroundColor(selectedIcon == icon ? .white : .primary)
                        .font(.system(size: 20))
                }
                .onTapGesture {
                    selectedIcon = icon
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    IconPickerView(selectedIcon: .constant("creditcard"), colorHex: "#007AFF")
}

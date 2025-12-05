//
//  ColorPickerView.swift
//  MoneyTracker
//
//  Created on 2024-11-23.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: String
    
    let colors = [
        "#FF3B30", "#FF9500", "#FFCC00", "#34C759", "#00C7BE",
        "#30B0C7", "#32ADE6", "#007AFF", "#5856D6", "#AF52DE",
        "#FF2D55", "#A2845E", "#8E8E93", "#3B3B3B", "#000000"
    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 40))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(colors, id: \.self) { colorHex in
                ZStack {
                    Circle()
                        .fill(Color(hex: colorHex))
                        .frame(width: 40, height: 40)
                    
                    if selectedColor == colorHex {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
                .onTapGesture {
                    selectedColor = colorHex
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ColorPickerView(selectedColor: .constant("#007AFF"))
}

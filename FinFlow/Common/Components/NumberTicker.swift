//
//  NumberTicker.swift
//  FinFlow
//
//  Created on 2024-11-23.
//

import SwiftUI

struct NumberTicker: ViewModifier {
    var value: Decimal
    
    func body(content: Content) -> some View {
        content
            .contentTransition(.numericText(value: NSDecimalNumber(decimal: value).doubleValue))
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: value)
    }
}

extension View {
    func numberTicker(value: Decimal) -> some View {
        self.modifier(NumberTicker(value: value))
    }
}

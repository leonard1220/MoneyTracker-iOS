//
//  SplashView.swift
//  FinFlow
//
//  Created on 2025-12-06.
//

import SwiftUI

/// 霓虹呼吸启动页
struct SplashView: View {
    @Binding var isActive: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var showText = false
    
    var body: some View {
        ZStack {
            // 背景色
            Color(hex: "#0C0D10").ignoresSafeArea()
            
            VStack {
                ZStack {
                    // 1. 霓虹呼吸光晕
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
                    
                    // 2. Logo 图标
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: AppTheme.primary.opacity(0.8), radius: 20, x: 0, y: 0)
                }
                .scaleEffect(size)
                
                // 3. 品牌文字
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
            // 启动动画序列
            
            // 1. 呼吸动画
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                size = 1.1
                opacity = 0.8
            }
            
            // 2. 文字浮现
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showText = true
                }
            }
            
            // 3. 结束启动页
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isActive = false
                }
            }
        }
    }
}

#Preview {
    SplashView(isActive: Binding.constant(true))
}

//
//  FloatingActionButton.swift
//  FinFlow
//
//  浮动快捷记账按钮 - 始终可见的快速记账入口
//

import SwiftUI

struct FloatingActionButton: View {
    @Binding var showQuickAdd: Bool
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                ZStack {
                    // 展开的选项
                    if isExpanded {
                        VStack(spacing: 16) {
                            // 扫描票据
                            FloatingActionItem(
                                icon: "doc.text.viewfinder",
                                label: "扫描",
                                color: .orange
                            ) {
                                // TODO: 打开扫描
                                isExpanded = false
                            }
                            
                            // 记收入
                            FloatingActionItem(
                                icon: "arrow.down.left",
                                label: "收入",
                                color: AppTheme.income
                            ) {
                                // TODO: 打开收入记账
                                isExpanded = false
                            }
                            
                            // 记支出
                            FloatingActionItem(
                                icon: "arrow.up.right",
                                label: "支出",
                                color: AppTheme.expense
                            ) {
                                showQuickAdd = true
                                isExpanded = false
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                        .padding(.bottom, 80)
                    }
                    
                    // 主按钮
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: isExpanded ? "xmark" : "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                LinearGradient(
                                    colors: [AppTheme.primary, AppTheme.primary.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: AppTheme.primary.opacity(0.4), radius: 10, y: 5)
                            .rotationEffect(.degrees(isExpanded ? 45 : 0))
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Floating Action Item
struct FloatingActionItem: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .clipShape(Circle())
                    .shadow(color: color.opacity(0.4), radius: 8, y: 4)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        FloatingActionButton(showQuickAdd: Binding.constant(false))
    }
}

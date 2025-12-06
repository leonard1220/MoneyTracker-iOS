
import SwiftUI
import SwiftData
import Vision
import VisionKit

// MARK: - Tab Navigation View
struct TabNavigationView: View {
    @Environment(AppEnvironment.self) private var appEnvironment
    @Environment(\.quickActionToPerform) private var quickActionToPerform
    
    @State private var showQuickAdd = false
    @State private var showScanner = false
    @State private var quickAddType: TransactionType = .expense
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Content View
            TabView(selection: Bindable(appEnvironment).selectedTab) {
                DashboardView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar) // Hide native tab bar
                
                TransactionListView()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
                
                PlanningView()
                    .tag(2)
                    .toolbar(.hidden, for: .tabBar)
                
                ReportsView()
                    .tag(3)
                    .toolbar(.hidden, for: .tabBar)
                
                SettingsView()
                    .tag(4)
                    .toolbar(.hidden, for: .tabBar)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 92)
            }
            
            // 2. Custom Floating Tab Bar
            FloatingTabBar(selectedTab: Bindable(appEnvironment).selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showQuickAdd) {
            QuickAddTransactionView()
        }
        .sheet(isPresented: $showScanner) {
            ReceiptScannerView(scannedAmount: Binding.constant(""), scannedNote: Binding.constant(""))
        }
        .onChange(of: quickActionToPerform.wrappedValue) { _, newAction in
            handleQuickAction(newAction)
        }
    }
    
    private func handleQuickAction(_ action: QuickAction?) {
        guard let action = action else { return }
        switch action {
        case .addExpense:
            quickAddType = .expense
            showQuickAdd = true
        case .addIncome:
            quickAddType = .income
            showQuickAdd = true
        case .scanReceipt:
            showScanner = true
        }
        quickActionToPerform.wrappedValue = nil
    }
}

// MARK: - Floating Tab Bar (Merged)
struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    
    struct TabItem {
        let icon: String
        let title: String
        let tag: Int
    }
    
    let tabs = [
        TabItem(icon: "house.fill", title: "首页", tag: 0),
        TabItem(icon: "list.bullet", title: "明细", tag: 1),
        TabItem(icon: "chart.line.uptrend.xyaxis", title: "计划", tag: 2),
        TabItem(icon: "chart.bar.fill", title: "报表", tag: 3),
        TabItem(icon: "gearshape.fill", title: "设置", tag: 4)
    ]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.tag) { tab in
                Spacer()
                
                Button {
                    if selectedTab != tab.tag {
                        HapticManager.shared.lightImpact()
                    }
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.tag
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab.tag {
                                Circle()
                                    .fill(AppTheme.primary.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .blur(radius: 5)
                                    .scaleEffect(1.0)
                            }
                            
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: selectedTab == tab.tag ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab.tag ? AppTheme.primary : Color.white.opacity(0.5))
                                .scaleEffect(selectedTab == tab.tag ? 1.1 : 1.0)
                        }
                        
                        if selectedTab == tab.tag {
                           Circle()
                                .fill(AppTheme.primary)
                                .frame(width: 4, height: 4)
                                .offset(y: -2)
                        }
                    }
                }
                .buttonStyle(ScaleButtonStyle())
                
                Spacer()
            }
        }
        .frame(height: 64)
        .background(
            ZStack {
                Capsule()
                    .fill(.ultraThinMaterial)
                
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.1), .white.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Quick Add Transaction View (Merged)
struct QuickAddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Account.name) private var accounts: [Account]
    @Query(sort: \Category.name) private var allCategories: [Category]
    
    // 状态
    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category?
    @State private var selectedAccount: Account?
    @State private var note: String = ""
    @State private var showSuccess = false
    
    // 常用金额
    private let quickAmounts = [10, 20, 50, 100, 200, 500]
    
    // 根据类型过滤分类
    private var filteredCategories: [Category] {
        allCategories.filter { $0.type.rawValue == selectedType.rawValue }
    }
    
    // 最近使用的分类（前6个）
    private var recentCategories: [Category] {
        Array(filteredCategories.prefix(6))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.groupedBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 1. 类型切换
                        typeSelector
                        
                        // 2. 金额输入区域
                        amountInputSection
                        
                        // 3. 快捷金额按钮
                        quickAmountButtons
                        
                        // 4. 分类快选
                        categoryQuickSelect
                        
                        // 5. 账户选择
                        accountSelector
                        
                        // 6. 备注（可选）
                        noteSection
                        
                        // 7. 保存按钮
                        saveButton
                    }
                    .padding()
                }
            }
            .navigationTitle("快速记账")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                // 自动选择第一个账户
                if selectedAccount == nil {
                    selectedAccount = accounts.first
                }
            }
            .overlay {
                if showSuccess {
                    successOverlay
                }
            }
        }
    }
    
    // MARK: - 类型选择器
    private var typeSelector: some View {
        HStack(spacing: 12) {
            ForEach([TransactionType.expense, TransactionType.income], id: \.self) { type in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedType = type
                        selectedCategory = nil // 重置分类
                    }
                } label: {
                    HStack {
                        Image(systemName: type == .expense ? "arrow.up.right" : "arrow.down.left")
                        Text(type == .expense ? "支出" : "收入")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(selectedType == type ? (type == .expense ? AppTheme.expense : AppTheme.income) : AppTheme.background)
                    .foregroundColor(selectedType == type ? .white : .primary)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - 金额输入区域
    private var amountInputSection: some View {
        VStack(spacing: 8) {
            Text("金额")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("RM")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                TextField("0", text: $amount)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            .padding()
            .background(AppTheme.background)
            .cornerRadius(16)
        }
    }
    
    // MARK: - 快捷金额按钮
    private var quickAmountButtons: some View {
        VStack(spacing: 8) {
            Text("常用金额")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(quickAmounts, id: \.self) { quickAmount in
                    Button {
                        HapticManager.shared.lightImpact()
                        amount = String(quickAmount)
                    } label: {
                        Text("RM \(quickAmount)")
                            .font(.headline)
                            .foregroundColor(AppTheme.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppTheme.primary.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    // MARK: - 分类快选
    private var categoryQuickSelect: some View {
        VStack(spacing: 12) {
            HStack {
                Text("选择分类")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            if recentCategories.isEmpty {
                Text("暂无分类，请在设置中添加")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(recentCategories) { category in
                        Button {
                            HapticManager.shared.selectionChanged()
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        } label: {
                            VStack(spacing: 6) {
                                if let iconName = category.iconName {
                                    Image(systemName: iconName)
                                        .font(.title2)
                                }
                                Text(category.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedCategory?.id == category.id ? AppTheme.primary : AppTheme.background)
                            .foregroundColor(selectedCategory?.id == category.id ? .white : .primary)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 账户选择器
    private var accountSelector: some View {
        VStack(spacing: 8) {
            Text("账户")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Menu {
                ForEach(accounts) { account in
                    Button {
                        selectedAccount = account
                    } label: {
                        HStack {
                            Image(systemName: account.icon)
                            Text(account.name)
                            if selectedAccount?.id == account.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    if let account = selectedAccount {
                        Image(systemName: account.icon)
                            .foregroundColor(Color(hex: account.color))
                        Text(account.name)
                            .foregroundColor(.primary)
                    } else {
                        Text("选择账户")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(AppTheme.background)
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - 备注区域
    private var noteSection: some View {
        VStack(spacing: 8) {
            Text("备注（可选）")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("添加备注...", text: $note)
                .padding()
                .background(AppTheme.background)
                .cornerRadius(12)
        }
    }
    
    // MARK: - 保存按钮
    private var saveButton: some View {
        Button {
            saveTransaction()
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("保存")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isFormValid ? AppTheme.primary : Color.gray.opacity(0.3))
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(color: isFormValid ? AppTheme.primary.opacity(0.3) : .clear, radius: 10, y: 5)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - 成功提示
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("记账成功!")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding(40)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    // MARK: - 表单验证
    private var isFormValid: Bool {
        guard let amountValue = Decimal(string: amount), amountValue > 0 else {
            return false
        }
        return selectedAccount != nil
    }
    
    // MARK: - 保存交易
    private func saveTransaction() {
        guard let amountValue = Decimal(string: amount), amountValue > 0 else {
            return
        }
        
        guard let account = selectedAccount else {
            return
        }
        
        let transaction = Transaction(
            amount: amountValue,
            type: selectedType,
            date: Date(),
            note: note.isEmpty ? nil : note,
            mood: nil,
            fromAccount: selectedType == .expense ? account : nil,
            toAccount: selectedType == .income ? account : nil,
            targetAccount: nil,
            category: selectedCategory
        )
        
        if TransactionService.saveTransaction(transaction, context: modelContext) {
            HapticManager.shared.mediumImpact()
            
            // 显示成功动画
            withAnimation(.spring(response: 0.5)) {
                showSuccess = true
            }
            
            // 1秒后关闭
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dismiss()
            }
        }
    }
}

// MARK: - Receipt Scanner View (Merged)
struct ReceiptScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var scannedAmount: String
    @Binding var scannedNote: String
    
    @State private var showScanner = false
    @State private var scannedImage: UIImage?
    @State private var isProcessing = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let image = scannedImage {
                    // 显示扫描的图片
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    
                    if isProcessing {
                        ProgressView("正在识别...")
                            .padding()
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }
                    
                    // 重新扫描按钮
                    Button {
                        scannedImage = nil
                        errorMessage = nil
                        showScanner = true
                    } label: {
                        Label("重新扫描", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                } else {
                    // 扫描引导
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.primary)
                        
                        Text("扫描票据")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("拍摄收据或发票，自动识别金额和商家信息")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button {
                            showScanner = true
                        } label: {
                            Label("开始扫描", systemImage: "camera.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("扫描票据")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                if scannedImage != nil && !scannedAmount.isEmpty {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("使用") {
                            dismiss()
                        }
                    }
                }
            }
            .sheet(isPresented: $showScanner) {
                ImagePicker(image: $scannedImage, sourceType: .camera)
                    .ignoresSafeArea()
            }
            .onChange(of: scannedImage) { _, newImage in
                if let image = newImage {
                    processImage(image)
                }
            }
        }
    }
    
    // MARK: - OCR 处理
    private func processImage(_ image: UIImage) {
        isProcessing = true
        errorMessage = nil
        
        guard let cgImage = image.cgImage else {
            errorMessage = "无法处理图片"
            isProcessing = false
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            DispatchQueue.main.async {
                isProcessing = false
                
                if let error = error {
                    errorMessage = "识别失败: \(error.localizedDescription)"
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    errorMessage = "未识别到文字"
                    return
                }
                
                processRecognizedText(observations)
            }
        }
        
        // 设置识别语言和级别
        request.recognitionLanguages = ["en-US", "zh-Hans"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "处理失败: \(error.localizedDescription)"
                    isProcessing = false
                }
            }
        }
    }
    
    // MARK: - 解析识别的文字
    private func processRecognizedText(_ observations: [VNRecognizedTextObservation]) {
        var allText: [String] = []
        var amounts: [Decimal] = []
        var merchantName: String?
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            let text = topCandidate.string
            allText.append(text)
            
            // 提取金额（支持多种格式）
            if let amount = extractAmount(from: text) {
                amounts.append(amount)
            }
            
            // 提取商家名称（通常在顶部）
            if merchantName == nil && text.count > 3 && text.count < 50 {
                // 简单启发式：较短的文本可能是商家名
                if !text.contains("RM") && !text.contains("MYR") && !text.contains("TOTAL") {
                    merchantName = text
                }
            }
        }
        
        // 选择最大的金额作为总额
        if let maxAmount = amounts.max() {
            scannedAmount = String(describing: maxAmount)
        }
        
        // 设置备注
        if let merchant = merchantName {
            scannedNote = merchant
        }
        
        if scannedAmount.isEmpty {
            errorMessage = "未识别到金额，请手动输入"
        }
    }
    
    // MARK: - 提取金额
    private func extractAmount(from text: String) -> Decimal? {
        // 匹配模式: RM 50.00, MYR 50, 50.00, etc.
        let patterns = [
            "RM\\s*([0-9,]+\\.?[0-9]*)",
            "MYR\\s*([0-9,]+\\.?[0-9]*)",
            "([0-9,]+\\.[0-9]{2})",
            "TOTAL.*?([0-9,]+\\.?[0-9]*)"
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let nsString = text as NSString
                let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
                
                for match in results {
                    if match.numberOfRanges > 1 {
                        let amountRange = match.range(at: 1)
                        let amountString = nsString.substring(with: amountRange)
                            .replacingOccurrences(of: ",", with: "")
                        
                        if let amount = Decimal(string: amountString), amount > 0 {
                            return amount
                        }
                    }
                }
            }
        }
        
        return nil
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

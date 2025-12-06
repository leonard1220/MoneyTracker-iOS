//
//  ReceiptScannerView.swift
//  FinFlow
//
//  OCR 票据扫描 - 自动识别金额和商家信息
//

import SwiftUI
import VisionKit
import Vision

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

#Preview {
    ReceiptScannerView(scannedAmount: .constant(""), scannedNote: .constant(""))
}

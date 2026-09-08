import SwiftUI

struct CitationCardView: View {
    let citation: GACARCitation
    let language: AppLanguage
    @State private var showDetailModal: Bool = false
    
    var body: some View {
        Button(action: { showDetailModal = true }) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.blue.opacity(0.12))
                        .frame(width: 34, height: 34)
                    Image(systemName: citation.category.iconName)
                        .font(.system(size: 15))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(citation.partNumber)
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                        
                        if let sec = citation.sectionNumber {
                            Text("§ \(sec)")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(language == .arabic ? citation.arabicTitle : citation.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(language == .arabic ? citation.arabicVerbatimSnippet : citation.verbatimSnippet)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.blue.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetailModal) {
            CitationDetailModal(citation: citation, language: language)
        }
    }
}

struct CitationDetailModal: View {
    let citation: GACARCitation
    let language: AppLanguage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Category Header Pill
                    HStack {
                        Image(systemName: citation.category.iconName)
                        Text(language == .arabic ? citation.category.arabicName : citation.category.rawValue)
                    }
                    .font(.caption.weight(.bold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.blue.opacity(0.12)))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(citation.partNumber + (citation.sectionNumber.map { " - § \($0)" } ?? ""))
                            .font(.system(size: 24, weight: .heavy, design: .monospaced))
                            .foregroundColor(.blue)
                        
                        Text(language == .arabic ? citation.arabicTitle : citation.title)
                            .font(.title2.weight(.bold))
                    }
                    
                    Divider()
                    
                    // Verbatim GACAR Text Box
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "quote.opening")
                                .foregroundColor(.blue)
                            Text(language == .arabic ? "النص الأصلي من لائحة GACAR" : "Verbatim GACAR Regulatory Snippet")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(language == .arabic ? citation.arabicVerbatimSnippet : citation.verbatimSnippet)
                            .font(.system(size: 15, weight: .medium))
                            .lineSpacing(6)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.primary.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                                    )
                            )
                    }
                    
                    // Official Disclaimer Note
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(language == .arabic ?
                             "ملاحظة: هذا المحتوى مخصص للتعليم والدراسة فقط. المرجع الرسمي الوحيد للوائح هو موقع الهيئة العامة للطيران المدني (gaca.gov.sa)." :
                             "Disclaimer: Educational reference snippet. Official authoritative regulations must always be verified directly at gaca.gov.sa.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange.opacity(0.08))
                    )
                }
                .padding(20)
            }
            .navigationTitle(language == .arabic ? "مرجع اللائحة" : "GACAR Reference")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(language == .arabic ? "إغلاق" : "Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

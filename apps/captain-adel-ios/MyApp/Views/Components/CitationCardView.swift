import SwiftUI

struct CitationCardView: View {
    let citation: GACARCitation
    let language: AppLanguage
    @State private var showDetailModal: Bool = false

    var body: some View {
        Button(action: {
            Haptics.light()
            showDetailModal = true
        }) {
            VStack(alignment: .leading, spacing: 6) {
                // Tactical Header Strip
                HStack(spacing: 8) {
                    Text(citation.partNumber + (citation.sectionNumber.map { ", §\($0)" } ?? ""))
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.cyan)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(AvionicsTheme.cyan.opacity(0.12)))
                        .overlay(Capsule().stroke(AvionicsTheme.cyan.opacity(0.3), lineWidth: 1))

                    Text(language == .arabic ? citation.category.arabicName : citation.category.rawValue)
                        .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                        .foregroundColor(AvionicsTheme.inkDim)

                    Spacer()

                    HStack(spacing: 3) {
                        Text(language == .arabic ? "عرض النص" : "VERBATIM")
                            .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.teal)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(AvionicsTheme.teal)
                    }
                }

                // Regulation Title
                Text(language == .arabic ? citation.arabicTitle : citation.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AvionicsTheme.ink)
                    .lineLimit(1)

                // Verbatim Snippet
                Text(language == .arabic ? citation.arabicVerbatimSnippet : citation.verbatimSnippet)
                    .font(.system(size: 11.5))
                    .foregroundColor(AvionicsTheme.inkDim)
                    .lineSpacing(3)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(10)
            .glassPanel(accent: AvionicsTheme.mint, cornerRadius: 10, glow: false, tint: 0.6)
        }
        .buttonStyle(.pressable)
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
            ZStack {
                CockpitBackdrop()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        // Section Code Header Strip
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(citation.partNumber + (citation.sectionNumber.map { " § \($0)" } ?? ""))
                                    .font(.system(size: 24, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(AvionicsTheme.mintCyanGradient)

                                Spacer()

                                Text("GACAR CORPUS")
                                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Capsule().fill(AvionicsTheme.cyan.opacity(0.15)))
                                    .foregroundColor(AvionicsTheme.cyan)
                                    .overlay(Capsule().stroke(AvionicsTheme.cyan.opacity(0.4), lineWidth: 1))
                            }

                            Text(language == .arabic ? citation.arabicTitle : citation.title)
                                .font(.title3.weight(.bold))
                                .foregroundColor(AvionicsTheme.ink)
                        }
                        .padding(16)
                        .glassPanel(accent: AvionicsTheme.cyan, cornerRadius: 14)

                        // Verbatim GACAR Text Box
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "quote.opening")
                                    .foregroundColor(AvionicsTheme.cyan)
                                Text(language == .arabic ? "النص القانوني الأصلي من اللائحة" : "VERBATIM GACAR REGULATORY SNIPPET")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(AvionicsTheme.inkDim)
                            }

                            Text(language == .arabic ? citation.arabicVerbatimSnippet : citation.verbatimSnippet)
                                .font(.system(size: 14.5, weight: .medium, design: .monospaced))
                                .lineSpacing(6)
                                .foregroundColor(AvionicsTheme.ink)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AvionicsTheme.panel2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(AvionicsTheme.cyan.opacity(0.35), lineWidth: 1)
                                )
                        }

                        // Official Disclaimer Note
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "shield.lefthalf.filled")
                                .foregroundColor(AvionicsTheme.amber)
                            Text(language == .arabic ?
                                 "ملاحظة قانونية: كابتن عادل مشروع تعليمي مستقل. المرجع الرسمي الوحيد والمُعتمد نظاماً هو الهيئة العامة للطيران المدني على gaca.gov.sa." :
                                 "Doctrine Notice: Captain Adel is an independent AI flight instructor. For official flight decisions, always reference General Authority of Civil Aviation publications at gaca.gov.sa.")
                                .font(.system(size: 11.5))
                                .foregroundColor(AvionicsTheme.inkDim)
                                .lineSpacing(3)
                        }
                        .padding(12)
                        .glassPanel(accent: AvionicsTheme.amber, cornerRadius: 10, glow: false)
                    }
                    .padding(16)
                }
            }
            .navigationTitle(citation.partNumber)
            .navigationBarTitleDisplayModeInline()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(language == .arabic ? "إغلاق" : "Close") { dismiss() }
                        .foregroundColor(AvionicsTheme.cyan)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

import SwiftUI

struct ChecklistsView: View {
    @Binding var currentLanguage: AppLanguage
    @State private var selectedType: ChecklistType = .normal
    @State private var checklists: [FlightChecklist] = CockpitChecklistDatabase.defaultChecklists()
    @State private var activeChecklist: FlightChecklist? = nil
    @State private var isReadingAloud: Bool = false

    private var filteredChecklists: [FlightChecklist] {
        checklists.filter { $0.checklistType == selectedType }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Visual Pre-Flight Walkaround Header Card
            ZStack(alignment: .bottomLeading) {
                Image.captainWalkaround
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 130)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [Color.black.opacity(0.15), Color.black.opacity(0.88)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Circle().fill(AvionicsTheme.mint).frame(width: 7, height: 7)
                            Text("GACAR PART 91 // PRE-FLIGHT & QRF")
                                .font(.system(size: 9.5, weight: .black, design: .monospaced))
                                .foregroundColor(AvionicsTheme.cyan)
                        }

                        Text(currentLanguage == .arabic ? "فحص الطائرة وإجراءات الطوارئ" : "AIRCRAFT WALKAROUND & CHECKLISTS")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.white)

                        Text(currentLanguage == .arabic ? "إجراءات السلامة المعتمدة قبل الإقلاع وفي حالات الطوارئ" : "Tactical Normal & Emergency Quick Reference Checklists")
                            .font(.system(size: 10.5))
                            .foregroundColor(AvionicsTheme.inkDim)
                    }
                    Spacer()
                }
                .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(AvionicsTheme.line, lineWidth: 1)
            )

            // Category Selector Tabs
            HStack(spacing: 8) {
                ForEach(ChecklistType.allCases) { type in
                    let isSelected = selectedType == type
                    Button(action: {
                        Haptics.selection()
                        withAnimation(.spring(response: 0.3)) {
                            selectedType = type
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: type.icon)
                                .font(.system(size: 11, weight: .bold))
                            Text(currentLanguage == .arabic ? type.arabicName : type.rawValue)
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                        }
                        .foregroundColor(isSelected ? AvionicsTheme.bg : type.accentColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(type.accentColor)
                                } else {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(type.accentColor.opacity(0.12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .stroke(type.accentColor.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }

            // Summary Telemetry Pill
            HStack {
                let total = filteredChecklists.count
                let done = filteredChecklists.filter { $0.isComplete }.count
                HStack(spacing: 6) {
                    Circle()
                        .fill(selectedType == .emergency ? AvionicsTheme.amber : AvionicsTheme.mint)
                        .frame(width: 7, height: 7)
                    Text(currentLanguage == .arabic ?
                         "القوائم المكتملة: \(done) من \(total)" :
                         "CHECKLIST STATUS: \(done)/\(total) VERIFIED")
                        .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                        .foregroundColor(AvionicsTheme.inkDim)
                }

                Spacer()

                Button(action: resetAllInCurrentCategory) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 10))
                        Text(currentLanguage == .arabic ? "إعادة تعيين" : "RESET")
                            .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                    }
                    .foregroundColor(AvionicsTheme.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AvionicsTheme.panel2)
                    .cornerRadius(5)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 4)

            // Checklist Cards
            ForEach(filteredChecklists) { checklist in
                checklistCard(checklist)
            }
        }
        .sheet(item: $activeChecklist) { list in
            ChecklistInteractiveSheet(
                checklist: list,
                currentLanguage: currentLanguage,
                onSave: { updated in
                    if let index = checklists.firstIndex(where: { $0.id == updated.id }) {
                        checklists[index] = updated
                    }
                }
            )
        }
    }

    // MARK: - Checklist Card Row
    private func checklistCard(_ list: FlightChecklist) -> some View {
        Button(action: {
            Haptics.selection()
            activeChecklist = list
        }) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(list.gacarRef)
                                .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(list.checklistType == .emergency ? AvionicsTheme.amber.opacity(0.18) : AvionicsTheme.cyan.opacity(0.18))
                                .foregroundColor(list.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.cyan)
                                .cornerRadius(4)

                            if list.isComplete {
                                HStack(spacing: 3) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 9))
                                    Text(currentLanguage == .arabic ? "مكتمل" : "COMPLETE")
                                        .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                                }
                                .foregroundColor(AvionicsTheme.mint)
                            }
                        }

                        Text(currentLanguage == .arabic ? list.titleAr : list.titleEn)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                            .multilineTextAlignment(.leading)

                        Text(currentLanguage == .arabic ? list.subtitleAr : list.subtitleEn)
                            .font(.system(size: 11))
                            .foregroundColor(AvionicsTheme.inkDim)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()

                    // Completion progress circle
                    ZStack {
                        Circle()
                            .stroke(AvionicsTheme.line, lineWidth: 3)
                            .frame(width: 38, height: 38)

                        Circle()
                            .trim(from: 0, to: list.progress)
                            .stroke(
                                list.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.mint,
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 38, height: 38)
                            .rotationEffect(.degrees(-90))

                        Text("\(list.completedCount)/\(list.items.count)")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(AvionicsTheme.ink)
                    }
                }

                // Progress Bar Indicator
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AvionicsTheme.panel2)
                            .frame(height: 4)

                        Capsule()
                            .fill(list.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.cyan)
                            .frame(width: max(geo.size.width * CGFloat(list.progress), 0), height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(14)
            .glassPanel(
                accent: list.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.cyan,
                cornerRadius: 12,
                glow: list.checklistType == .emergency
            )
        }
        .buttonStyle(.pressable)
    }

    private func resetAllInCurrentCategory() {
        Haptics.medium()
        for idx in checklists.indices {
            if checklists[idx].checklistType == selectedType {
                for itemIdx in checklists[idx].items.indices {
                    checklists[idx].items[itemIdx].isCompleted = false
                }
            }
        }
    }
}

// MARK: - Interactive Checklist Sheet
struct ChecklistInteractiveSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State var checklist: FlightChecklist
    let currentLanguage: AppLanguage
    var onSave: (FlightChecklist) -> Void

    @State private var isReadingAloud: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AvionicsTheme.bg.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Cockpit HUD Header
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(checklist.gacarRef)
                                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(checklist.checklistType == .emergency ? AvionicsTheme.amber.opacity(0.2) : AvionicsTheme.cyan.opacity(0.2))
                                    .foregroundColor(checklist.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.cyan)
                                    .cornerRadius(4)

                                Spacer()

                                Text("\(checklist.completedCount) / \(checklist.items.count)")
                                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                                    .foregroundColor(checklist.isComplete ? AvionicsTheme.mint : AvionicsTheme.cyan)
                            }

                            Text(currentLanguage == .arabic ? checklist.titleAr : checklist.titleEn)
                                .font(.system(size: 17, weight: .black, design: .monospaced))
                                .foregroundColor(AvionicsTheme.ink)

                            Text(currentLanguage == .arabic ? checklist.subtitleAr : checklist.subtitleEn)
                                .font(.system(size: 12))
                                .foregroundColor(AvionicsTheme.inkDim)
                        }
                        .padding(14)
                        .glassPanel(
                            accent: checklist.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.cyan,
                            cornerRadius: 12,
                            glow: checklist.checklistType == .emergency
                        )

                        // Voice Readout Action Bar
                        HStack(spacing: 8) {
                            Button(action: toggleVoiceReadout) {
                                HStack(spacing: 6) {
                                    Image(systemName: isReadingAloud ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                        .font(.system(size: 12, weight: .bold))
                                    Text(isReadingAloud ?
                                         (currentLanguage == .arabic ? "إيقاف القراءة" : "STOP AUDIO") :
                                         (currentLanguage == .arabic ? "قراءة صوتية بالقمرة" : "READ ALOUD"))
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                }
                                .foregroundColor(isReadingAloud ? AvionicsTheme.amber : AvionicsTheme.cyan)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(AvionicsTheme.panel2)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(AvionicsTheme.line, lineWidth: 1))
                            }
                            .buttonStyle(.plain)

                            Button(action: toggleAllItems) {
                                HStack(spacing: 6) {
                                    Image(systemName: checklist.isComplete ? "arrow.counterclockwise" : "checkmark.circle")
                                        .font(.system(size: 12, weight: .bold))
                                    Text(checklist.isComplete ?
                                         (currentLanguage == .arabic ? "إعادة ضبط" : "RESET ALL") :
                                         (currentLanguage == .arabic ? "تحديد الكل" : "CHECK ALL"))
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                }
                                .foregroundColor(AvionicsTheme.teal)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(AvionicsTheme.panel2)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(AvionicsTheme.line, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }

                        // Checklist Items List
                        VStack(spacing: 8) {
                            ForEach(checklist.items.indices, id: \.self) { idx in
                                let item = checklist.items[idx]
                                itemRow(item: item, index: idx)
                            }
                        }

                        // Completion Banner when finished
                        if checklist.isComplete {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(AvionicsTheme.mint)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(currentLanguage == .arabic ? "اكتملت جميع بنود القائمة بنجاح" : "CHECKLIST COMPLETED")
                                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(AvionicsTheme.mint)
                                    Text(currentLanguage == .arabic ? "طائرتك جاهزة ومطابقة لمعايير الهيئة العامة للطيران المدني." : "All systems verified in accordance with GACAR doctrine.")
                                        .font(.system(size: 11))
                                        .foregroundColor(AvionicsTheme.inkDim)
                                }
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AvionicsTheme.mint.opacity(0.12))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(AvionicsTheme.mint.opacity(0.4), lineWidth: 1))
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle(currentLanguage == .arabic ? "قائمة التدقيق" : "COCKPIT CHECKLIST")
            .navigationBarTitleDisplayModeInline()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(currentLanguage == .arabic ? "إغلاق" : "Close") {
                        CockpitVoiceCommsService.shared.stopSpeaking()
                        dismiss()
                    }
                    .foregroundColor(AvionicsTheme.cyan)
                }
            }
        }
        .preferredColorScheme(.dark)
        .environment(\.layoutDirection, currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }

    private func itemRow(item: FlightChecklistItem, index: Int) -> some View {
        Button(action: {
            Haptics.selection()
            checklist.items[index].isCompleted.toggle()
            if checklist.isComplete {
                Haptics.success()
            }
            onSave(checklist)
        }) {
            HStack(alignment: .center, spacing: 12) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(item.isCompleted ?
                              (checklist.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.mint) :
                              Color.clear)
                        .frame(width: 24, height: 24)

                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(item.isCompleted ?
                                (checklist.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.mint) :
                                AvionicsTheme.line, lineWidth: 1.5)
                        .frame(width: 24, height: 24)

                    if item.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(AvionicsTheme.bg)
                    }
                }

                // Item description and action
                VStack(alignment: .leading, spacing: 3) {
                    Text(currentLanguage == .arabic ? item.itemAr : item.itemEn)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(item.isCompleted ? AvionicsTheme.inkDim : AvionicsTheme.ink)
                        .strikethrough(item.isCompleted, color: AvionicsTheme.inkDim)

                    if let note = (currentLanguage == .arabic ? item.noteAr : item.noteEn) {
                        Text(note)
                            .font(.system(size: 10.5))
                            .foregroundColor(AvionicsTheme.inkDim)
                    }
                }

                Spacer()

                // Action Callout Pill (e.g. "SET", "ON", "SQUAWK 7700")
                Text(currentLanguage == .arabic ? item.actionAr : item.actionEn)
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        item.isCompleted ?
                        AvionicsTheme.panel2 :
                        (checklist.checklistType == .emergency ? AvionicsTheme.amber.opacity(0.18) : AvionicsTheme.cyan.opacity(0.18))
                    )
                    .foregroundColor(
                        item.isCompleted ?
                        AvionicsTheme.inkDim :
                        (checklist.checklistType == .emergency ? AvionicsTheme.amber : AvionicsTheme.cyan)
                    )
                    .cornerRadius(5)
            }
            .padding(12)
            .background(AvionicsTheme.panel)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(item.isCompleted ? AvionicsTheme.mint.opacity(0.3) : AvionicsTheme.line, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func toggleAllItems() {
        Haptics.medium()
        let targetState = !checklist.isComplete
        for i in checklist.items.indices {
            checklist.items[i].isCompleted = targetState
        }
        if targetState {
            Haptics.success()
        }
        onSave(checklist)
    }

    private func toggleVoiceReadout() {
        if isReadingAloud {
            CockpitVoiceCommsService.shared.stopSpeaking()
            isReadingAloud = false
        } else {
            isReadingAloud = true
            let textToRead = checklist.items.map { item in
                if currentLanguage == .arabic {
                    return "\(item.itemAr)، \(item.actionAr)"
                } else {
                    return "\(item.itemEn), \(item.actionEn)"
                }
            }.joined(separator: ". ")

            let prefix = currentLanguage == .arabic ?
                "بدء قراءة قائمة التدقيق: \(checklist.titleAr). " :
                "Reading checklist: \(checklist.titleEn). "

            CockpitVoiceCommsService.shared.speak(text: prefix + textToRead, language: currentLanguage)
        }
    }
}

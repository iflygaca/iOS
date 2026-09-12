# Roadmap — Captain Adel iOS

What's next for the Captain Adel iOS app. This app is the AI chat-only companion to the FlyGACA flagship app.

## How to read this

- **Now / Next / Later** are horizon buckets, not date commitments — priorities shift as development progresses.
- Each item is tagged **[product]** (something users get) or **[docs]** (contributor/reader-facing writing).
- Shipped items stay visible as ~~strikethrough~~ + **Done.** with a date.

## Now — Documentation and Chat Readiness

- **[docs] Phase 0: Documentation correction** — Add this ROADMAP.md and update the root CLAUDE.md pointer table to list it under Captain Adel iOS.
- **[product] Chat readiness** — Ensure the AI chat feature (including voice input/output and citation display) is functional and ready for metering in the FlyGACA flagship app. No changes to Captain Adel iOS code are required at this stage.

## Next — Feature Separation

- **[product] Phase 9: Remove ported features from Captain Adel iOS** — (Gate: only after FlyGACA flagship verifies Library, Tools, and Guides sections) Delete `GACARLibraryView.swift`, `AviationToolsView.swift` + `METARService.swift`, `QuizService.swift`. Update the tab bar to leave only Chat and About. Keep chat-related files (`GACARCorpusDatabase.swift`, `GACARVectorSearchEngine.swift`, `CaptainAdelAIService.swift`, `CockpitVoiceCommsService.swift`, `Views/Components/*`).
- **[product] Chat UI adjustment** — Adjust the tab bar and any relevant UI to accommodate the removal of other tabs, ensuring a clean Chat-focused experience.

## Later — Optional Enhancements

- **[product] Monetization exploration** — Consider monetization for the standalone Captain Adel app (e.g., subscription for premium AI features) if not already addressed via the Flagship's metered chat.
- **[product] AI feature exploration** — Explore additional AI features for the chat (e.g., improved voice interactions, personalized study recommendations, etc.).

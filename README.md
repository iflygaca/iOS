# Captain Adel iOS

An intelligent flight instructor at your fingertips. **Captain Adel** is the iOS companion to [Fly GACA](https://flygaca.com), an independent educational reference for civil aviation in the Kingdom of Saudi Arabia.

Anytime, anywhere — study Saudi civil aviation regulations, prepare for your pilot exams, and learn from an AI instructor that cites the exact GACAR section every time.

---

## About Captain Adel

Captain Adel is an AI flight instructor built on the complete Saudi civil aviation library — all 74 GACAR Parts, 21 topical handbooks, and every aerodrome and VFR chart. Every answer includes the exact regulatory section it came from.

- **Bilingual** — English and Arabic, optimized for how Saudi aviation actually reads and studies.
- **Right-to-left aware** — Full RTL support for Arabic text and interface.
- **Offline-ready** — Progressive Web App architecture; study offline with content you load.
- **Authoritative** — Answers always cite the GACAR section they come from.

### What It's Not

This app is **not** the General Authority of Civil Aviation, and it's not an official source. It's an independent project — not affiliated with, endorsed by, or connected to GACA. It does not replace the official GACAR, the AIP-KSA, your aircraft's AFM or POH, or your operator's manuals. Always verify against the official publication before relying on anything.

---

## Features

### 🤖 Captain Adel AI Chat

Ask any question about Saudi civil aviation regulations. The AI responds with the exact GACAR section and practical guidance.

- Conversational Q&A on any GACAR topic
- Inline citations to regulatory sections
- Follow-up questions and clarifications
- Supports both English and Arabic

### 📚 GACAR Regulations Library

Browse the complete Saudi civil aviation regulations.

- All 74 GACAR Parts
- 21 topical handbooks
- Full-text search across all regulatory documents
- Easy navigation by topic and section
- Bookmarks for frequent references

### ✈️ Aviation Tools & Exam Prep

Everything a student pilot or instructor needs to prepare.

- **E6B Calculator** — Wind corrections, fuel calculations, time/speed/distance problems
- **Weight & Balance** — CG calculations and loading envelope checks
- **VFR Minima Reference** — Quick lookup for visibility and cloud clearance requirements
- **Airspace Quick Reference** — Airspace types and altitude constraints
- **NOTAM Decoder** — Interpret NOTAMs quickly
- **Practice Quiz** — Exam-style questions to test your knowledge
- **METAR Decoder** — Understand aviation weather at a glance

### ℹ️ About & Model Info

Learn about the app, how it works, and the AI model powering Captain Adel.

---

## Screenshots & UI Highlights

**Language Support**  
Full bilingual interface (English/Arabic) with automatic RTL layout for Arabic mode.

**Interactive Components**  
- Audio waveform visualizer for AI speech output
- HUD-style header displays
- Citation cards linking directly to regulatory sections
- Real-time chat interface with streaming responses

---

## Technical Details

### Architecture

Built with **SwiftUI** for iOS 15+, following the MVVM pattern:

- **Views** — UI components and screen layouts
- **Models** — Data structures for GACAR regulations
- **Services** — AI chat, quiz, METAR fetching
- **Components** — Reusable UI elements (audio waveforms, citation cards, HUD displays)

### Key Technologies

- **Language** — Swift (SwiftUI framework)
- **Minimum iOS** — iOS 15.0
- **Backend Integration** — REST API calls to Fly GACA services
- **Data** — Cached regulatory library with full-text indexing

### Project Structure

```
MyApp/
├── Models/
│   └── GACARModels.swift          # Data models for regulations
├── Views/
│   ├── ChatView.swift              # Captain Adel AI chat interface
│   ├── GACARLibraryView.swift       # Regulation browser
│   ├── AviationToolsView.swift      # Tools and quiz
│   ├── AboutView.swift              # App information
│   └── Components/
│       ├── AudioWaveformView.swift  # Waveform visualizer
│       ├── HeaderHUDView.swift      # HUD-style header
│       ├── CitationCardView.swift   # Regulation citation display
│       └── [Other components]
├── Services/
│   ├── CaptainAdelAIService.swift  # AI chat backend
│   ├── QuizService.swift            # Practice questions
│   └── METARService.swift           # Aviation weather
├── MyApp.swift                      # App entry point
└── ContentView.swift                # Main tab navigation
```

---

## Getting Started

### Requirements

- **Xcode** 14.0 or later
- **iOS** 15.0 or higher
- **Swift** 5.7+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/iflygaca/captain-adel-ios.git
   cd captain-adel-ios
   ```

2. **Open in Xcode**
   ```bash
   open "Untitled Project.xcodeproj"
   ```

3. **Build and run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Configuration

No additional API keys or credentials are needed to run the app locally. The app connects to Fly GACA backend services; adjust the base URL in `CaptainAdelAIService.swift` if running a custom backend.

---

## Development

### Code Structure

- **MVVM Pattern** — ViewModel services handle data, Views handle UI
- **State Management** — SwiftUI `@State` and `@StateObject` for reactive updates
- **Localization** — `AppLanguage` enum for English/Arabic switching

### Adding Features

To add a new feature:
1. Create a new service file in `Services/` if fetching data
2. Create a view file in `Views/` following the existing pattern
3. Add a new tab in `ContentView.swift`
4. Update localization strings for both languages

### Testing

Run tests from Xcode or the command line:
```bash
xcodebuild test -scheme "MyApp" -destination "generic/platform=iOS Simulator"
```

---

## Contributing

We welcome contributions to Captain Adel. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes with clear messages
4. Push to your fork and open a pull request

**Reporting Issues**  
If you find a bug or have a feature suggestion, please open an issue on GitHub. For accuracy corrections or regulatory updates, contact us at **i@flygaca.com**.

---

## License

Captain Adel iOS is open source. See the LICENSE file for details.

---

## About Fly GACA

**Fly GACA** is an independent educational reference for civil aviation in the Kingdom of Saudi Arabia. It brings the rules of Saudi civil aviation into one fast, modern place — and helps you actually learn them.

### The Fly GACA Platform

- **Library** — 74 GACAR Parts, 21 handbooks, aerodromes, VFR charts
- **Captain Adel** — AI flight instructor answering GACAR questions
- **Flight Tools** — E6B, weight & balance, VFR minima, NOTAM decoder, and more
- **Guides** — Licensing, medical, conversion, English proficiency test
- **Ground School** — Complete theoretical-knowledge syllabus and mock exams

**Learn more:** [flygaca.com](https://flygaca.com)

---

## Disclaimer

**This app is not affiliated with the General Authority of Civil Aviation (GACA).** It does not replace the official GACAR, AIP-KSA, your aircraft's AFM/POH, or your operator's manuals. Always verify the current, official version at **gaca.gov.sa** before relying on any regulation.

For operational use in flight, always reference the authoritative, current sources published by GACA.

---

## Contact & Feedback

Have questions, corrections, or feedback? We'd love to hear from you.

- **Email** — [i@flygaca.com](mailto:i@flygaca.com)
- **Website** — [flygaca.com](https://flygaca.com)
- **GitHub** — [iflygaca/captain-adel-ios](https://github.com/iflygaca/captain-adel-ios)

---

**Captain Adel:** One captain on every answer.

# Mobile Integration Guide: iOS/Swift + Capacitor Stack

**Scope:** FlyGACAKit (SwiftUI), Capacitor shell, native bridge, app-family alignment  
**Branch:** `claude/llm-wiki-categorization-wmdgta`  
**Repos:** `iflygaca/ios`, `iflygaca/FlyGACA-ios`, `iflygaca/Captain-Adel-iOS`  
**Target:** Complete within Q1-Q2 2027

---

## Current Stack

```
iOS Apps:
├── apps/flygaca-ios/             # FlyGACAKit study-app family
│   ├── apple/FlyGACAKit/         # Shared Swift package (no external SDK deps)
│   │   ├── Sources/
│   │   │   ├── CoreModels/       # Question, Quiz, LearnerProgress (no IO)
│   │   │   ├── StudyEngines/     # FSRS-6, Session, Streak (pure logic)
│   │   │   ├── ContentKit/       # Bundle/cache loader, signed remote refresh
│   │   │   ├── AppServices/      # Protocol seams (offline mocks)
│   │   │   ├── PersistenceKit/   # SwiftData + StudyStore actor
│   │   │   ├── PlatformLive/     # Firebase, Gemini, Moyasar (NOT YET WIRED)
│   │   │   └── FeatureUI/        # SwiftUI screens
│   │   └── Tests/                # Vitest for pure logic
│   └── Apps/                     # Per-module app targets (ELPT, AIP)
│
├── apps/captain-adel-ios/        # Captain Adel SSE client app
│   ├── MyApp/                    # SwiftUI UI
│   ├── AdelCore/                 # SSE parser, wire fixtures
│   └── Tests/
│
└── Both share:
    ├── App Groups (group.com.FlyGACA) — cross-app study state
    ├── SwiftUI design system (Falcon Theme tokens)
    └── GACAR corpus + content snapshots
```

**Key Constraint:** Zero external SDK dependencies in FlyGACAKit (to keep `swift build`/`swift test` instant).

---

## Immediate Priorities (Now - Q4 2026)

### 1. State Management: The Composable Architecture (TCA, Repo #53)

**Current:** SwiftUI @State/@StateObject (local, no testing)  
**Target:** TCA for testable, predictable state

```bash
# Add to Package.swift
.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.7.0")

# Target dependency:
.target(name: "FeatureUI", dependencies: [
  "CoreModels",
  "StudyEngines",
  .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
])
```

#### TCA Structure for Quiz Feature

```swift
// Feature: Quiz Session
import ComposableArchitecture

// State
@ObservableState
struct QuizSessionState: Equatable {
  var currentQuestionIndex: Int = 0
  var answers: [String: String] = [:] // questionId -> selectedOptionId
  var timeRemaining: Int = 1800 // seconds
  var timerTask: AsyncLet<Void, Error>?
}

// Actions
enum QuizSessionAction: Equatable {
  case selectAnswer(questionId: String, optionId: String)
  case nextQuestion
  case timerTicked
  case submitQuiz
  case resetSession
  case delegate(Delegate)
  
  enum Delegate {
    case quizCompleted(score: Int)
  }
}

// Reducer
@Reducer
struct QuizSessionReducer {
  @Dependency(\.continuousClock) var clock
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .selectAnswer(questionId, optionId):
        state.answers[questionId] = optionId
        return .none
      
      case .nextQuestion:
        state.currentQuestionIndex += 1
        return .none
      
      case .timerTicked:
        state.timeRemaining -= 1
        if state.timeRemaining <= 0 {
          return .send(.submitQuiz)
        }
        return .none
      
      case .submitQuiz:
        let score = calculateScore(state.answers)
        return .send(.delegate(.quizCompleted(score: score)))
      
      case .resetSession:
        state = QuizSessionState()
        return .none
      
      case .delegate:
        return .none
      }
    }
  }
}

// View
struct QuizSessionView: View {
  @Bindable var store: StoreOf<QuizSessionReducer>
  
  var body: some View {
    VStack {
      Text("Question \(store.currentQuestionIndex + 1)")
      Text("\(store.timeRemaining)s remaining")
      
      // Render question options
      ForEach(currentQuestion.options, id: \.id) { option in
        Button(option.text) {
          store.send(.selectAnswer(questionId: currentQuestion.id, optionId: option.id))
          store.send(.nextQuestion)
        }
      }
    }
    .onAppear {
      // Start timer
      Task {
        for await _ in clock.timer(interval: .seconds(1)) {
          store.send(.timerTicked)
        }
      }
    }
  }
}

// Preview
#Preview {
  QuizSessionView(
    store: Store(initialState: QuizSessionState()) {
      QuizSessionReducer()
        ._printChanges() // debug mode
    }
  )
}
```

#### Why TCA for FlyGACAKit?

1. **Testable:** Quiz session logic is pure, no SwiftUI required
2. **Composable:** Combine quiz + progress + streaks into larger feature
3. **Time-travel:** Replay actions for debugging
4. **Dependency injection:** Mock services for testing (not yet needed, but phase 4 ready)

#### Integration Steps

1. Add TCA to `Package.swift`
2. Identify 2-3 core features (Quiz, SRS, Streaks)
3. Create reducers for each (in separate files under `FeatureUI/Reducers/`)
4. Rewrite SwiftUI views to use TCA stores
5. Write tests: action → state change
6. Measure bundle impact (~50 kB)

**Estimated Effort:** 3-4 weeks (phased per feature)

---

### 2. Networking: Alamofire (Repo #51)

**Current:** URLSession directly (verbose, callback hell)  
**Target:** Alamofire for Captain Adel SSE stream + remote corpus refresh

#### Captain Adel SSE Client

```swift
// AdelCore/Sources/AdelSSEClient.swift
import Alamofire

final class AdelSSEClient: NSObject {
  private var eventSource: EventSource?
  private let baseURL: String
  
  init(baseURL: String = "https://captadel.com") {
    self.baseURL = baseURL
  }
  
  // Stream messages from Captain Adel
  func connectToChat(
    query: String,
    onMessage: @escaping (ChatMessage) -> Void,
    onError: @escaping (Error) -> Void,
    onComplete: @escaping () -> Void
  ) {
    var request = URLRequest(url: URL(string: "\(baseURL)/api/chat/stream")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONEncoder().encode(["query": query])
    
    eventSource = EventSource(
      url: request.url!,
      method: request.httpMethod ?? "GET",
      headers: request.allHTTPHeaderFields
    )
    
    eventSource?.onMessage = { messageEvent in
      guard let data = messageEvent.data?.data(using: .utf8) else { return }
      if let message = try? JSONDecoder().decode(ChatMessage.self, from: data) {
        onMessage(message)
      }
    }
    
    eventSource?.onError = { error in
      onError(error)
    }
    
    eventSource?.onComplete = { statusCode, reconnect in
      onComplete()
    }
    
    eventSource?.connect()
  }
  
  func disconnect() {
    eventSource?.close()
  }
}

// Usage in SwiftUI view
struct ChatView: View {
  @State private var messages: [ChatMessage] = []
  private let adelClient = AdelSSEClient()
  
  var body: some View {
    VStack {
      ScrollView {
        ForEach(messages, id: \.id) { message in
          ChatBubble(message: message)
        }
      }
      
      HStack {
        TextField("Ask Captain Adel...", text: $inputText)
        Button("Send") {
          adelClient.connectToChat(
            query: inputText,
            onMessage: { self.messages.append($0) },
            onError: { print("Error: \($0)") },
            onComplete: { }
          )
        }
      }
    }
    .onDisappear { adelClient.disconnect() }
  }
}
```

#### Remote Corpus Refresh

```swift
// ContentKit/Sources/CorpusRefresher.swift
import Alamofire

class CorpusRefresher {
  private let signatureVerifier = CorpusSignatureVerifier()
  
  func refreshCorpus(from url: URL) async throws -> Data {
    // Fetch quiz.json.sig
    let sigResponse = try await AF.request(url.appendingPathExtension("sig"))
      .serializingData()
      .value
    
    guard let sigBase64 = String(data: sigResponse, encoding: .utf8) else {
      throw ContentRefreshError.invalidSignature
    }
    
    // Fetch quiz.json
    let dataResponse = try await AF.request(url)
      .serializingData()
      .value
    
    // Verify signature
    try signatureVerifier.verify(
      data: dataResponse,
      signature: sigBase64
    )
    
    return dataResponse
  }
}
```

**Integration Steps:**
1. Add Alamofire to `Package.swift`
2. Wrap URLSession calls in AdelSSEClient
3. Test SSE stream parsing
4. Integrate corpus refresh with signature verification
5. Measure bundle impact (~100 kB)

**Estimated Effort:** 2 weeks

---

### 3. Real-Time Messaging: Socket.io (Repo #55)

**Use Case:** Instructor study-group chat, multiplayer quiz sessions (future)

```swift
// Future Phase 4 integration
// This is a research placeholder for now

import SocketIO

class StudyGroupManager: NSObject {
  let socket: SocketIOClient
  
  override init() {
    let manager = SocketManager(socketURL: URL(string: "https://api.flygaca.com")!)
    self.socket = manager.defaultSocket
    super.init()
    
    socket.on("message") { data, _ in
      if let message = data[0] as? [String: Any] {
        print("New message: \(message)")
      }
    }
  }
  
  func joinStudyGroup(groupId: String) {
    socket.emit("join-group", groupId)
  }
  
  func sendMessage(_ text: String) {
    socket.emit("send-message", ["text": text])
  }
}
```

---

## Medium-Term Upgrades (Q1-Q2 2027)

### 4. Image Loading & Caching: SDWebImage (Repo #54)

**Current:** No image caching for GACAR diagrams  
**Target:** SDWebImage for efficient image fetch + cache

```swift
import SDWebImage

// QuestionView with diagram
struct QuestionView: View {
  let question: Question
  
  var body: some View {
    VStack {
      Text(question.text)
      
      if let imageURL = question.imageURL {
        WebImage(url: imageURL)
          .resizable()
          .indicator(.activity)
          .transition(.fade(duration: 0.5))
          .scaledToFit()
          .frame(height: 300)
      }
    }
  }
}
```

### 5. Firebase Integration Hardening (Repo #52)

**Current:** Basic Firebase setup (Auth, Firestore)  
**Target:** App Check, secure rules, quota gating

```swift
// Configure App Check
let provider = AppCheckDebugProvider(resourceName: nil) // use production provider
AppCheck.setAppCheckProvider(provider)

// Configure Firestore with local cache
let settings = FirestoreSettings()
settings.isPersistenceEnabled = true
Firestore.firestore().settings = settings

// Secure Firestore rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /learners/{learnerId} {
      allow read, write: if request.auth.uid == learnerId;
      allow read: if request.auth.token.role == 'instructor';
    }
  }
}
```

---

## Testing Strategy

### Unit Tests (Swift)

```swift
// Tests/StudyEnginesTests/LeitnerTests.swift
import XCTest
@testable import StudyEngines

final class LeitnerTests: XCTestCase {
  func testCorrectAnswerPromotesBox() {
    var card = StudyCard(box: 0, dueDate: .today)
    let result = LeitnerEngine.processResult(card: &card, isCorrect: true)
    
    XCTAssertEqual(card.box, 1, "Correct answer should promote from box 0 to 1")
    XCTAssertEqual(card.dueDate, .tomorrow, "Due date should be 1 day")
  }
  
  func testWrongAnswerResetsBox() {
    var card = StudyCard(box: 3, dueDate: .today)
    let result = LeitnerEngine.processResult(card: &card, isCorrect: false)
    
    XCTAssertEqual(card.box, 0, "Wrong answer should reset box to 0")
    XCTAssertEqual(card.dueDate, .today, "Due date should reset to today")
  }
  
  func testMasteredCardIsNotDue() {
    let card = StudyCard(box: 5, dueDate: .tomorrow)
    let isDue = LeitnerEngine.isDue(card: card, today: .today)
    
    XCTAssertFalse(isDue, "Mastered card (box 5) should not be due")
  }
}
```

### Integration Tests (SwiftUI)

```swift
// Tests/AppleTests/QuizFlowTests.swift
import XCTest

final class QuizFlowTests: XCTestCase {
  func testCompleteQuizFlow() async {
    // 1. Load quiz
    let quiz = try await contentStore.loadQuiz(moduleId: "elpt")
    
    // 2. Answer all questions
    for (index, question) in quiz.questions.enumerated() {
      studyStore.submitAnswer(question.id, option: question.correctOption!.id)
    }
    
    // 3. Submit quiz
    let score = await studyStore.submitQuiz()
    
    // 4. Verify score calculated correctly
    XCTAssertEqual(score, 100, "Perfect answers should yield 100%")
    
    // 5. Verify progress updated
    let progress = await studyStore.getLearnerProgress()
    XCTAssertGreaterThan(progress.quizzesCompleted, 0)
  }
}
```

### Performance Testing

```swift
// Tests/AppleTests/PerformanceTests.swift
func testQuizLoadPerformance() {
  self.measure {
    let quiz = ContentStore.loadQuiz(moduleId: "elpt")
    // Should load <500ms for bundled content
  }
}
```

---

## Capacitor Bridge (React ↔ Native)

**For iOS web view fallback or hybrid features:**

```typescript
// web/src/hooks/useNativeCapabilities.ts
import { Capacitor } from '@capacitor/core'
import { Camera } from '@capacitor/camera'

export function useNativeCapabilities() {
  const isNative = Capacitor.isNativePlatform()
  
  const takeScreenshot = async () => {
    if (isNative) {
      const result = await Camera.getPhoto({
        quality: 90,
        allowEditing: false,
        resultType: CameraResultType.Base64,
      })
      return result.base64String
    } else {
      // Fallback: use html2canvas
      return await captureToDataURL()
    }
  }
  
  return { isNative, takeScreenshot }
}
```

---

## Deployment Checklist

### Development

- [ ] `swift build` completes instantly (<10s)
- [ ] `swift test` runs all tests (<30s)
- [ ] Zero external SDK dependencies
- [ ] Preview in Xcode works for all views
- [ ] App Group entitlements set (group.com.FlyGACA)

### Testing

- [ ] Unit tests cover CoreModels, StudyEngines, ContentKit
- [ ] Integration tests for SwiftData store operations
- [ ] UI tests for quiz flow (both EN and AR)
- [ ] Performance tests: quiz load <500ms

### App Store Submission

- [ ] Screenshots generated (portrait + landscape)
- [ ] App listing updated (EN + AR)
- [ ] TestFlight build approved
- [ ] Private API scan passed

---

## References

- [Swift Composable Architecture Docs](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture)
- [Alamofire Guide](https://github.com/Alamofire/Alamofire)
- [Socket.io Swift Client](https://github.com/socketio/socket.io-client-swift)
- [SDWebImage Docs](https://github.com/SDWebImage/SDWebImage)
- [Firebase iOS Docs](https://firebase.google.com/docs/ios/setup)

---

**Maintained by:** Claude Code  
**Last Updated:** 2026-09-11  
**Next Review:** 2026-10-11

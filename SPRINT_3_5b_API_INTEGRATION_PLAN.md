# SPRINT 3.5b: API Integration Plan

## 🎯 Overview

Integrate 2 major API-powered features into Phase 3.5:
1. **② AIはかせチャット** - Claude API for intelligent tutoring
2. **④ 今夜の空** - OpenWeatherMap + Astronomy for night sky observation

**Estimated Effort:** 3-5 days  
**Complexity:** Medium-High  
**New Lines:** ~1,500  
**Files:** ~15 new + 5 updated

---

## 📋 Feature Specifications

### Feature ②: AIはかせチャット (AI Professor Chat)

**Purpose:** Interactive AI-powered science tutor using Claude API

**Key Features:**
- Real-time chat with Claude AI
- Science topic expertise
- Conversation history persistence
- Rate limiting (monthly quota)
- Streaming responses
- Error recovery

**User Flow:**
```
Home → Chat Icon → AIはかせChat Screen
       ↓
       Conversation List
       ↓
       Select/Create Chat
       ↓
       Message Input → AI Response (streaming)
       ↓
       Save to Firestore
```

**Technical Stack:**
- Claude API (Messages API)
- Streaming responses
- SharedPreferences for local cache
- Firestore for cloud sync
- Riverpod for state management

---

### Feature ④: 今夜の空 (Tonight's Sky)

**Purpose:** Real-time night sky observation with weather and astronomy data

**Key Features:**
- Real-time weather from current location
- Moon phase calculation
- Constellation identification
- Star chart simulation
- Astronomy calendar
- Location-based sky chart

**User Flow:**
```
Home → Sky Icon → Tonight's Sky Screen
       ↓
       Request Location Permission
       ↓
       Fetch Weather + Astronomy Data
       ↓
       Display Sky Chart
       ↓
       Show Moon Info + Stars
```

**Technical Stack:**
- OpenWeatherMap API (free tier)
- Geolocator plugin for GPS
- Astronomy calculations (dart_astro or custom)
- Custom Canvas for sky chart rendering
- Riverpod for state management

---

## 🏗️ Architecture Design

### STEP 3.5b-1: API Client Setup

**File:** `lib/services/api_clients/`

```
lib/services/api_clients/
├── claude_api_client.dart        (250 lines)
│   ├── ClaudeApiClient class
│   ├── Message streaming
│   ├── Rate limiting
│   └── Error handling
│
├── weather_astronomy_client.dart (200 lines)
│   ├── WeatherClient class
│   ├── AstronomyCalculator class
│   └── Location services
│
└── api_config.dart               (50 lines)
    ├── API endpoints
    ├── API keys config
    └── Rate limit constants
```

### STEP 3.5b-2: Data Models & State

**Files:** `lib/features/ai_professor/` and `lib/features/sky/`

```
lib/features/ai_professor/
├── models/
│   ├── chat_message_model.dart   (Freezed)
│   ├── chat_session_model.dart   (Freezed)
│   └── api_response_model.dart   (Freezed)
├── providers/
│   ├── chat_provider.dart        (Chat state)
│   ├── chat_history_provider.dart (History management)
│   └── rate_limit_provider.dart  (Quota tracking)
└── views/
    └── ai_chat_screen.dart       (Main UI)

lib/features/sky/
├── models/
│   ├── weather_model.dart        (Freezed)
│   ├── astronomy_model.dart      (Freezed)
│   └── location_model.dart       (Freezed)
├── providers/
│   ├── weather_provider.dart     (Current weather)
│   ├── astronomy_provider.dart   (Astronomy data)
│   └── location_provider.dart    (GPS location)
└── views/
    ├── night_sky_screen.dart     (Main UI)
    └── widgets/
        ├── sky_chart_widget.dart (Canvas rendering)
        └── weather_info_widget.dart
```

---

## 🔧 Implementation Tasks

### STEP 3.5b-1: Claude API Integration

**1. Setup Claude API Client**

Create `lib/services/api_clients/claude_api_client.dart`:

```dart
class ClaudeApiClient {
  final String apiKey;
  static const String _baseUrl = 'https://api.anthropic.com/v1';
  
  ClaudeApiClient({required this.apiKey});
  
  // Streaming messages with rate limiting
  Future<Stream<String>> streamMessage(
    String userMessage,
    List<ChatMessage> history,
  ) async {
    // Implement streaming with rate limiting
    // Return token stream for UI updates
  }
  
  // System prompt for science tutoring
  String get systemPrompt => '''
  You are an experienced science teacher for elementary school students (grades 3-6).
  Explain scientific concepts in:
  - Simple, age-appropriate language
  - Interactive and engaging way
  - With real-world examples
  - Encouraging curiosity
  
  Use Japanese for responses.
  ''';
}
```

**2. Create Chat Models**

`lib/features/ai_professor/models/chat_message_model.dart`:

```dart
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String content,
    required ChatRole role, // user, assistant
    required DateTime timestamp,
    String? imageUrl,
  }) = _ChatMessage;
}

enum ChatRole { user, assistant }
```

**3. Implement Chat Provider**

`lib/features/ai_professor/providers/chat_provider.dart`:

```dart
// State for active chat
final chatSessionProvider = StateNotifierProvider<
  ChatSessionNotifier,
  ChatSession
>((ref) => ChatSessionNotifier());

// History provider
final chatHistoryProvider = FutureProvider((ref) async {
  // Load from Firestore
});

// Rate limit provider
final rateLimitProvider = StateProvider((ref) => RateLimitInfo());
```

**4. Build Chat UI**

`lib/features/ai_professor/views/ai_chat_screen.dart`:

```dart
class AiChatScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  // Message list with streaming responses
  // Text input with send button
  // Loading indicator during response
  // Error handling with retry
}
```

---

### STEP 3.5b-2: Weather & Astronomy Integration

**1. Setup Weather/Astronomy Client**

`lib/services/api_clients/weather_astronomy_client.dart`:

```dart
class WeatherClient {
  final String apiKey; // OpenWeatherMap
  
  Future<WeatherData> getCurrentWeather(
    double latitude,
    double longitude,
  ) async {
    // Fetch from OpenWeatherMap
    // Parse JSON to model
  }
}

class AstronomyCalculator {
  // Moon phase calculation
  MoonPhase getMoonPhase(DateTime date) {
    // Calculate from date
  }
  
  // Constellation visibility
  List<Constellation> getVisibleConstellations(
    double latitude,
    double longitude,
    DateTime dateTime,
  ) {
    // Calculate based on location & time
  }
}
```

**2. Create Weather/Astronomy Models**

```dart
@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    required double temperature,
    required double cloudCover,
    required double visibility,
    required String description,
    required int sunsetTime,
  }) = _WeatherData;
}

@freezed
class AstronomyData with _$AstronomyData {
  const factory AstronomyData({
    required MoonPhase moonPhase,
    required List<Constellation> visibleConstellations,
    required double lightPollution,
  }) = _AstronomyData;
}
```

**3. Implement Location Permission**

`lib/services/location_service.dart`:

```dart
class LocationService {
  Future<Location> getCurrentLocation() async {
    // Request permission
    // Get GPS coordinates
    // Handle errors
  }
  
  Future<bool> requestLocationPermission() async {
    // Show permission dialog
    // Request from device
  }
}
```

**4. Build Sky Chart Canvas**

`lib/features/sky/widgets/sky_chart_widget.dart`:

```dart
class SkyChartWidget extends CustomPainter {
  // Paint stars
  // Paint constellations
  // Paint moon
  // Draw coordinate grid
  
  void paintSky(Canvas canvas, Size size) {
    // Render night sky
  }
}
```

**5. Build UI Screens**

- `ai_chat_screen.dart` - Chat interface
- `night_sky_screen.dart` - Sky observation
- Supporting widgets

---

## 📦 Dependencies to Add

**pubspec.yaml additions:**

```yaml
dependencies:
  # API & HTTP
  http: ^1.1.0
  dio: ^5.4.0

  # Location
  geolocator: ^13.0.0
  permission_handler: ^11.4.4

  # Astronomy calculations (optional)
  # dart_astro: ^0.1.0

  # Local storage
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Image caching
  cached_network_image: ^3.4.0

  # Environment variables
  flutter_dotenv: ^5.2.0

  # UUID for message IDs
  uuid: ^4.0.0
```

---

## 🔐 Environment Configuration

**Create `.env` file** (add to `.gitignore`):

```env
CLAUDE_API_KEY=sk-ant-[your-key]
OPENWEATHERMAP_API_KEY=[your-key]
CLAUDE_API_BASE_URL=https://api.anthropic.com/v1
OPENWEATHERMAP_BASE_URL=https://api.openweathermap.org/data/2.5
```

**Load in main.dart:**

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  // ...
}
```

---

## 🎯 Implementation Priority

### Priority 1: Claude API (HIGH)
- ✅ Most engaging user feature
- ✅ Core brand differentiator
- ✅ Highest ROI
- Estimated: 2 days

### Priority 2: Weather/Astronomy (MEDIUM)
- ✅ Educational value
- ✅ Real-world application
- ✅ Cool factor
- Estimated: 2-3 days

---

## 📊 Code Metrics

| Component | Lines | Complexity |
|-----------|-------|-----------|
| Claude API Client | 250 | High |
| Chat Models | 100 | Medium |
| Chat UI | 300 | High |
| Chat Providers | 150 | Medium |
| Weather Client | 150 | Medium |
| Astronomy Calc | 200 | High |
| Sky Models | 80 | Medium |
| Sky UI | 250 | High |
| Location Service | 100 | Medium |
| Config & Setup | 100 | Low |
| **Total** | **1,680** | |

---

## 🧪 Testing Strategy

### Unit Tests
- API client methods
- Astronomy calculations
- Data model conversions
- Rate limiting logic

### Integration Tests
- API calls (with mock responses)
- Firestore integration
- Location permission flow
- Error handling

### UI Tests
- Chat message display
- Streaming response UI
- Sky chart rendering
- Weather information display

---

## 🚀 Deployment Checklist

- [ ] API keys safely configured in `.env`
- [ ] Rate limiting implemented
- [ ] Error handling comprehensive
- [ ] Offline mode fallback
- [ ] Cache management
- [ ] Permission requests clear
- [ ] Loading states visible
- [ ] Error messages helpful
- [ ] Accessibility checked
- [ ] Performance profiled

---

## 📅 Timeline

### Day 1: Setup & Claude API
- [ ] Dependencies added
- [ ] API client setup
- [ ] Chat models created
- [ ] Basic UI started

### Day 2: Chat Feature Complete
- [ ] Chat UI complete
- [ ] Streaming responses working
- [ ] History persistence
- [ ] Rate limiting active
- [ ] Error handling robust

### Day 3: Weather/Astronomy Setup
- [ ] Location service
- [ ] Weather API integration
- [ ] Astronomy calculations
- [ ] Models created

### Day 4: Sky Feature Complete
- [ ] Sky chart rendering
- [ ] Weather display
- [ ] Astronomy data show
- [ ] Full integration

### Day 5: Polish & Testing
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] User testing
- [ ] Documentation

---

## 🎓 Key Concepts

### Streaming Responses
- Real-time token-by-token UI updates
- Smooth text rendering
- Cancel mechanism

### Rate Limiting
- Track API usage
- Show quota to user
- Graceful degradation

### Astronomy Calculations
- Moon phase from date
- Star/constellation visibility
- Light pollution estimates

### Canvas Rendering
- Custom paint for sky chart
- Coordinate system
- Performance optimization

---

## ⚡ Next Steps

1. **Add dependencies** to pubspec.yaml
2. **Setup environment** variables
3. **Create API clients** (Claude + Weather)
4. **Build data models** (Freezed models)
5. **Implement providers** (state management)
6. **Create UI screens** (chat + sky)
7. **Test thoroughly** (unit + integration + UI)
8. **Deploy & monitor** (watch error rates)

---

**Ready to begin implementation?** 🚀

Generated: 2026-09-03
Phase 3.5b Sprint Planning - API Integration

# Phase 3.5 Innovation Features - Implementation Plan

## 📋 Overview

Phase 3.5 adds 10 revolutionary features to transform the science learning app into an interactive, multi-dimensional learning platform. Total estimated: **3,500+ new lines of code** across 3 implementation sprints.

---

## 🎯 Features Summary

### ✅ **Already Implemented** (~800 lines existing)
| # | Feature | Japanese | Purpose | Status |
|---|---------|----------|---------|--------|
| ① | Prediction Lab | よそうラボ | Hypothesis → Experiment → Result flow | 🟢 UI Complete |
| ⑥ | Troubleshoot Lab | 失敗ラボ推理 | Problem diagnosis through reasoning | 🟢 Data Complete |
| ⑦ | Seasonal Sync | 季節シンクロ配信 | 12-month seasonal recommendations | 🟢 Widget Complete |
| ⑨ | Parent-Child Battle | 親子バトル化 | Multiplayer prediction battles | 🟢 Logic Complete |

### 🟡 **Needs Implementation** (~2,700 new lines)
| # | Feature | Japanese | API/Tech | Priority |
|---|---------|----------|----------|----------|
| ② | AI Professor Chat | AIはかせチャット | Claude API | 🥇 **1st** |
| ④ | Tonight's Sky | 今夜の空 | OpenWeatherMap, Astronomy | 🥈 **2nd** |
| ⑤ | Creature Camera | いきものカメラ | Claude Vision, Camera | 🥉 **3rd** |
| ⑧ | Time Travel | タイムトラベル拡張 | Story content | 🔵 **4th** |
| ⑩ | Cross-Subject Badges | 教科横断バッジ | shared_core | 🔵 **5th** |

---

## 📅 Implementation Timeline

### **SPRINT 3.5a: Integration & Polish** (2-3 days)
**Goal:** Activate existing features, create cohesive UX

**STEP 3.5a-1: Navigation Integration**
- [ ] Add experiments tab to bottom navigation
- [ ] Add battle mode to home screen
- [ ] Add seasonal recommendations widget to home
- [ ] Create feature discovery/onboarding UI

**STEP 3.5a-2: Provider & State Wiring**
- [ ] Connect prediction_provider to UI
- [ ] Connect battle_provider to battle_screen
- [ ] Connect seasonal_provider to home widget
- [ ] Add error handling & loading states

**STEP 3.5a-3: UI/UX Polish**
- [ ] Smooth animations between screens
- [ ] Consistent theming (light/dark)
- [ ] Empty states & error messages
- [ ] Performance optimization

**Deliverable:** Feature-complete Phase 3.5a (0 → 4 features live)

---

### **SPRINT 3.5b: API Integration** (3-5 days)
**Goal:** Connect external APIs for intelligent features

**STEP 3.5b-1: Claude API Integration (AIはかせチャット)**
- [ ] Set up Claude API client with auth
- [ ] Implement streaming response UI
- [ ] Add conversation history & context
- [ ] Rate limiting (月制限付き / monthly quota)
- [ ] Prompt engineering for science tutoring
- [ ] Error handling for API failures

**Code:** `lib/services/claude_api_service.dart` (~250 lines)
**UI:** `lib/features/ai_professor/screens/chat_screen.dart` (~200 lines)

**STEP 3.5b-2: Weather & Astronomy (今夜の空)**
- [ ] OpenWeatherMap API integration
- [ ] Real-time location-based weather
- [ ] Astronomy calculations (moon phase, constellations)
- [ ] Sky chart rendering
- [ ] Time-lapse simulation

**Code:** `lib/services/weather_astronomy_service.dart` (~300 lines)
**UI:** `lib/features/sky/screens/night_sky_screen.dart` (~250 lines)

**Deliverable:** Feature-complete Phase 3.5b (4 → 6 features live)

---

### **SPRINT 3.5c: Vision & Polish** (2-3 days)
**Goal:** Add remaining features & optimize

**STEP 3.5c-1: Creature Camera (いきものカメラ)**
- [ ] Camera integration (camera plugin)
- [ ] Claude Vision API for image analysis
- [ ] Real-time creature identification
- [ ] Learn facts from identified creatures
- [ ] Photo gallery & saved creatures

**Code:** `lib/features/creature_camera/services/vision_service.dart` (~200 lines)
**UI:** `lib/features/creature_camera/screens/camera_screen.dart` (~200 lines)

**STEP 3.5c-2: Story & Badges**
- [ ] Time travel story content (historian profiles)
- [ ] Cross-subject badge system
- [ ] Achievement tracking
- [ ] Badge showcase screen

**Code:** `lib/features/stories/data/scientist_stories.dart` (~150 lines)
**UI:** `lib/features/achievements/screens/badges_screen.dart` (~150 lines)

**STEP 3.5c-3: Performance & Polish**
- [ ] Optimize image loading
- [ ] Cache API responses
- [ ] Battery optimization for camera
- [ ] Network efficiency

**Deliverable:** Feature-complete Phase 3.5 (6 → 10 features live)

---

## 🏗️ Architecture & File Structure

```
lib/
├── services/
│   ├── claude_api_service.dart (NEW - Claude API client)
│   ├── weather_astronomy_service.dart (NEW - Weather + Astronomy)
│   └── vision_service.dart (NEW - Claude Vision)
│
├── features/
│   ├── experiments/ (EXISTING - よそうラボ)
│   │   ├── data/
│   │   │   ├── troubleshoot_data.dart ✅
│   │   │   └── prediction_quiz_data.dart (NEW)
│   │   ├── providers/
│   │   │   ├── prediction_provider.dart ✅
│   │   │   └── battle_provider.dart (NEW)
│   │   ├── views/
│   │   │   ├── experiment_tab_screen.dart ✅
│   │   │   ├── experiment_detail_screen.dart ✅
│   │   │   ├── prediction_quiz_screen.dart ✅
│   │   │   └── troubleshoot_screen.dart ✅
│   │   └── widgets/
│   │       ├── prediction_step_widget.dart ✅
│   │       └── prediction_result_widget.dart ✅
│   │
│   ├── ai_professor/ (NEW - AIはかせチャット)
│   │   ├── services/
│   │   │   └── claude_api_service.dart
│   │   ├── providers/
│   │   │   └── chat_provider.dart
│   │   ├── views/
│   │   │   └── chat_screen.dart
│   │   └── widgets/
│   │       ├── chat_message_bubble.dart
│   │       └── typing_indicator.dart
│   │
│   ├── sky/ (NEW - 今夜の空)
│   │   ├── services/
│   │   │   └── weather_astronomy_service.dart
│   │   ├── views/
│   │   │   └── night_sky_screen.dart
│   │   └── widgets/
│   │       ├── sky_canvas.dart
│   │       └── weather_widget.dart
│   │
│   ├── creature_camera/ (NEW - いきものカメラ)
│   │   ├── services/
│   │   │   └── vision_service.dart
│   │   ├── views/
│   │   │   └── camera_screen.dart
│   │   └── widgets/
│   │       ├── camera_preview.dart
│   │       └── creature_info_card.dart
│   │
│   ├── stories/ (NEW - タイムトラベル)
│   │   ├── data/
│   │   │   └── scientist_stories.dart
│   │   └── views/
│   │       └── story_screen.dart
│   │
│   ├── achievements/ (NEW - 教科横断バッジ)
│   │   ├── providers/
│   │   │   └── badge_provider.dart
│   │   └── views/
│   │       └── badges_screen.dart
│   │
│   ├── home/ (UPDATED)
│   │   └── widgets/
│   │       └── seasonal_recommendation_widget.dart ✅
│   │
│   └── battle/ (EXISTING - 親子バトル化)
│       ├── data/
│       │   └── prediction_battle_data.dart ✅
│       └── views/
│           └── prediction_battle_screen.dart ✅
│
└── main.dart (UPDATED - Add new routes/navigation)
```

---

## 🛠️ Key Technologies

### API Services
| Service | Purpose | Auth | Cost |
|---------|---------|------|------|
| **Claude API** | AI tutoring chat | API Key | Pay-as-you-go |
| **OpenWeatherMap** | Real-time weather | API Key | Free tier available |
| **Claude Vision** | Image analysis | Same as Claude | Included |
| **Camera Plugin** | Photo capture | Device permission | Free |

### Packages to Add
```yaml
# pubspec.yaml additions
camera: ^0.11.0          # Camera access
image_picker: ^1.1.0     # Photo selection
cached_network_image: ^3.4.0  # Image caching
flutter_dotenv: ^5.2.0   # Environment variables (API keys)
geolocator: ^13.0.0      # GPS location
intl: ^0.19.0            # Localization
```

---

## 📊 Code Metrics

| Component | Lines | Complexity | Priority |
|-----------|-------|-----------|----------|
| **SPRINT 3.5a** | ~600 | Low-Medium | 🟢 Immediate |
| Integration + wiring | 400 | Low | |
| UI Polish | 200 | Low | |
| | | | |
| **SPRINT 3.5b** | ~1,000 | High | 🟡 Week 1 |
| Claude API service | 250 | High | |
| Claude API UI | 200 | Medium | |
| Weather + Astronomy | 300 | High | |
| Sky UI | 250 | Medium | |
| | | | |
| **SPRINT 3.5c** | ~1,100 | Medium-High | 🔵 Week 2 |
| Vision service | 200 | High | |
| Camera UI | 250 | Medium | |
| Stories + Badges | 300 | Low | |
| Polish + Optimization | 350 | Medium | |
| | | | |
| **TOTAL** | **2,700** | Medium | |

---

## 🔐 Environment Variables Required

Create `.env` file for API keys:

```env
# .env (add to .gitignore)
CLAUDE_API_KEY=sk-ant-...
OPENWEATHERMAP_API_KEY=...
CLAUDE_API_BASE_URL=https://api.anthropic.com/v1
```

Load in code:
```dart
// main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}
```

---

## ✅ Integration Checklist

### Before SPRINT 3.5a
- [ ] Review existing code in lib/features/experiments
- [ ] Check navigation_provider for bottom navigation
- [ ] Verify home_screen.dart structure
- [ ] Review theme provider for consistency

### Before SPRINT 3.5b
- [ ] Set up Claude API account
- [ ] Get OpenWeatherMap API key
- [ ] Test API connectivity
- [ ] Document rate limits

### Before SPRINT 3.5c
- [ ] Add camera & image_picker to pubspec.yaml
- [ ] Test camera permissions on device
- [ ] Set up shared_core integration
- [ ] Review badge system requirements

---

## 🚀 Next Steps

1. **Confirm SPRINT 3.5a scope** with team
2. **Start STEP 3.5a-1** - Navigation integration
3. **Set up feature branch:** `claude/phase-3-5-integration`
4. **Daily standups** on progress

---

## 📚 Reference Docs

- **CLAUDE.md** - Feature descriptions
- **BUILD_AND_DEPLOY_CHECKLIST.md** - Build process
- **STEP_5_TESTING_GUIDE.md** - Testing methodology
- **API Documentation** - Claude, OpenWeatherMap, Vision APIs

---

**Ready to start SPRINT 3.5a?** 🎯

Generated: 2026-09-03
Phase 3.5 Innovation Features Planning

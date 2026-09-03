# SPRINT 3.5b Integration Test Checklist

**Date:** 2026-09-03  
**Tester:** [Your Name]  
**Device:** [Device/Emulator]  
**Build:** [APK Version]

---

## 🧪 Pre-Test Setup

### Environment Verification

```
□ .env file created with valid API keys
  - CLAUDE_API_KEY: sk-ant-xxxxx
  - OPENWEATHERMAP_API_KEY: xxxxx

□ Device/Emulator ready
  - Device: [Pixel 4 / Pixel 6 Pro / iPhone]
  - API Level: [33 / 34 / iOS 16+]
  - Connection: WiFi (stable)

□ App build fresh
  - Run: flutter clean && flutter pub get
  - Build: flutter run --release (or debug)
  - No crashes on startup
```

### Test Account Setup

```
□ Fresh install (optional)
  - Uninstall previous version
  - Install fresh build
  
□ Permissions cleared (optional)
  - App Settings > Permissions > All off
  - Restart app
  
□ SharedPreferences cleared (optional)
  - Android: adb shell pm clear com.example.shokollen_science
  - iOS: Delete app and reinstall
```

---

## ✅ TEST SECTION 1: AI CHAT SCREEN

### TC-001: Screen Load & Empty State

```
□ Step 1: Navigate to AI Chat Screen
  Expected: Screen loads within 2 seconds

□ Step 2: Verify empty state display
  Expected: 
  - "こんにちは！🧑‍🏫" heading visible
  - "科学に関する質問をなんでも..." explanation visible
  - 3 suggestion chips display:
    ✓ "虹はなぜできるのか"
    ✓ "星座について"
    ✓ "植物の根の役割"

□ Step 3: Verify UI elements
  Expected:
  - AppBar shows "🧑‍🏫 AIはかせチャット"
  - Subtitle shows "科学について何でも聞いてね！"
  - New chat button (+) visible in top right
  - Quota indicator visible in toolbar (50/50)

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-002: Suggestion Chip Interaction

```
□ Step 1: Tap first suggestion chip
  ("虹はなぜできるのか")
  Expected: Text fills message input field

□ Step 2: Tap input field
  Expected: Soft keyboard opens

□ Step 3: Verify text is preset
  Expected: Message field contains "虹はなぜできるのか"

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-003: Message Sending (First Message)

```
□ Step 1: Tap message input field
  Expected: Keyboard opens, cursor visible

□ Step 2: Type message: "光はなぜ直進するのか？"
  Expected: Text appears in input field

□ Step 3: Tap send button (paper plane icon)
  Expected: 
  - Message appears in chat as user message (blue, right-aligned)
  - Input field clears
  - Loading indicator appears (3 animated dots)

□ Step 4: Wait for response (10-20 seconds)
  Expected:
  - Loading animation stops
  - Assistant response appears (grey, left-aligned)
  - Response in Japanese for grades 3-6
  - Message contains coherent explanation
  - ~500-800 characters typical

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Timeline: _____ seconds to first token, _____ seconds for full response
```

### TC-004: Message Streaming Display

```
□ Step 1: Send message (use suggestion if needed)
  Expected: Loading animation appears

□ Step 2: Observe response generation carefully
  Expected:
  - Response appears character by character (NOT all at once)
  - Each token appears incrementally
  - Text flows naturally into chat bubble
  - No blank message first then fill

□ Step 3: Verify final message
  Expected:
  - Complete, coherent response
  - Proper Japanese grammar
  - Age-appropriate vocabulary
  - No truncation

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-005: Quota Indicator

```
□ Step 1: Check toolbar quota display
  Expected: 
  - Shows used/total format: "X/50"
  - Updates after each message
  - After 1st message: should show "1/50"

□ Step 2: Send multiple messages (5-10 total)
  Expected:
  - Quota increments: 2/50, 3/50, etc.
  - Quota indicator updates immediately
  - No delay in quota updates

□ Step 3: Hover/tap quota indicator
  Expected:
  - Tooltip shows full status
  - Days until reset shown

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Current quota: ___/50
```

### TC-006: Quota Warning Banner

```
Note: Only appears when < 5 requests remaining
To test: Modify SharedPreferences to set monthlyUsed = 46

□ Step 1: Set quota to 46/50 (4 remaining)
  Expected: 
  - Orange warning banner appears below AppBar
  - Message: "クエリが残り4回です..."
  - "日後にリセット" message shows

□ Step 2: Send message
  Expected: Quota updates to 47/50

□ Step 3: When quota reaches 50
  Expected: Warning banner disappears

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-007: Quota Exceeded

```
Note: Set monthlyUsed = 50 via SharedPreferences for quick testing

□ Step 1: Set quota to 50/50 (0 remaining)
  Expected: 
  - Cannot send new message
  - Send button disabled

□ Step 2: Try to send message anyway
  Expected:
  - Dialog appears: "月間クエリ上限に達しました"
  - Message: "1ヶ月間のクエリ数が上限（50回）に達しました"
  - Shows "~日後にリセットされます"

□ Step 3: Tap OK button
  Expected: Dialog closes

□ Step 4: Input field still functional
  Expected: Can type but cannot send

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-008: Conversation History

```
□ Step 1: Send 3 messages (with responses)
  Message 1: "虹はなぜできるのか"
  Message 2: "光の性質について教えて"
  Message 3: "目はどうやって光を感じているの"

□ Step 2: Observe chat list
  Expected:
  - All 6 messages (3 user + 3 assistant) visible
  - Correct order (oldest at top)
  - User messages on right (blue)
  - Assistant messages on left (grey)

□ Step 3: Scroll up and down
  Expected:
  - All messages remain visible
  - Smooth scrolling
  - No jank or stutter

□ Step 4: Verify timestamps
  Expected:
  - Each message shows HH:mm timestamp
  - Times increment chronologically

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-009: Auto-Scroll on New Message

```
□ Step 1: Fill screen with 10+ messages (scroll required)
  Expected: Bottom of screen shows latest message

□ Step 2: Send new message
  Expected:
  - View automatically scrolls to bottom
  - New message visible immediately
  - No manual scrolling needed

□ Step 3: Continue sending messages
  Expected: Each new message auto-scrolls into view

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-010: New Chat Button

```
□ Step 1: With active conversation (3+ messages)
  Expected: Previous messages visible

□ Step 2: Tap new chat button (+) in top right
  Expected: Confirmation dialog appears:
  - Title: "新規チャットを開始しますか？"
  - Message: "現在の会話履歴は失われます。"
  - Buttons: キャンセル | 新規開始

□ Step 3: Tap キャンセル
  Expected:
  - Dialog closes
  - Messages preserved
  - Can see all previous messages

□ Step 4: Tap + button again
  Expected: Same dialog appears

□ Step 5: Tap 新規開始
  Expected:
  - Dialog closes
  - All messages cleared
  - Empty state shown again
  - Quota NOT reset

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-011: Error Handling - Network Error

```
□ Step 1: Turn off internet
  - Airplane mode ON
  - WiFi OFF

□ Step 2: Send message
  Expected:
  - No response (timeout after ~10 seconds)
  - Error dialog: "エラーが発生しました"
  - User message still appears
  - Input field re-enables

□ Step 3: Turn internet back on
  Expected: Can send messages again

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-012: Theme Toggle

```
□ Step 1: Send message to have content visible
  Expected: Message visible in current theme

□ Step 2: Go to Settings > Theme
  Expected: Can toggle Light/Dark

□ Step 3: Switch to Dark Mode
  Expected:
  - AppBar dark
  - Chat background dark
  - Message bubbles have appropriate colors
  - Text remains readable
  - All UI elements visible

□ Step 4: Send new message in Dark Mode
  Expected: New message renders with dark theme colors

□ Step 5: Switch back to Light Mode
  Expected: All colors revert to light theme

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

---

## ✅ TEST SECTION 2: NIGHT SKY SCREEN

### TC-013: Screen Load

```
□ Step 1: Navigate to Night Sky Screen (④今夜の空)
  Expected: 
  - Screen loads within 2 seconds
  - Location permission dialog appears (if first time)

□ Step 2: Grant location permission
  Expected:
  - Dialog closes
  - Starts acquiring GPS location
  - Loading spinner visible

□ Step 3: Wait for location
  Expected:
  - GPS location acquired (within 10 seconds)
  - Coordinates display: "緯度: XX.XXX°, 経度: XX.XXX°"

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Acquired Location: ___________________
```

### TC-014: Location Permission Flow (First Time)

```
□ Step 1: Uninstall app (or clear data)
  Expected: Fresh start

□ Step 2: Launch and navigate to Night Sky
  Expected:
  - Permission request dialog appears
  - Message: "位置情報へのアクセスを許可してください"

□ Step 3: Tap "許可"
  Expected:
  - Dialog closes
  - GPS acquisition starts
  - Loading indicator visible

□ Step 4: Location acquired
  Expected:
  - GPS coordinates display
  - Weather data starts loading

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-015: Location Permission Denial

```
□ Step 1: Clear app data
  Expected: Fresh start

□ Step 2: Navigate to Night Sky
  Expected: Permission dialog appears

□ Step 3: Tap "拒否"
  Expected:
  - Dialog closes
  - Falls back to Tokyo (東京)
  - Coordinates: 緯度: 35.6762°, 経度: 139.6503°
  - Weather loads for Tokyo

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Fallback Location: ___________________
```

### TC-016: Location Selector - Manual Override

```
□ Step 1: Location selector visible below AppBar
  Expected: 
  - Shows current location name
  - Shows GPS icon and Manual icon

□ Step 2: Tap location selector
  Expected: Bottom sheet modal opens:
  - Title: "観測場所を選択"
  - List of 4 cities visible:
    ✓ 東京 (Tokyo)
    ✓ 大阪 (Osaka)
    ✓ 札幌 (Sapporo)
    ✓ 福岡 (Fukuoka)

□ Step 3: Tap different city (e.g., 札幌)
  Expected:
  - Bottom sheet closes
  - Location updates to: 札幌, 43.0642°N, 141.3469°E
  - Weather/astronomy data refreshes for new location

□ Step 4: Tap another city (e.g., 福岡)
  Expected: Location updates to: 福岡, 33.5904°N, 130.4026°E

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Test Locations Selected: ___________
```

### TC-017: GPS Button

```
□ Step 1: Current location is manual (e.g., 札幌)
  Expected: Location shows city name

□ Step 2: Tap GPS icon button
  Expected:
  - Returns to automatic GPS location
  - Acquires fresh GPS coordinates
  - Weather/astronomy updates

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-018: Weather Card Display

```
□ Step 1: Observe weather card
  Expected: Shows:
  - Temperature: "26°C" (current)
  - Humidity: "65%"
  - Cloud coverage: "20%"
  - Visibility: "10km"
  - Weather emoji (☀️ / 🌧️ / ⛈️)

□ Step 2: Check suitability banner
  Expected:
  - Green banner if suitable (clouds < 30%)
  - Orange banner if unsuitable (clouds > 30%)
  - Message: "天体観測に適しています"/"観測に不向きな天気"

□ Step 3: Verify data updates
  Expected: Data matches location selected

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Weather Data: Temp ___, Humidity ___, Clouds ___, Visibility ___
```

### TC-019: Observation Score Card

```
□ Step 1: Observe score card
  Expected: Shows:
  - Score: "75/100"
  - Linear progress bar (proportional to score)
  - Color coding:
    - Green (80+)
    - Blue (60-80)
    - Orange (40-60)
    - Red (<40)

□ Step 2: Check assessment text
  Expected: Description matches score:
  - 90+: "最高の観測条件です"
  - 60-90: "良好な観測条件"
  - 40-60: "観測可能"
  - <40: "観測に不向きな天気"

□ Step 3: Check badge
  Expected: "👍 観測に適しています" or "ℹ️ 観測に不向き"

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Score: ___/100, Description: ______________
```

### TC-020: Moon Phase Card

```
□ Step 1: Observe moon phase card
  Expected: Shows:
  - Moon emoji visualization (based on phase)
  - Examples:
    - 新月: 🌑 (dark)
    - 上弦の月: 🌓 (half)
    - 満月: 🌕 (full)
    - 下弦の月: 🌗 (half)

□ Step 2: Check moon data
  Expected:
  - Moon age: "X days" (0-29.5)
  - Illumination: "XX%"
  - Phase name: "新月" / "上弦の月" / "満月" / etc.

□ Step 3: Verify accuracy for today
  Expected:
  - Data matches actual moon phase for 2026-09-03
  - Reference: Use timeanddate.com or NASA moon phase data

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Moon Age: ___ days, Illumination: __%, Phase: _________
```

### TC-021: Constellation List

```
□ Step 1: Scroll to constellation section
  Expected: Title: "🌟 今夜見える星座（X個）"

□ Step 2: Count visible constellations
  Expected: For Tokyo in September:
  - Should show 5-7 constellations
  - Examples: Orion, Cygnus, Lyra, Aquila, etc.

□ Step 3: Tap constellation expansion tile
  Expected: Expands to show:
  - Description: "説明文..."
  - Visible months: Chip badges (1月, 9月, etc.)
  - Bright star: "アルニタク" or similar
  - Visibility status: "🎯 今夜見える時間帯があります"

□ Step 4: Tap again to collapse
  Expected: Tile collapses

□ Step 5: Test all constellations
  Expected: All have descriptions and details

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Constellations Visible: _______________
```

### TC-022: Location-Based Constellation Filtering

```
□ Step 1: Set location to Tokyo (35°N)
  Expected: Observe visible constellations

□ Step 2: Change location to Sapporo (43°N)
  Expected:
  - Constellation list updates
  - Different visibility may change
  - Northern constellations more visible

□ Step 3: Change location to Fukuoka (33°N)
  Expected: Constellations change for southern location

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Tokyo constellations: ______________
Sapporo constellations: ______________
Fukuoka constellations: ______________
```

### TC-023: Pull-to-Refresh

```
□ Step 1: Scroll to top of screen
  Expected: See all sections

□ Step 2: Perform pull-to-refresh gesture
  Expected:
  - Refresh indicator appears
  - Weather data refreshes
  - Astronomy data recalculates
  - Animation completes

□ Step 3: Data updates
  Expected: Fresh data from API

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-024: Error Handling - Offline

```
□ Step 1: Enable Airplane Mode
  Expected: Weather still loads (from cache if available)

□ Step 2: Scroll to weather section
  Expected: Either shows cached data or error message

□ Step 3: Disable Airplane Mode
  Expected: Fresh data loads when pulled to refresh

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-025: Theme Toggle

```
□ Step 1: Current theme: Light
  Expected: Cards have light backgrounds

□ Step 2: Go to Settings > Theme > Dark Mode
  Expected:
  - Cards dark background
  - Text white
  - All elements readable
  - Icons visible

□ Step 3: Verify all cards in dark mode
  Expected:
  - Weather card: dark
  - Moon phase card: dark
  - Observation score: dark
  - Constellation list: dark

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

---

## 🔄 CROSS-FEATURE TESTS

### TC-026: Route Navigation

```
□ Step 1: From Home screen, tap "② AIはかせチャット"
  Expected: Navigates to AI Chat Screen

□ Step 2: Tap back button
  Expected: Returns to Home Screen

□ Step 3: From Home screen, tap "④ 今夜の空"
  Expected: Navigates to Night Sky Screen

□ Step 4: Tap back button
  Expected: Returns to Home Screen

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-027: Navigation Persistence

```
□ Step 1: Go to AI Chat Screen
□ Step 2: Send 3 messages
□ Step 3: Navigate to Night Sky Screen
□ Step 4: Navigate back to AI Chat Screen
  Expected: Messages still there (conversation persisted)

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
```

### TC-028: Memory Usage

```
□ Step 1: Open DevTools Memory profiler (if available)
□ Step 2: Use Chat screen: send 20 messages
  Expected: Memory < 150 MB

□ Step 3: Use Sky screen: load constellations
  Expected: No memory spike

□ Step 4: Navigate between screens repeatedly
  Expected: Memory stable, no unbounded growth

Status: ✓ PASS  ❌ FAIL
Notes: ________________________
Peak Memory: _____ MB
```

---

## 📊 SUMMARY

### Test Results

| Category | Pass | Fail | Total | % |
|----------|------|------|-------|---|
| AI Chat (TC-001 to TC-012) | ___ | ___ | 12 | __% |
| Night Sky (TC-013 to TC-025) | ___ | ___ | 13 | __% |
| Cross-Feature (TC-026 to TC-028) | ___ | ___ | 3 | __% |
| **TOTAL** | ___ | ___ | **28** | __% |

### Issues Found

```
Issue #1:
- Test ID: [e.g., TC-005]
- Description: [What failed]
- Steps to Reproduce: [How to trigger]
- Expected: [What should happen]
- Actual: [What actually happened]
- Severity: [Critical/High/Medium/Low]
- Status: [Open/In Progress/Fixed/Verified]

Issue #2:
- ...
```

### Tester Signature

```
Tester Name: _________________________
Date: _________________________
Time Spent: _____ hours
Sign-off: 🟢 Ready for Release / 🟡 Pending Fixes / 🔴 Major Issues
```

---

## ✅ ACCEPTANCE CRITERIA MET

When all tests pass, check these:

```
□ AI Chat feature is production-ready
□ Night Sky feature is production-ready
□ No critical defects
□ Performance acceptable (no major lags)
□ Memory usage reasonable
□ Error messages helpful
□ UI responsive and intuitive
□ Ready to merge to main branch
```

---

**Generated:** 2026-09-03  
**Version:** 1.0  
**Next Step:** Deploy to staging / Fix issues (if any)

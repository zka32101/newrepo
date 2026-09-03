# Local Testing Guide - SPRINT 3.5b

**Quick Reference for Running Tests on Your Machine**

---

## 🚀 5-Minute Setup

```bash
# 1. Clone/pull latest code
git pull origin claude/privacy-ranking-system-complete-286acr

# 2. Install dependencies
flutter pub get

# 3. Create .env file
cp .env.example .env
# Edit .env with your API keys:
# CLAUDE_API_KEY=sk-ant-xxxxx
# OPENWEATHERMAP_API_KEY=xxxxx
```

---

## 🧪 Run Tests (Choose One)

### Option A: Unit Tests Only (5 minutes)

```bash
# Run all unit tests
flutter test test/

# Expected: 25 tests pass ✅
```

### Option B: Manual Testing (2-3 hours)

1. Start app
   ```bash
   flutter run --release
   ```

2. Open `INTEGRATION_TEST_CHECKLIST.md`

3. Follow all 28 test cases:
   - TC-001 to TC-012: AI Chat tests
   - TC-013 to TC-025: Night Sky tests
   - TC-026 to TC-028: Cross-feature tests

4. Mark results (✅ PASS or ❌ FAIL)

### Option C: Quick Test (30 minutes)

**Critical Scenarios Only:**

```
AI Chat:
□ TC-003: Send message → verify streaming response
□ TC-007: Verify quota blocking at 50 requests

Night Sky:
□ TC-013: Open screen → acquire GPS location
□ TC-018: Verify weather data displays

Both:
□ TC-025: Toggle theme (light/dark)
□ Verify no crashes
```

---

## 📊 Expected Results

### Unit Tests
```
Running test/features/ai_professor/providers/...

Rate Limit Tests:
✓ initial state has 50 remaining quota
✓ recordRequest increments monthly usage
✓ isWithinQuota returns correct boolean
✓ monthly reset when new month starts
... (10 tests total)

Chat Provider Tests:
✓ initial state creates new session
✓ addMessage adds message to state
✓ resetSession clears all messages
✓ session immutability verified
... (15 tests total)

25 tests, 0 failures ✅
```

### Manual Tests
```
TC-001 to TC-012: AI Chat Screen
□ Screen loads
□ Empty state displays
□ Messages send and stream
□ Quota tracking works
□ Error handling functions
... (12 tests total)

TC-013 to TC-025: Night Sky Screen
□ GPS location acquires
□ Manual location selector works
□ Weather displays
□ Moon phase calculates
□ Constellations filter correctly
... (13 tests total)

TC-026 to TC-028: Cross-Feature
□ Navigation works
□ State persists
□ Memory usage acceptable
... (3 tests total)

28/28 tests passed ✅
```

---

## 🐛 Troubleshooting

### "API key invalid" Error
```bash
# Check .env exists and has keys
cat .env

# Keys should look like:
# CLAUDE_API_KEY=sk-ant-xxxxx
# OPENWEATHERMAP_API_KEY=xxxxxx
```

### "Location permission denied"
- Android: Settings > Apps > Permissions > Location > Allow
- iOS: Settings > [App Name] > Location > "While Using"

### "No internet connection"
- Disable Airplane Mode
- Connect to WiFi
- Check network connectivity: `ping google.com`

### "Test times out"
```bash
# Increase timeout
flutter test --timeout 60s
```

### "App crashes on startup"
```bash
# Clean rebuild
flutter clean
flutter pub get
flutter run
```

---

## ✅ Test Results Template

```markdown
# Test Results - [DATE]

**Tester:** [Your Name]
**Device:** [Device/Emulator]
**Build:** [APK/IPA version]

## Summary
- Unit Tests: 25/25 PASS ✅
- Manual Tests: 28/28 PASS ✅
- Issues Found: 0

## Environment
- Flutter: [version]
- Dart: [version]
- Device: [specs]

## Notes
[Any observations]

**Status:** ✅ READY FOR RELEASE
```

---

## 📋 Quick Checklist

Before signing off:

```
✅ Pre-Test
  □ .env file created with valid API keys
  □ flutter pub get completed
  □ Device/emulator ready
  □ Good internet connection

✅ Unit Tests
  □ Ran: flutter test test/
  □ Result: 25/25 passing
  □ No timeout errors

✅ Manual Tests (if doing full)
  □ Followed INTEGRATION_TEST_CHECKLIST.md
  □ All 28 tests documented
  □ Screenshots (optional) saved

✅ Post-Test
  □ No crashes observed
  □ Performance acceptable (60 FPS)
  □ Memory < 150MB
  □ All features functional
  □ Results documented

✅ Approval
  □ Ready to merge
  □ No blockers found
  □ Signed off by tester
```

---

## 📞 Quick Help

| Problem | Solution |
|---------|----------|
| Can't find .env | Run: `cp .env.example .env` |
| Module not found | Run: `flutter pub get` |
| API key wrong | Check: `echo $CLAUDE_API_KEY` |
| Tests won't run | Try: `flutter clean && flutter pub get` |
| GPS not working | Check: Permissions granted, Location enabled |
| Weather API fails | Check: Internet connection, API key valid |
| App too slow | Check: Device specs, close other apps |

---

## 🎯 Success Criteria

✅ **All tests pass**
- 25 unit tests: 0 failures
- 28 manual tests: 0 failures (or known issues logged)

✅ **No crashes**
- App stable throughout testing
- Graceful error handling

✅ **Performance acceptable**
- Memory < 150MB
- Scrolling at 60 FPS
- API responses < 2 seconds

✅ **Features work**
- Chat: Send messages, get responses
- Sky: Location, weather, constellations
- Both: Theme toggle, navigation

---

## 📚 Full Documentation

For detailed procedures, see:
- **Complete testing guide:** `INTEGRATION_TEST_CHECKLIST.md`
- **Quick reference:** `INTEGRATION_TESTING_QUICK_START.md`
- **Testing strategy:** `STEP_3_5b_4_INTEGRATION_TESTING_GUIDE.md`

---

## 🚀 Running Tests

```bash
# Quick test (5 min)
flutter test test/

# Full app test (2-3 hrs)
flutter run --release
# Then use INTEGRATION_TEST_CHECKLIST.md

# Generate coverage
flutter test --coverage
genhtml coverage/lcov.report.dart -o coverage/html
```

---

**Happy Testing! 🎉**

Generated: 2026-09-03

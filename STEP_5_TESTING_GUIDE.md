# STEP 5 Auto-Grade Advancement - Testing Guide

## Pre-Build Checklist ✅

### Code Generation
Before building, run code generation for Freezed, Riverpod, and JSON serialization:

```bash
# Get dependencies
flutter pub get

# Run build_runner for code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build Commands

#### Debug Build (Recommended for Testing)
```bash
# Android Debug APK
flutter build apk --debug

# Output: build/app/outputs/flutter-apk/app-debug.apk
```

#### Release Build
```bash
# Android Release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## Test Scenarios

### 1. Initial Grade Assignment (First Time User)
**Test:** New user with no startMonth set

**Steps:**
1. Create new user profile (Grade 3)
2. Open app - Grade advancement checker should run
3. Check Firestore: `users/{uid}.startMonth` should be set to current month
4. No dialog should show (not April yet unless it's April)

**Expected Results:**
- ✅ startMonth initialized (e.g., 9 for September)
- ✅ No celebration dialog (not advancement, just init)
- ✅ Firebase updated with startMonth
- ✅ Grade remains same

**Verification:**
```bash
# Check Firebase console
firebase emulator:start  # or view in Firebase console

# Firestore path: users/{uid}
# Fields: startMonth (int), lastGradeAdvancementDate (string or null)
```

---

### 2. No Advancement (Before April)
**Test:** User in non-April month

**Steps:**
1. Start app in December/January/February/March
2. Open home screen or ranking screen
3. Grade advancement checker runs

**Expected Results:**
- ✅ No advancement dialog
- ✅ Grade level unchanged
- ✅ lastGradeAdvancementDate remains null/unchanged
- ✅ No error messages

---

### 3. Grade Advancement (April Simulation)
**Test:** Simulate April 1st or set device date to April 1st

**Setup:**
```bash
# On Android emulator, change date to April 1st
adb shell date 040100002024  # April 1, 2024

# Or use emulator settings to change date/time
```

**Steps:**
1. Set device date to April 1st, 2024
2. Ensure user is Grade 3 and lastGradeAdvancementDate is null or from 2023
3. Open app
4. Grade advancement checker runs

**Expected Results:**
- ✅ Celebration dialog appears (animated)
- ✅ Shows "3年生 → 4年生" transition
- ✅ Floating emojis animate (🎉✨🎊)
- ✅ Elastic scale-in animation
- ✅ Message: "🎉 4年生に進級しました！"
- ✅ Firebase updated: gradeLevel = 4, lastGradeAdvancementDate = "2024-04-01"
- ✅ Ranking data includes new gradeLevel

**Verification:**
```dart
// In debug console, check:
- Dialog appears with animations
- Grade badge shows "4年生" (after dialog closes)
- Tier rankings updated for grade 4
```

---

### 4. Duplicate Prevention (Same Year)
**Test:** Try to advance twice in same school year

**Setup:**
1. User: Grade 3, lastGradeAdvancementDate = "2024-04-01"
2. Set device date to April 15, 2024

**Steps:**
1. Open app on April 15
2. Grade advancement checker runs

**Expected Results:**
- ✅ No advancement dialog
- ✅ Grade remains 4
- ✅ Message logged: "今年度は既に進級済みです。"
- ✅ lastGradeAdvancementDate unchanged

---

### 5. Maximum Grade (Grade 6)
**Test:** User already at Grade 6

**Setup:**
1. User: Grade 6, set device date to April 1st

**Steps:**
1. Open app
2. Grade advancement checker runs

**Expected Results:**
- ✅ No advancement dialog
- ✅ Grade remains 6
- ✅ Message logged: "最高学年です。進級できません。"
- ✅ No Firebase update

---

### 6. Grade Level Badge Display
**Test:** Badge renders correctly for each grade

**Steps:**
1. View profile screen (wherever grade badge is displayed)
2. Check each grade display

**Expected Results by Grade:**
- Grade 3: 🟢 "3年生" (Green)
- Grade 4: 🔵 "4年生" (Blue)
- Grade 5: 🟡 "5年生" (Yellow)
- Grade 6: 🔴 "6年生" (Red)

**Verification:**
- Check colors match correctly
- Text displays "X年生"
- All size variants render (small/medium/large)
- Styles render (filled/outline)

---

### 7. Ranking Tier Integration
**Test:** Grades appear in ranking tier filters

**Steps:**
1. Open Ranking screen
2. Tap tier selector "学年別"
3. Check if user's grade appears in dropdown/selector
4. Select user's grade (e.g., "4年")

**Expected Results:**
- ✅ Grade tier selector shows all grades (3年-6年)
- ✅ Can select current user's grade
- ✅ Rankings filtered by grade
- ✅ Tier stats show user's rank within grade
- ✅ Other users of same grade display in list

**Verification:**
```dart
// Check:
- GradeLevelBadge renders with color
- Tier statistics show "4年生" in tierDescription
- Only users with gradeLevel == 4 in ranking list
- Stats show correct participant count
```

---

### 8. Start Month for Ranking Cohorts
**Test:** Start month affects "開始月別" tier

**Setup:**
1. Create users with different start months:
   - User A: startMonth = 4 (April)
   - User B: startMonth = 9 (September)
   - User C: startMonth = 1 (January)

**Steps:**
1. Open Ranking screen
2. Select tier "開始月別"
3. Select "4月" (April)
4. Verify only April starters appear

**Expected Results:**
- ✅ Only User A appears in April rankings
- ✅ Tier stats show only April starters
- ✅ Different months show different user sets
- ✅ Composite filtering works correctly

---

### 9. Animation Quality
**Test:** Celebrate dialog animations smooth and clear

**Steps:**
1. Trigger grade advancement
2. Watch celebration dialog appear
3. Observe all animations
4. Close dialog

**Expected Results:**
- ✅ Scale-in animation smooth (elastic)
- ✅ Fade-in animation clear
- ✅ Floating emojis animate upward
- ✅ Emojis fade out smoothly
- ✅ Grade transition visual clear
- ✅ No jank or stuttering

---

### 10. Localization Check (Japanese)
**Test:** All text displays in Japanese correctly

**Elements to Check:**
- Dialog title: "おめでとう！🎓"
- Dialog message: "🎉 X年生に進級しました！"
- Grade label: "X年生" (not "Grade X")
- Button text: "ありがとうございます！"
- Tier labels: "全体", "学年別", "開始月別", "複合"

**Expected Results:**
- ✅ All Japanese text displays correctly
- ✅ No character encoding issues
- ✅ Proper kanji rendering
- ✅ Furigana (if used) displays correctly

---

### 11. Firebase Integration
**Test:** Data persists to Firebase

**Setup:**
1. Enable Firebase emulator or connect to real Firebase
2. Watch Firestore during advancement

**Steps:**
1. Trigger grade advancement
2. Check Firestore immediately after

**Expected Writes:**
```
Collection: users
Document: {uid}
Updates:
  - gradeLevel: 4 (int)
  - lastGradeAdvancementDate: "2024-04-01" (string)
  - updatedAt: serverTimestamp (Timestamp)

Collections: rankings_daily, rankings_weekly, rankings_monthly
Updates to user documents:
  - gradeLevel: 4 (int)
  - startMonth: 4 (int)
```

**Verification:**
```bash
# Using Firebase CLI
firebase firestore:inspectschema

# Or check Firebase console
# Path: users/{uid}
# Fields: gradeLevel (4), lastGradeAdvancementDate ("2024-04-01")
```

---

### 12. Error Handling
**Test:** Graceful error handling

**Scenarios:**
1. Firebase write fails (offline)
2. User not authenticated
3. Profile data missing
4. Invalid date formats

**Expected Results:**
- ✅ No app crash
- ✅ Error logged to console
- ✅ User sees error message or retry option
- ✅ Service gracefully degrades

---

## Performance Metrics

### Target Performance
- Grade advancement check: < 100ms
- Dialog open animation: < 800ms
- Firebase write: < 2s
- Tier filtering: < 500ms

### Monitoring
```bash
# Check performance in console
flutter run -v --profile

# Monitor in logs:
# - Grade advancement check time
# - Firebase latency
# - UI frame rate during animations
```

---

## Device Testing

### Tested On
- [ ] Android 12+ (minimum API 21)
- [ ] iOS 12+ (if applicable)
- [ ] Tablet (landscape orientation)
- [ ] Phone (portrait orientation)
- [ ] Different screen sizes

### Device Checklist
- [ ] Animations smooth on all devices
- [ ] Text readable on all screen sizes
- [ ] Dialog centered on all devices
- [ ] Colors render correctly
- [ ] Emojis display properly

---

## Regression Testing

### Existing Features (Ensure Not Broken)
- [ ] Ranking display still works
- [ ] Quiz functionality unchanged
- [ ] User profile loads correctly
- [ ] Navigation works
- [ ] Login/auth unchanged
- [ ] Other tier rankings work

---

## Test Result Template

```markdown
## Test Run: [Date/Time]

### Environment
- Device: [Device name/model]
- OS: [OS version]
- App Version: [Build number]
- Firebase: [Emulator/Production]

### Tests Passed
- [x] Initial Grade Assignment
- [x] No Advancement (Before April)
- [x] Grade Advancement (April)
- [x] Duplicate Prevention
- [x] Maximum Grade
- [x] Badge Display
- [x] Ranking Integration
- [x] Start Month Cohorts
- [x] Animation Quality
- [x] Japanese Text
- [x] Firebase Integration
- [x] Error Handling

### Issues Found
1. [Issue description]
   - Severity: [Critical/High/Medium/Low]
   - Steps to reproduce: [Steps]
   - Expected: [Expected behavior]
   - Actual: [Actual behavior]

### Performance Metrics
- Grade check latency: [XXX]ms
- Animation FPS: [XX]fps
- Firebase write time: [XXX]ms

### Sign-off
- Tester: [Name]
- Date: [Date]
- Status: [PASSED/FAILED]
```

---

## Quick Build & Test Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Debug build
flutter build apk --debug

# Run on connected device/emulator
flutter run

# Run with verbose logging
flutter run -v

# Run with profile mode (performance)
flutter run --profile

# Build and run directly
flutter run --release
```

---

## Troubleshooting

### Issue: Code generation files not created
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Firebase connection fails
- Check Firebase configuration
- Ensure internet connection
- Verify Firebase credentials in google-services.json (Android)

### Issue: Animations don't play
- Check device performance
- Disable battery saver
- Check frame rate (should be 60fps target)

### Issue: Database writes fail
- Check Firestore rules
- Verify user authentication
- Check network connectivity
- Monitor Firebase console for errors

---

## Success Criteria ✅

All of the following must pass:

1. ✅ Grade advancement works on April 1st
2. ✅ Celebration dialog shows with animations
3. ✅ Grade level updates in Firebase
4. ✅ Rankings reflect new grade level
5. ✅ No duplicate advancements in same year
6. ✅ Grade 6 is maximum (no advancement beyond)
7. ✅ All tiers (全体, 学年別, 開始月別, 複合) work
8. ✅ Japanese text displays correctly
9. ✅ No crashes or errors
10. ✅ Performance acceptable (< 100ms checks)

---

Generated: 2026-09-02
Phase 2 - STEP 5 Testing Guide

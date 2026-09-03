# Build & Deploy Checklist - Phase 2 Complete

## 📋 Pre-Build Requirements

### Environment Setup
- [ ] Flutter SDK version 3.5.0+ installed
- [ ] Android SDK/NDK configured (for APK builds)
- [ ] iOS Xcode configured (for iOS builds)
- [ ] Java Development Kit (JDK) 11+ installed
- [ ] Git configured with correct credentials

### Code Quality
- [ ] All code committed to `claude/privacy-ranking-system-complete-286acr` branch
- [ ] No uncommitted changes
- [ ] PR #30 updated with all changes documented
- [ ] CI checks passing on PR

---

## 🔨 Build Steps

### Step 1: Prepare Project
```bash
# Navigate to project directory
cd /path/to/newrepo

# Ensure you're on the correct branch
git checkout claude/privacy-ranking-system-complete-286acr

# Get latest changes from remote
git pull origin claude/privacy-ranking-system-complete-286acr

# Clean previous builds
flutter clean
```

### Step 2: Dependencies
```bash
# Get all package dependencies
flutter pub get

# Run build runner for code generation
# This generates: .freezed.dart, .g.dart files for Freezed, JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# If build runner fails, try:
flutter pub run build_runner build --delete-conflicting-outputs --verbose
```

### Step 3: Verify No Errors
```bash
# Check for compile errors
flutter analyze

# Expected output: No issues found!
# If issues found, fix before proceeding

# Run tests (if available)
flutter test
```

### Step 4: Build Debug APK (for testing)
```bash
# Build debug APK
flutter build apk --debug

# Output location: build/app/outputs/flutter-apk/app-debug.apk
# File size: ~50-100MB (debug includes symbols)

# Installation on device
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### Step 5: Test on Device/Emulator
```bash
# Run app in debug mode
flutter run

# Or build and install
flutter run --debug

# Monitor logs
flutter logs
```

### Step 6: Build Release APK (for distribution)
```bash
# Build release APK
flutter build apk --release

# Output location: build/app/outputs/flutter-apk/app-release.apk
# File size: ~30-50MB (optimized)

# Installation on device
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Step 7: Build App Bundle (for Play Store)
```bash
# For Google Play Store submission
flutter build appbundle --release

# Output location: build/app/outputs/bundle/release/app-release.aab
```

---

## ✅ Testing Checklist (Post-Build)

### Installation Verification
- [ ] APK installs without errors
- [ ] App starts without crashes
- [ ] No permission errors
- [ ] Firebase connects successfully

### Core Features
- [ ] Login/Auth works
- [ ] User profile loads
- [ ] Quiz displays correctly
- [ ] Navigation works smoothly

### Phase 2 Features
- [ ] Quiz explanations display (470 questions)
- [ ] Ranking screen loads
- [ ] Tier selector shows 4 tiers
- [ ] Tier filtering works
- [ ] Grade advancement check runs (no errors)
- [ ] Grade badge displays correctly
- [ ] Grade level colors correct (🟢🔵🟡🔴)

### Grade Advancement (Manual Testing)
- [ ] Grade advancement service initializes
- [ ] Start month recorded in Firestore
- [ ] Grade advancement check runs safely
- [ ] Celebration dialog displays when triggered
- [ ] Dialog animations smooth
- [ ] Firebase updates with new grade
- [ ] Ranking reflects grade change

### Performance
- [ ] App loads in < 3 seconds
- [ ] Quiz loads in < 1 second
- [ ] Rankings load in < 2 seconds
- [ ] Animations are smooth (60fps)
- [ ] No memory leaks
- [ ] No excessive battery drain

### Firebase Integration
- [ ] Firestore reads work
- [ ] Firestore writes work
- [ ] Real-time updates work
- [ ] Authentication works
- [ ] Rules allow necessary operations

---

## 🐛 Troubleshooting

### Build Errors

**Error: "Target of URI doesn't exist: 'package:...'"**
```bash
# Run build runner
flutter pub run build_runner build --delete-conflicting-outputs
```

**Error: "SDK version constraint conflict"**
```bash
# Update Flutter
flutter upgrade

# Or check pubspec.yaml for conflicting versions
flutter pub outdated
```

**Error: "JAVA_HOME not set"**
```bash
# Set JAVA_HOME environment variable
# Windows:
set JAVA_HOME=C:\Program Files\Java\jdk-17.0.1

# macOS/Linux:
export JAVA_HOME=/path/to/jdk
```

### Runtime Errors

**Error: "Firebase not initialized"**
- Check firebase_core initialization in main.dart
- Verify google-services.json (Android) or GoogleService-Info.plist (iOS)
- Check Firebase console for correct project

**Error: "Grade advancement service not found"**
- Ensure GradeAdvancementService.dart is in services/
- Check imports in providers/grade_advancement_provider.dart
- Verify service is initialized in app lifecycle

**Error: "Firestore permission denied"**
- Check Firestore security rules
- Verify user is authenticated
- Check collection/document paths match rules
- Monitor Firebase console for errors

---

## 📊 Version Information

### Current Versions (From pubspec.yaml)
- Flutter SDK: ^3.5.0
- Dart: 3.5.0+
- Build Version: 1.0.1+2
- Min Android: API 21 (Android 5.0)
- Min iOS: 12.0

### Key Dependencies
- flutter_riverpod: ^2.4.0
- firebase_core: ^3.0.0
- cloud_firestore: ^5.0.0
- firebase_auth: ^5.5.4

---

## 📱 Device Testing Matrix

### Recommended Testing Devices
| Device Type | OS Version | Test Status |
|---|---|---|
| Google Pixel 7+ | Android 13+ | [ ] PASS |
| Samsung Galaxy S22+ | Android 12+ | [ ] PASS |
| iPhone 13+ | iOS 15+ | [ ] PASS |
| iPad | iOS 12+ | [ ] PASS |
| Android Emulator | Android 12 | [ ] PASS |
| iOS Simulator | iOS 15+ | [ ] PASS |

### Screen Size Testing
- [ ] Small phone (5.0")
- [ ] Medium phone (5.5-6.0")
- [ ] Large phone (6.5"+)
- [ ] Tablet (landscape)
- [ ] Tablet (portrait)

---

## 🚀 Deployment Steps

### For Internal Testing
1. Build debug APK: `flutter build apk --debug`
2. Share via email/cloud storage
3. Install on test devices: `adb install app-debug.apk`
4. Test and collect feedback

### For Google Play Store
1. Sign app with keystore
2. Build release APK: `flutter build apk --release`
3. Build app bundle: `flutter build appbundle --release`
4. Upload to Play Console
5. Set up store listing
6. Request review and publish

### For iOS App Store
1. Ensure certificates configured
2. Update build version in pubspec.yaml
3. Build for iOS: `flutter build ios --release`
4. Upload via Xcode or Transporter
5. Manage TestFlight beta
6. Submit for App Review

---

## 📝 Release Notes Template

```markdown
## Version 1.0.2 - Grade Advancement & 4-Tier Ranking System

### New Features ✨
- **4-Tier Ranking System**: Choose between Global (全体), Grade (学年別), Start Month (開始月別), or Composite (複合) rankings
- **Auto-Grade Advancement**: Automatic grade promotion on April 1st (Japanese school year)
- **Grade Level Badges**: Color-coded badges showing current grade (🟢3年 🔵4年 🟡5年 🔴6年)
- **Tier Filtering**: Filter rankings by grade level and/or start month
- **Grade Statistics**: View your standing within your grade tier
- **Celebration Animation**: Festive celebration when advancing grades

### Quiz Enhancements 📚
- All 470 questions now include comprehensive 4-part explanations
  - 【正解の理由】 Why the answer is correct
  - 【実生活との関連】 Real-world applications
  - 【よくある間違い】 Common misconceptions
  - 【深く学ぶ】 Advanced learning topics
- 60 new images for enhanced quiz content

### Technical Improvements 🔧
- Improved ranking database structure
- Better user progress tracking
- School year calendar support (April-March)
- Enhanced Firebase integration

### Bug Fixes 🐛
- Fixed [bug description if any]

### Known Issues 📌
- None currently known

### Updated Dependencies
- flutter_riverpod: ^2.4.0
- cloud_firestore: ^5.0.0
- firebase_auth: ^5.5.4

### Installation
1. Download APK from [release link]
2. Install: `adb install app-release.apk`
3. Open app and enjoy new features!

### Support
- For issues: [support email/link]
- Feature requests: [github issues link]
```

---

## ✅ Final Checklist Before Release

- [ ] All tests passing
- [ ] No critical bugs
- [ ] All features working as documented
- [ ] Firebase security rules reviewed
- [ ] Performance optimized
- [ ] Code reviewed and approved
- [ ] Documentation complete
- [ ] Release notes prepared
- [ ] Version number updated
- [ ] Backup of production data
- [ ] Rollback plan prepared
- [ ] User communication ready
- [ ] Analytics configured
- [ ] Error tracking setup (Sentry/Crashlytics)

---

## 📞 Support & Escalation

### If Build Fails
1. Check build logs for error messages
2. Try clean build: `flutter clean && flutter pub get`
3. Verify dependencies: `flutter pub outdated`
4. Check Flutter version: `flutter --version`
5. Open GitHub issue with error details

### If Tests Fail
1. Isolate failing test
2. Run with verbose: `flutter test -v`
3. Check device connectivity
4. Verify Firebase configuration
5. Review test logs and debug

### If Deployment Fails
1. Verify signing configuration
2. Check app store submission requirements
3. Review console error messages
4. Contact app store support if needed
5. Prepare alternative distribution method

---

## 📚 References

- Flutter Build Documentation: https://flutter.dev/docs/deployment/android
- Google Play Console: https://play.google.com/console
- Xcode Build Guide: https://developer.apple.com/xcode/
- Firebase Setup: https://firebase.google.com/docs/flutter/setup

---

## 🎯 Success Criteria

Release is ready when:
1. ✅ All features working correctly on test devices
2. ✅ No crashes or critical errors
3. ✅ Performance meets targets (< 3s app start)
4. ✅ Firebase integration working
5. ✅ Grade advancement system tested
6. ✅ All documentation complete
7. ✅ Team approval obtained
8. ✅ Backup and rollback plan ready

---

Last Updated: 2026-09-02
Phase 2 - Build & Deploy Checklist

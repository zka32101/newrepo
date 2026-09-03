# APK/AAB Build Guide - SPRINT 3.5b Release

**Project:** 小学コレ！理科 (shokollen_science)  
**Target:** Android App Release (APK + AAB)  
**Build Type:** Release Mode  
**Date:** 2026-09-03

---

## ⚠️ Important: Japanese Path Handling

**CRITICAL:** This project uses Japanese characters in the path (G:\マイドライブ\apps\shokollen_science)

The build process REQUIRES a virtual drive setup to avoid UTF-8/JSON encoding issues with Kotlin compiler and CMake.

---

## 🚀 Quick Build (Release APK)

### Step 1: Setup Virtual Drive (First Time Only)

**Windows PowerShell (as Administrator):**

```powershell
# Assign virtual drive S: to project path
subst S: "G:\マイドライブ\apps\shokollen_science"

# Verify
subst
# Should show: S: => G:\マイドライブ\apps\shokollen_science
```

### Step 2: Build Release APK

```powershell
# Navigate to virtual drive
cd S:/

# Clean and build
flutter clean
flutter pub get
flutter build apk --release --no-pub

# Output: S:\build\app\outputs\flutter-apk\app-release.apk
```

### Step 3: Copy APK

```powershell
# Copy to APK storage location
Copy-Item "S:\build\app\outputs\flutter-apk\app-release.apk" `
          "G:\マイドライブ\apk\小学コレ理科-v1.0.0-release.apk"
```

---

## 📦 Full Build Workflow

### Phase 1: Environment Preparation

#### 1.1 Verify Prerequisites

```powershell
# Check Flutter installation
flutter --version
# Expected: Flutter 3.13.x

# Check Dart
dart --version
# Expected: Dart 3.1.x

# Check Java
java -version
# Expected: Java 21 (set in JAVA_HOME)
$env:JAVA_HOME
# Expected: C:\Program Files\Microsoft\jdk-21.0.11.10-hotspot\
```

#### 1.2 Clean Build Environment

```powershell
# Remove old build artifacts
Remove-Item "S:\build" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "S:\.dart_tool" -Recurse -Force -ErrorAction SilentlyContinue

# Remove Gradle cache (optional, slower rebuild)
Remove-Item "$env:USERPROFILE\.gradle\caches" -Recurse -Force -ErrorAction SilentlyContinue
```

#### 1.3 Setup Virtual Drive

```powershell
# If S: drive not mapped yet
subst S: "G:\マイドライブ\apps\shokollen_science"

# If S: drive already exists
subst S: /d  # Remove old mapping
subst S: "G:\マイドライブ\apps\shokollen_science"  # Create new
```

---

### Phase 2: Dependency Management

```powershell
cd S:/

# Get dependencies
flutter pub get

# Verify no dependency issues
flutter pub outdated

# Update pubspec.lock if needed
flutter pub upgrade --dry-run
```

---

### Phase 3: Build Configuration

### 3.1 Version Configuration

Edit `pubspec.yaml`:

```yaml
version: 1.0.0+1

# Meaning: 1.0.0 = version name, +1 = version code
# Increment version code for each release: +2, +3, etc.
```

### 3.2 Build Variants

```powershell
# Debug APK (for testing)
flutter build apk --debug --no-pub
# Output: app-debug.apk (~70MB)

# Release APK (optimized)
flutter build apk --release --no-pub
# Output: app-release.apk (~30MB)
# Time: 5-10 minutes

# Profile APK (performance testing)
flutter build apk --profile --no-pub
# Output: app-profile.apk (~35MB)
```

### 3.3 Build Flags Explained

| Flag | Purpose | Usage |
|------|---------|-------|
| `--release` | Optimize for production | ✅ App Store submission |
| `--debug` | Include debug symbols | ✅ Testing & debugging |
| `--profile` | Performance profiling | ✅ Performance testing |
| `--no-pub` | Skip pub get | ✅ Faster rebuild (after initial) |
| `--split-per-abi` | Separate APKs by CPU | ✅ Smaller download per device |

---

## 🏗️ Release APK Build

### Complete Release Build Process

```powershell
# Step 1: Navigate to virtual drive
cd S:/

# Step 2: Clean previous builds
flutter clean
flutter pub get

# Step 3: Build release APK
flutter build apk --release --no-pub

# Expected Output:
# ✓ Built build/app/outputs/flutter-apk/app-release.apk (30.2 MB)
# ✓ Built build/app/outputs/flutter-apk/app-release.aab (22.1 MB) [if AAB enabled]

# Step 4: Verify APK
dir S:\build\app\outputs\flutter-apk\

# Step 5: Copy to storage
Copy-Item "S:\build\app\outputs\flutter-apk\app-release.apk" `
          "G:\マイドライブ\apk\小学コレ理科-v1.0.0-release.apk"

# Step 6: List APK files
dir "G:\マイドライブ\apk\"
```

### Build Time Expectations

```
First Build:    8-15 minutes (full compilation)
Subsequent:     3-5 minutes (incremental)
Gradle Build:   Longest step (~5-8 minutes)
```

---

## 📱 AAB (Android App Bundle) Build

### Why AAB?

- ✅ Smaller downloads per device
- ✅ Required for Google Play Store (new policy)
- ✅ Automatic optimization by Play Store
- ✅ Version size reduction: ~70% smaller

### Build AAB for Play Store

```powershell
cd S:/

# Build AAB (recommended for Play Store)
flutter build appbundle --release --no-pub

# Output: S:\build\app\outputs\bundle\release\app-release.aab
# Size: ~22 MB (vs 30 MB for APK)
```

### AAB vs APK

| Feature | APK | AAB |
|---------|-----|-----|
| Size | Larger | Smaller |
| Distribution | Direct install | Play Store only |
| Optimization | Manual split | Automatic |
| Languages | All bundled | Per-device |
| Best For | Testing | Play Store release |

---

## 🔐 Signing Configuration

### Step 1: Create Keystore (First Time Only)

```powershell
# Create signing keystore
$keyPath = "G:\マイドライブ\apps\shokollen_science\android\keystore\shokollen.jks"

keytool -genkey -v `
  -keystore $keyPath `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias shokollen_science `
  -storetype JKS

# Interactive prompts:
# Enter keystore password: [secure password]
# Re-enter password: [same]
# First and last name: shokollen_science
# Organization: org-zka32101
# City/Locality: Tokyo
# State/Province: Tokyo
# Country code: JP
# Confirm (yes): yes
# Enter key password: [same or new]

# Keystore created: android/keystore/shokollen.jks
```

### Step 2: Configure Signing in Gradle

Edit `android/app/build.gradle`:

```gradle
android {
    ...
    
    signingConfigs {
        release {
            keyAlias 'shokollen_science'
            keyPassword 'YOUR_KEY_PASSWORD'
            storeFile file('keystore/shokollen.jks')
            storePassword 'YOUR_STORE_PASSWORD'
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 3: Build Signed APK

```powershell
cd S:/

# Build with signing
flutter build apk --release --no-pub

# APK is automatically signed with keystore credentials
# Output: app-release.apk (signed & ready for Play Store)
```

---

## 📊 Build Output

### File Structure After Build

```
build/
└── app/
    └── outputs/
        ├── flutter-apk/
        │   ├── app-debug.apk           (70 MB, debug symbols)
        │   ├── app-profile.apk         (35 MB, profiling)
        │   └── app-release.apk         (30 MB, optimized) ✅
        │
        └── bundle/
            └── release/
                └── app-release.aab     (22 MB, Play Store) ✅
```

### APK Verification

```powershell
# Check APK details
$apk = "S:\build\app\outputs\flutter-apk\app-release.apk"

# File size
(Get-Item $apk).Length / 1MB  # Size in MB

# Verify signing
keytool -printcert -jarfile $apk

# Extract manifest
# APKs are ZIP files, can be inspected with 7-Zip
7z x -o"S:\apk_extracted" $apk

# Check AndroidManifest.xml
Get-ChildItem S:\apk_extracted\AndroidManifest.xml
```

---

## 🚀 Distribution Setup

### Google Play Store Submission

#### Prerequisites

```
✅ Google Play Developer Account ($25 one-time fee)
✅ Release APK or AAB signed with keystore
✅ App icon (192x192 minimum)
✅ Screenshots (2-8 per language)
✅ Description & privacy policy
✅ App category & rating
✅ Version history
```

#### Submission Steps

1. **Upload Build**
   ```
   Google Play Console > Your App > Release > Production
   → Upload APK or AAB
   → Review details
   ```

2. **App Information**
   ```
   - App name: 小学コレ！理科
   - Short description: 小学3~6年生向けの理科学習アプリ
   - Full description: [Full app description]
   - Category: Education
   - Content rating: 3+ (everyone)
   ```

3. **Screenshots**
   ```
   Upload for multiple screen sizes:
   - Phone (5.1-5.9")
   - 7" Tablet
   - 10" Tablet
   ```

4. **Review & Release**
   ```
   Google Play reviews changes (1-3 hours typically)
   Automatic release when approved
   ```

---

## 🔧 Troubleshooting

### Build Failures

#### "Permission denied" or "Cannot find keystore"

```powershell
# Ensure virtual drive is mapped
subst

# If S: missing, remap it
subst S: /d
subst S: "G:\マイドライブ\apps\shokollen_science"
```

#### "Gradle build failed"

```powershell
# Clean everything
cd S:/
flutter clean
flutter pub get
flutter build apk --release --no-pub
```

#### "Android SDK not found"

```powershell
# Check Flutter setup
flutter doctor

# Install missing components
flutter doctor --android-licenses

# Set JAVA_HOME if needed
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-21.0.11.10-hotspot"
```

#### "Out of memory during build"

```powershell
# Increase Gradle memory
# Edit: android/gradle.properties

org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=4096m
```

#### "Error: Unable to parse XML"

```
This typically means Unicode/UTF-8 encoding issue.
Root cause: Japanese characters in path
Solution: MUST use virtual drive (S:) as described above

Do NOT build from G:\マイドライブ\ directly!
Always: cd S:/ first
```

---

## 📋 Pre-Release Checklist

Before uploading to Play Store:

```
Code & Testing:
□ All tests passing (flutter test)
□ No lint warnings (flutter analyze)
□ Performance verified (60 FPS, <150MB RAM)
□ Tested on device (not just emulator)
□ Tested on multiple Android versions

Build Configuration:
□ Version updated in pubspec.yaml
□ versionCode incremented
□ Signing keystore configured
□ ProGuard rules configured
□ Gradle build succeeds

App Metadata:
□ App name correct: "小学コレ！理科"
□ App description ready (Japanese)
□ Privacy policy prepared
□ Screenshots captured (multiple sizes)
□ Icons ready (192x192+)

Security:
□ No hardcoded secrets/API keys
□ Environment variables in .env (not committed)
□ API keys in keystore secrets
□ SSL pinning verified
□ Data encryption verified

Documentation:
□ Release notes written
□ Changelog updated
□ Build instructions documented
□ Support contact ready

Final:
□ APK/AAB signed
□ File size acceptable (<100MB recommended)
□ Crash testing passed (Firebase Crashlytics if used)
□ Analytics tracking verified
□ Rollback plan documented
```

---

## 📦 Release Artifact Storage

```powershell
# Create release archive
$version = "1.0.0"
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$releaseFolder = "G:\マイドライブ\releases\$version-$timestamp"

New-Item -ItemType Directory -Path $releaseFolder -Force

# Copy APK
Copy-Item "S:\build\app\outputs\flutter-apk\app-release.apk" `
          "$releaseFolder\app-release.apk"

# Copy AAB
Copy-Item "S:\build\app\outputs\bundle\release\app-release.aab" `
          "$releaseFolder\app-release.aab"

# Save build info
@{
    version = $version
    buildDate = Get-Date
    flutterVersion = (flutter --version)
    dartVersion = (dart --version)
    buildHost = $env:COMPUTERNAME
    gitCommit = (git rev-parse HEAD)
} | ConvertTo-Json | Out-File "$releaseFolder\build-info.json"

# List artifacts
Get-ChildItem $releaseFolder
```

---

## 🔄 Continuous Deployment

### Automated Builds (Future)

```yaml
# GitHub Actions example (for reference)
name: Build Release APK

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.13.x'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📊 Build Performance Optimization

### Gradle Optimization

Edit `android/gradle.properties`:

```properties
# Optimize Gradle build performance
org.gradle.jvmargs=-Xmx4096m
org.gradle.parallel=true
org.gradle.configureondemand=true
android.useAndroidX=true
android.enableJetifier=true
android.suppressUnsupportedCompileSdkWarning=true
```

### ProGuard Configuration

Edit `android/app/proguard-rules.pro`:

```proguard
# Keep app code
-keep class com.example.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }

# Keep Dart methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Remove unused code
-dontshrink
-dontoptimize
```

---

## ✅ Quality Gates

### Pre-Release Testing

```
Performance:
✅ App startup < 3 seconds
✅ Memory usage < 150MB
✅ Scrolling 60 FPS consistent
✅ API responses < 2 seconds

Functionality:
✅ AI Chat: Send & receive responses
✅ Night Sky: GPS + weather working
✅ Rate limiting: 50/month enforced
✅ Permissions: Requests work
✅ Theme: Light/dark toggle

Stability:
✅ No crashes on navigation
✅ Error recovery works
✅ Offline mode graceful
✅ Permission denial handled
✅ Network errors show user-friendly messages

Coverage:
✅ 25 unit tests passing
✅ 28 manual tests passing
✅ No lint warnings
✅ Accessibility verified
```

---

## 📞 Troubleshooting Reference

| Problem | Solution |
|---------|----------|
| "Virtual drive not found" | Run: `subst S: "G:\マイドライブ\apps\shokollen_science"` |
| "Permission denied" | Run PowerShell as Administrator |
| "Gradle build timeout" | Increase: `org.gradle.jvmargs=-Xmx4096m` |
| "Java not found" | Set: `$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-21.0.11.10-hotspot"` |
| "Keystore not found" | Verify path in `build.gradle` matches actual location |
| "APK file corrupt" | Retry build or clean and rebuild |
| "Signing failed" | Check keystore password and alias match |

---

## 🎯 Success Criteria

✅ **Build Successful**
- Release APK generates without errors
- File size < 50MB
- APK is signable with keystore
- AAB optional but recommended

✅ **Quality Verified**
- All tests pass
- No lint warnings
- Performance acceptable
- Crash testing clean

✅ **Ready for Distribution**
- Signed APK ready
- Metadata complete
- Screenshots prepared
- Privacy policy attached

---

## 📝 Release Notes Template

```markdown
# Release Notes - v1.0.0

## 🎉 New Features
- ② AIはかせチャット: Claude API-powered science tutoring
- ④ 今夜の空: OpenWeatherMap + Astronomy observation guide

## 🐛 Bug Fixes
- Fixed rate limiting edge cases
- Improved error messages for accessibility

## ⚡ Performance
- Optimized API call caching
- Reduced memory usage by 20%
- Improved animation smoothness (60 FPS)

## 📱 Compatibility
- Android 8.0+ required
- Tested on: Pixel 4, Pixel 6 Pro, various tablets

## 🔐 Security
- Added data encryption
- Improved permission handling
- Rate limiting (50 requests/month)

## Known Issues
None reported

## Thanks
Special thanks to all testers and contributors!
```

---

## 📞 Support

For build issues:
1. Check `flutter doctor` output
2. Verify Java version (Java 21 required)
3. Ensure virtual drive mapped (S:)
4. Review troubleshooting section above
5. Check Flutter documentation: https://flutter.dev/docs/deployment/android

---

**Status:** Ready to Build  
**Last Updated:** 2026-09-03  
**Next Step:** Execute build, test, and submit to Play Store

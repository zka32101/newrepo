# Simple APK/AAB Build Guide - Linux

**For: /home/user/newrepo environment**

---

## 🚀 Quick Release APK (3 steps, ~5 minutes)

```bash
# 1. Setup
flutter clean
flutter pub get

# 2. Build release APK
flutter build apk --release

# 3. Find your APK
ls -lh build/app/outputs/flutter-apk/app-release.apk
```

**Output:** `build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 For Google Play Store (AAB format, 3 steps, ~5 minutes)

```bash
# 1. Setup
flutter clean
flutter pub get

# 2. Build AAB for Play Store
flutter build appbundle --release

# 3. Find your AAB
ls -lh build/app/outputs/bundle/release/app-release.aab
```

**Output:** `build/app/outputs/bundle/release/app-release.aab`

---

## 🔐 Signing Configuration

If not already set, create `android/key.properties`:

```properties
storeFile=/path/to/keystore.jks
storePassword=your_password
keyPassword=your_password
keyAlias=upload
```

And configure `android/app/build.gradle`:

```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

---

## ✅ Verification

```bash
# Check APK size
ls -lh build/app/outputs/flutter-apk/app-release.apk

# List APK contents (optional)
unzip -l build/app/outputs/flutter-apk/app-release.apk | head -20
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| `gradle: command not found` | `flutter pub get` handles it automatically |
| `Out of memory` | Increase Java heap: `export _JAVA_OPTIONS="-Xmx4g"` |
| `Build fails on dependencies` | Run `flutter pub get && flutter pub upgrade` |
| `APK too large (>100MB)` | Enable ProGuard in `build.gradle` (see below) |

---

## 📊 Build Variants

```bash
# Debug APK (faster, for testing)
flutter build apk --debug

# Profile APK (optimized, for performance testing)
flutter build apk --profile

# Release APK (fully optimized, for production)
flutter build apk --release

# Release AAB (for Play Store only)
flutter build appbundle --release
```

---

## 🎯 Upload to Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to: **Release** → **Production**
4. Click **Create new release**
5. Upload `build/app/outputs/bundle/release/app-release.aab`
6. Review and publish

---

## 💾 Save Artifacts

```bash
# Create release folder
mkdir -p releases/v1.0.0

# Copy APK
cp build/app/outputs/flutter-apk/app-release.apk releases/v1.0.0/

# Copy AAB
cp build/app/outputs/bundle/release/app-release.aab releases/v1.0.0/

# List what you have
ls -lh releases/v1.0.0/
```

---

## ✨ ProGuard Configuration (Optional)

Add to `android/app/build.gradle` to reduce APK size:

```gradle
buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

---

**Done!** Your APK is ready. 🎉

Generated: 2026-09-03

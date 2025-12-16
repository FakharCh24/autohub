# 🔐 AutoHub - Release Signing Guide

Complete guide for creating a signed release build for Play Store submission.

---

## 📋 Table of Contents

1. [Generate Keystore](#1-generate-keystore)
2. [Configure Signing](#2-configure-signing)
3. [Build Release APK/AAB](#3-build-release-apkaab)
4. [Verify Build](#4-verify-build)
5. [Troubleshooting](#5-troubleshooting)

---

## 1. Generate Keystore

### Step 1: Create Keystore File

Run this command in your terminal (from project root):

**Windows (PowerShell):**

```powershell
keytool -genkey -v -keystore d:\MAD` LAB\autohub\android\app\autohub-release-key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias autohub
```

**macOS/Linux:**

```bash
keytool -genkey -v -keystore ~/autohub-release-key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias autohub
```

### Step 2: Fill in Information

You'll be prompted for:

```
Enter keystore password: [Create a STRONG password]
Re-enter new password: [Repeat password]
What is your first and last name?
  [Unknown]: Fakhar Ch
What is the name of your organizational unit?
  [Unknown]: Development
What is the name of your organization?
  [Unknown]: AutoHub
What is the name of your City or Locality?
  [Unknown]: [Your City]
What is the name of your State or Province?
  [Unknown]: [Your State]
What is the two-letter country code for this unit?
  [Unknown]: [Your Country Code, e.g., US]
Is CN=Fakhar Ch, OU=Development, O=AutoHub, L=[City], ST=[State], C=[Code] correct?
  [no]: yes

Enter key password for <autohub>
  (RETURN if same as keystore password): [Press ENTER or create different password]
```

**IMPORTANT:**

- ⚠️ **Save your passwords securely!** You'll need them for every release.
- ⚠️ **Backup the keystore file!** If you lose it, you cannot update your app on Play Store.
- ⚠️ **Never commit keystore to Git!**

---

## 2. Configure Signing

### Step 1: Create key.properties

Create file: `android/key.properties`

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=autohub
storeFile=autohub-release-key.jks
```

Replace `YOUR_KEYSTORE_PASSWORD` and `YOUR_KEY_PASSWORD` with your actual passwords.

**Example:**

```properties
storePassword=MySecurePass123!
keyPassword=MySecurePass123!
keyAlias=autohub
storeFile=autohub-release-key.jks
```

### Step 2: Update build.gradle.kts

Add signing configuration to `android/app/build.gradle.kts`:

**Add this BEFORE the `android {` block:**

```kotlin
// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}
```

**Add this INSIDE the `android {` block, AFTER `defaultConfig`:**

```kotlin
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")

            // Enable ProGuard
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
```

### Step 3: Update .gitignore

Ensure these lines are in your `.gitignore`:

```
# Keystore files
*.jks
*.keystore
android/key.properties
```

---

## 3. Build Release APK/AAB

### Option A: Build App Bundle (AAB) - Recommended for Play Store

```bash
flutter build appbundle --release
```

Output location:

```
build/app/outputs/bundle/release/app-release.aab
```

**File size:** ~15-30 MB (smaller than APK)

### Option B: Build APK - For Direct Distribution

```bash
flutter build apk --release
```

Output location:

```
build/app/outputs/flutter-apk/app-release.apk
```

**File size:** ~30-50 MB

### Build with Obfuscation (Extra Security)

```bash
# For AAB
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols

# For APK
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

---

## 4. Verify Build

### Step 1: Check File Exists

**For AAB:**

```powershell
ls build\app\outputs\bundle\release\app-release.aab
```

**For APK:**

```powershell
ls build\app\outputs\flutter-apk\app-release.apk
```

### Step 2: Install APK on Device (Testing)

```bash
# Connect device via USB
flutter devices

# Install
flutter install build/app/outputs/flutter-apk/app-release.apk
```

Or manually:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Step 3: Test Release Build

1. Launch app on device
2. Verify all features work:
   - Authentication
   - Image upload
   - Chat
   - Search/Filter
   - Favorites
3. Check for any crashes or errors

### Step 4: Verify Signing

```bash
# For APK
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk

# Should show: "jar verified."
```

---

## 5. Troubleshooting

### Issue 1: "Keystore file not found"

**Solution:**

- Check `storeFile` path in `key.properties`
- Ensure keystore file is in `android/app/` directory
- Use correct path format:
  - Windows: `autohub-release-key.jks` (relative path)
  - Mac/Linux: `autohub-release-key.jks`

### Issue 2: "Incorrect password"

**Solution:**

- Double-check passwords in `key.properties`
- Ensure no extra spaces
- Passwords are case-sensitive

### Issue 3: Build fails with ProGuard errors

**Solution:**

```bash
# Temporarily disable ProGuard
# In build.gradle.kts, set:
isMinifyEnabled = false
isShrinkResources = false

# Build again
flutter build appbundle --release
```

### Issue 4: "Package name mismatch"

**Solution:**

- Ensure `applicationId` in `build.gradle.kts` matches Firebase project
- Should be: `com.fakharch.autohub`

### Issue 5: App crashes in release but not debug

**Solution:**

- Check ProGuard rules in `proguard-rules.pro`
- Add keep rules for any missing classes
- Test with: `flutter run --release`

---

## 📦 File Checklist Before Upload

Before submitting to Play Store:

- [ ] ✅ App bundle (AAB) built successfully
- [ ] ✅ Tested on real device
- [ ] ✅ All features work in release mode
- [ ] ✅ No crashes or errors
- [ ] ✅ Version code/name updated in `pubspec.yaml`
- [ ] ✅ Screenshots prepared (4-8 images)
- [ ] ✅ App description written
- [ ] ✅ Privacy Policy URL ready
- [ ] ✅ Feature graphic created (1024x500)

---

## 🔒 Security Best Practices

### DO:

- ✅ Use strong passwords (16+ characters)
- ✅ Store keystore in secure location
- ✅ Backup keystore to multiple locations
- ✅ Use different passwords for different apps
- ✅ Keep key.properties in .gitignore

### DON'T:

- ❌ Share keystore or passwords
- ❌ Commit keystore to version control
- ❌ Use simple/common passwords
- ❌ Store passwords in code
- ❌ Lose the keystore file

---

## 📱 Play Store Submission

### Version Management

Update version in `pubspec.yaml` before each release:

```yaml
version: 1.0.0+1
#        │  │ │ └── Build number (increment for each build)
#        │  │ └──── Patch version
#        │  └────── Minor version
#        └────────── Major version
```

**For next release:**

```yaml
version: 1.0.1+2  # Bug fix
version: 1.1.0+3  # New feature
version: 2.0.0+4  # Major update
```

### Build Command with Version

```bash
flutter build appbundle --release --build-name=1.0.0 --build-number=1
```

---

## 🎯 Quick Reference

**Generate Keystore:**

```bash
keytool -genkey -v -keystore autohub-release-key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias autohub
```

**Build Release:**

```bash
# App Bundle (Play Store)
flutter build appbundle --release

# APK (Direct install)
flutter build apk --release
```

**Test Release:**

```bash
flutter run --release
```

**Verify Signing:**

```bash
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

---

## 📞 Support

If you encounter issues:

1. Check [Troubleshooting](#5-troubleshooting)
2. Review Flutter documentation: https://flutter.dev/docs/deployment/android
3. Check Android documentation: https://developer.android.com/studio/publish

---

**Your AutoHub release build is ready for the Play Store! 🚀**

---

## ⚠️ CRITICAL REMINDER

**BACKUP YOUR KEYSTORE!**

Store copies in:

1. External hard drive
2. Cloud storage (encrypted)
3. USB drive
4. Secure password manager

**Losing the keystore means you cannot update your app on Play Store!**

---

_Last Updated: December 15, 2025_

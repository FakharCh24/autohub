# 🔧 AutoHub - Complete Setup Instructions

This guide will walk you through setting up the AutoHub car marketplace application from scratch.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Flutter Setup](#flutter-setup)
3. [Firebase Setup](#firebase-setup)
4. [Project Configuration](#project-configuration)
5. [Running the App](#running-the-app)
6. [Troubleshooting](#troubleshooting)

---

## 1. Prerequisites

### Required Software

- **Flutter SDK** (3.0.0 or higher)
  - Download: https://flutter.dev/docs/get-started/install
- **Android Studio** or **VS Code**
  - Android Studio: https://developer.android.com/studio
  - VS Code: https://code.visualstudio.com/
- **Git**
  - Download: https://git-scm.com/downloads
- **Firebase Account**
  - Sign up: https://firebase.google.com/

### System Requirements

- **Windows**: Windows 10 or later (64-bit)
- **RAM**: Minimum 8GB (16GB recommended)
- **Disk Space**: At least 10GB free
- **Android Device or Emulator**: Android 5.0+ (API level 21+)

---

## 2. Flutter Setup

### Step 1: Install Flutter

```bash
# Verify Flutter installation
flutter doctor

# Accept Android licenses
flutter doctor --android-licenses
```

### Step 2: Install Flutter Dependencies

```bash
# Navigate to project directory
cd autohub

# Get all dependencies
flutter pub get

# Verify no issues
flutter doctor -v
```

---

## 3. Firebase Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add project"**
3. Enter project name: `autohub` (or your preferred name)
4. Disable Google Analytics (optional for development)
5. Click **"Create project"**

### Step 2: Register Android App

1. In Firebase Console, click **Android icon** (⚙️)
2. Enter package name: `com.fakharch.autohub`
3. App nickname: `AutoHub`
4. Click **"Register app"**

### Step 3: Download Configuration File

1. Download `google-services.json`
2. Place it in: `android/app/google-services.json`

```
autohub/
└── android/
    └── app/
        └── google-services.json  ← Place here
```

### Step 4: Enable Firebase Services

#### 4.1 Authentication

1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password**
3. Click **Save**

#### 4.2 Cloud Firestore

1. Go to **Firestore Database**
2. Click **"Create database"**
3. Select **"Start in production mode"**
4. Choose location (closest to your users)
5. Click **"Enable"**

**Deploy Firestore Rules:**

1. Go to **Firestore Database** → **Rules**
2. Copy content from `firestore.rules` in your project
3. Click **"Publish"**

#### 4.3 Firebase Storage

1. Go to **Storage**
2. Click **"Get started"**
3. Select **"Start in production mode"**
4. Click **"Done"**

**Deploy Storage Rules:**

1. Go to **Storage** → **Rules**
2. Copy content from `storage.rules` in your project
3. Click **"Publish"**

#### 4.4 Realtime Database

1. Go to **Realtime Database**
2. Click **"Create Database"**
3. Choose location
4. Select **"Start in locked mode"**
5. Click **"Enable"**

**Deploy Database Rules:**

1. Go to **Realtime Database** → **Rules**
2. Copy content from `database.rules.json`
3. Click **"Publish"**

### Step 5: Create Firestore Collections

The app will auto-create collections, but you can create them manually:

1. Go to **Firestore Database** → **Data**
2. Click **"Start collection"**
3. Create these collections:
   - `users`
   - `cars`
   - `reviews`
   - `favorites`
   - `notifications`
   - `price_alerts`

---

## 4. Project Configuration

### Step 1: Update Firebase Options

If you need to regenerate Firebase configuration:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for Flutter
flutterfire configure
```

This will update `lib/firebase_options.dart`

### Step 2: Verify Configuration Files

Ensure these files exist:

```
✅ android/app/google-services.json
✅ lib/firebase_options.dart
✅ firestore.rules
✅ storage.rules
✅ database.rules.json
```

---

## 5. Running the App

### Step 1: Connect Device or Start Emulator

**For Physical Device:**

1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect via USB

**For Emulator:**

```bash
# List available emulators
flutter emulators

# Start emulator
flutter emulators --launch <emulator_id>
```

### Step 2: Run the App

```bash
# Check connected devices
flutter devices

# Run in debug mode
flutter run

# Run in release mode
flutter run --release
```

### Step 3: First Launch

1. App will show splash screen
2. Complete onboarding (3 screens)
3. Register with email/password
4. Start using AutoHub!

---

## 6. Troubleshooting

### Common Issues

#### Issue 1: "google-services.json not found"

**Solution:**

```bash
# Verify file exists
ls android/app/google-services.json

# If missing, download from Firebase Console
# Place in android/app/ directory
```

#### Issue 2: "Execution failed for task ':app:processDebugGoogleServices'"

**Solution:**

- Ensure `google-services.json` has correct package name: `com.fakharch.autohub`
- Re-download from Firebase Console if needed

#### Issue 3: Gradle build fails

**Solution:**

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Try again
flutter run
```

#### Issue 4: Firebase permission errors

**Solution:**

- Verify you've deployed Firestore, Storage, and Database rules
- Check rules in Firebase Console match project files

#### Issue 5: "No Firebase App '[DEFAULT]' has been created"

**Solution:**

```bash
# Ensure Firebase is initialized in main.dart
# Check this code exists:
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
);
```

#### Issue 6: Image picker not working

**Solution:**

- Ensure permissions are in `AndroidManifest.xml`
- For Android 13+, check `READ_MEDIA_IMAGES` permission

---

## 📚 Database Schema

### Users Collection (`users`)

```javascript
{
  "userId": "string",
  "email": "string",
  "name": "string",
  "phone": "string",
  "profileImageUrl": "string",
  "createdAt": "timestamp",
  "isVerified": "boolean"
}
```

### Cars Collection (`cars`)

```javascript
{
  "carId": "string",
  "userId": "string",
  "title": "string",
  "description": "string",
  "price": "number",
  "category": "string", // SUV, Sedan, Hatchback, etc.
  "fuelType": "string", // Petrol, Diesel, Electric, Hybrid
  "transmission": "string", // Automatic, Manual
  "mileage": "number",
  "year": "number",
  "condition": "string",
  "location": "string",
  "images": ["array of URLs"],
  "views": "number",
  "favoritesCount": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Reviews Collection (`reviews`)

```javascript
{
  "reviewId": "string",
  "userId": "string",
  "sellerId": "string",
  "rating": "number",
  "comment": "string",
  "createdAt": "timestamp"
}
```

### Favorites Collection (`favorites`)

```javascript
{
  "userId": "string",
  "carId": "string",
  "addedAt": "timestamp"
}
```

---

## 🔐 Security Rules Summary

### Firestore Rules

- Users can only edit their own profiles
- Anyone can read car listings
- Only owners can modify/delete their listings
- Authenticated users can add favorites and reviews

### Storage Rules

- Profile pictures: Only owner can upload/delete
- Car images: Only car owner can upload/delete
- Public read access for all images
- Max file size: 5MB
- Only image files allowed

### Realtime Database Rules

- Chat messages: Read/write only if authenticated
- Typing indicators: User can only update their own status
- Online status: User-specific write access

---

## 🎯 Next Steps

After successful setup:

1. ✅ Create test account
2. ✅ Add sample car listings
3. ✅ Test chat functionality
4. ✅ Test image upload
5. ✅ Review TESTING_GUIDE.md for comprehensive testing

---

## 📞 Support

If you encounter issues:

1. Check [Troubleshooting](#troubleshooting) section
2. Review Firebase Console logs
3. Check `flutter logs` for errors
4. Verify all configuration files

---

**Setup complete! Your AutoHub app is ready to use! 🚀**

_Last Updated: December 15, 2025_

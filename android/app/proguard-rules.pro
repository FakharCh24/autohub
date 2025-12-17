# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Keep Flutter wrapper classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Flutter assets and fonts (CRITICAL FOR ICONS)
-keep class io.flutter.embedding.engine.FlutterJNI { *; }
-keep class io.flutter.embedding.engine.loader.FlutterLoader { *; }
-keepclassmembers class * {
    @io.flutter.embedding.engine.dart.DartEntrypoint *;
}

# Don't strip or obfuscate font files and assets
-keep class * extends android.content.res.AssetManager
-keepclassmembers class * {
    *** getAssets(...);
}
-dontwarn android.content.res.AssetManager

# Keep image picker classes
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep shared preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep path provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep sqflite
-keep class com.tekartik.sqflite.** { *; }

# Firebase Firestore
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Firebase Storage
-keep class com.google.firebase.storage.** { *; }

# Firebase Database
-keep class com.google.firebase.database.** { *; }

# Firebase Auth
-keep class com.google.firebase.auth.** { *; }

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.iid.** { *; }

# Gson (used by Firebase)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Google Play Core - Don't warn about missing classes
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Keep Play Core classes if they exist (optional)
-keep class com.google.android.play.core.** { *; }

# Flutter Play Store integration
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# OkHttp (used by Firebase and HTTP)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Retrofit (if you add it later)
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep model classes (adjust package name if needed)
-keep class com.fakharch.autohub.models.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimize
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose

# Keep line numbers for debugging stack traces
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep all resource names to prevent obfuscation
-keepclassmembers class **.R$* {
    public static <fields>;
}
-keep class **.R$*

# Keep resource IDs
-keep class **.R
-keep class **.R$* {
    <fields>;
}

# Keep Flutter assets (images, fonts, etc.)
-keep class io.flutter.embedding.engine.loader.FlutterLoader { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.FlutterInjector { *; }

# Prevent asset files from being removed
-keepclassmembers class * {
    *** lookupKeyForAsset(...);
}

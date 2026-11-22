// ============================================================================
// Android Application Build Script (build.gradle.kts)
// This file configures the build setup, dependencies, plugins, and compilation
// options for the Flutter Android application module using Gradle Kotlin DSL.
// ============================================================================

plugins {
    // The Android application plugin enables building Android APKs and App Bundles.
    id("com.android.application")
    // The Flutter Gradle plugin automates Flutter SDK integration, Dart compilation,
    // plugin registration, and asset packaging.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // The namespace uniquely identifies your application for resource compilation
    // (generating the R class) and AndroidManifest.xml package resolution.
    namespace = "com.example.jess_13"

    // The compileSdk specifies the Android API level used by the Android Gradle Plugin
    // to compile your application against the Android framework APIs.
    compileSdk = 37

    // The exact NDK (Native Development Kit) version required for compiling any
    // C/C++ native libraries or Flutter engine native components.
    ndkVersion = "28.2.13676358"

    // Configure Java source and target compatibility version levels.
    // Modern Android development with Java 17 support enables language features
    // like records, pattern matching, and improved performance.
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Default configuration parameters applied across all build variants and flavors.
    defaultConfig {
        // Unique application ID used by the Google Play Store and system package manager.
        applicationId = "com.example.jess_13"

        // Minimum SDK version defining the oldest Android version supported by the app.
        minSdk = flutter.minSdkVersion

        // Target SDK version indicating the Android version the app is tested and optimized for.
        targetSdk = flutter.targetSdkVersion

        // Integer version code used to track version updates. Supplied dynamically by Flutter tooling.
        versionCode = flutter.versionCode

        // Human-readable version name displayed to users (e.g., "1.0.0"). Supplied by Flutter.
        versionName = flutter.versionName
    }

    // Build types define how different versions of the application are built and packaged.
    buildTypes {
        debug {
            // Disable native debug symbols generation in debug builds to optimize build time and output size.
            ndk.debugSymbolLevel = "NONE"
        }
        release {
            // Configure release build signing. Here, debug signing config is temporarily reused
            // for local testing or custom distribution workflows. Production releases should use dedicated keystores.
            signingConfig = signingConfigs.getByName("debug")

            // Disable native debug symbols generation in release builds (can be enabled if uploading symbol maps to Play Console).
            ndk.debugSymbolLevel = "NONE"
        }
    }
}

// ============================================================================
// Kotlin Compiler Configuration
// ============================================================================
// Configure all Kotlin compilation tasks in this module to target JVM 17,
// matching the Java compatibility level specified in compileOptions above.
tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

// ============================================================================
// Flutter Extension Configuration
// ============================================================================
// Points to the root directory of the Flutter project relative to this android/app module,
// allowing the Flutter Gradle plugin to locate Dart source code, pubspec.yaml, and assets.
flutter {
    source = "../.."
}

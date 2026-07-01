# DCG - Daffodil CrisisGuard

Flutter/Dart mobile app for campus emergency reporting and response.

## What is included

- Minimal professional mobile UI inspired by the SOS Emergency Figma kit.
- Login / sign-up interface.
- Press-and-hold SOS flow.
- Emergency categories.
- Incident report form.
- Cases list with status updates.
- Emergency contacts.
- Firebase-ready architecture placeholder.
- Native Android and iOS project folders.

## Project structure

```text
lib/                 Flutter app source
android/             Android Gradle project for APK/AAB builds
ios/                 iOS Runner project for Xcode/App Store builds
test/                Flutter widget tests
legacy_web/          Archived web prototype kept for reference
```

## Run locally

Install Flutter, then from this repo:

```bash
flutter pub get
flutter run
```

## Android / Play Store

Android platform files are included under `android/` with package id `com.dcg.crisisguard`.

Before publishing, add release signing in `android/key.properties`, replace the app icon, connect Firebase, update the privacy policy, and prepare Play Store listing assets.

Use `android/key.properties.example` as the template for Play Store release signing.
Place Firebase Android config at `android/app/google-services.json` when you enable Firebase.

Build:

```bash
flutter build appbundle --release
```

## iOS / App Store

iOS app source files are included under `ios/` with bundle id target `com.dcg.crisisguard`.

On macOS, run:

```bash
flutter pub get
cd ios
pod install
```

Then open the iOS project in Xcode, select the Apple developer team, set the final bundle identifier, add Firebase `GoogleService-Info.plist` if needed, and archive for App Store Connect.

Use `ios/Runner/GoogleService-Info.plist.example` as the Firebase config placement reference.

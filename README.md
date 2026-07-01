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

## Run locally

Install Flutter, then from this repo:

```bash
flutter pub get
flutter run
```

## Android / Play Store

If Android platform files are missing on your machine, generate them once:

```bash
flutter create --platforms=android .
```

Then build:

```bash
flutter build appbundle --release
```

Before publishing, update package name, app icon, signing config, privacy policy, Firebase config, and Play Store listing assets.

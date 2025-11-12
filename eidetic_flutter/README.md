# Eidetic Memory Trainer - Flutter Port

This is a complete port of the **Eidetic Memory Trainer** Android app from Java to Flutter/Dart.

## 🎮 About

A memory training game based on the famous chimp test (Ayumu memory test). Test and improve your working memory by memorizing and recalling number sequences.

## 📚 Documentation

- **[Russian Instructions (Инструкция на русском)](README_RU.md)** - Complete guide in Russian
- **[Porting Verification](PORTING_VERIFICATION.md)** - Detailed porting analysis

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build release APK
flutter build apk --release
```

## ✅ Porting Status

**100% Complete** - All features, classes, and functionality from the original Android app have been ported to Flutter.

### Ported Components
- ✅ MainActivity.java → game_screen.dart
- ✅ NumberButton.java → number_button.dart
- ✅ SavedData.java → saved_data.dart
- ✅ Speaker.java → speaker.dart
- ✅ LangUtils.java → lang_utils.dart
- ✅ Custom dialogs and UI
- ✅ All game logic and mechanics
- ✅ All visual effects and animations
- ✅ Statistics and progress tracking
- ✅ 7 language number systems
- ✅ Easy/Hard difficulty modes

## 🎯 Features

- Memory training game with 9 numbered buttons
- 60-second timer with visual feedback
- Easy mode (2 hearts) and Hard mode (no mistakes)
- Win streaks and best time records
- Statistics tracking (games, wins, win rate)
- Text-to-speech announcements
- Sound effects
- 7 language support (English, Hindi, Japanese, Khmer, etc.)
- Material Design UI

## 📱 Requirements

- Flutter SDK 3.0.0+
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter plugins
- Android emulator or physical device

## 📦 Dependencies

- `shared_preferences: ^2.2.2` - Data persistence
- `flutter_tts: ^4.0.2` - Text-to-speech
- `audioplayers: ^5.2.1` - Sound effects
- `cupertino_icons: ^1.0.2` - Icons

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   ├── lang_utils.dart   # Language utilities
│   └── saved_data.dart   # Data persistence
├── services/
│   └── speaker.dart      # TTS and audio
├── widgets/
│   ├── custom_dialog.dart
│   └── number_button.dart
└── screens/
    └── game_screen.dart  # Main game screen
```

## 📄 License

```
Copyright 2024 Ashraff Hathibelagal
Ported to Flutter/Dart 2024

Licensed under the Apache License, Version 2.0
```

## 🔗 Original Project

Based on: [Eidetic-Memory-Trainer](https://github.com/hathibelagal-dev/Eidetic-Memory-Trainer)

---

**For detailed instructions in Russian, see [README_RU.md](README_RU.md)**

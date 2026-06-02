# Quran Player

A mobile Quran audio player built with Flutter. Streams recitations of all 114 Surahs using the [AlQuran Cloud API](https://alquran.cloud/) with the Mishary Rashid Alafasy reciter.

---

## Screenshots

> Add screenshots here after running the app.  
> Suggested views: Home list · Search results · Full player · Error state

---

## Features

- Browse all 114 Surahs with Arabic names, English transliterations, verse counts, and revelation type
- Real-time search by name, translation, or surah number
- Stream full audio recitations
- Play, pause, and resume playback
- Progress slider with current position and total duration
- ±10 second skip buttons
- Persistent mini player bar while browsing the list
- Slide-up full player screen
- Shimmer skeleton loading state
- Error state with retry

---

## Tech Stack

| Layer | Technology |
|---|---|
| State Management | [flutter_bloc](https://pub.dev/packages/flutter_bloc) + [equatable](https://pub.dev/packages/equatable) |
| Audio | [just_audio](https://pub.dev/packages/just_audio) |
| Networking | [http](https://pub.dev/packages/http) |
| UI | Material 3, custom dark theme, [shimmer](https://pub.dev/packages/shimmer) |
| Testing | flutter_test, [bloc_test](https://pub.dev/packages/bloc_test), [mockito](https://pub.dev/packages/mockito) |

---

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── surah.dart
├── repositories/
│   ├── quran_repository.dart
│   └── audio_repository.dart
├── blocs/
│   ├── surah_list_bloc.dart
│   ├── surah_list_event.dart
│   ├── surah_list_state.dart
│   ├── player_bloc.dart
│   ├── player_event.dart
│   └── player_state.dart
├── screens/
│   ├── home_screen.dart
│   └── player_screen.dart
├── widgets/
│   ├── surah_list_tile.dart
│   ├── surah_search_bar.dart
│   ├── mini_player_bar.dart
│   └── player_controls.dart
└── utils/
    ├── app_theme.dart
    └── duration_formatter.dart

test/
├── blocs/
│   └── surah_list_bloc_test.dart
├── unit/
│   ├── quran_repository_test.dart
│   └── duration_formatter_test.dart
└── widgets/
    └── surah_list_tile_test.dart
```

---

## Architecture

The app follows the **BLoC** pattern with a **Repository** layer.

```
Screens / Widgets
       │
       │ dispatch Events
       ▼
     BLoC
       │
       │ calls
       ▼
  Repositories
  (API / Audio)
       │
       │ returns data / streams
       ▼
     BLoC
       │
       │ emits States
       ▼
Screens / Widgets rebuild
```

### SurahListBloc

Manages loading and filtering the surah list.

| Event | State |
|---|---|
| `SurahListFetchRequested` | `SurahListLoading` → `SurahListLoaded` \| `SurahListError` |
| `SurahListSearchChanged` | `SurahListLoaded` (filtered) |
| `SurahListSearchCleared` | `SurahListLoaded` (full list) |

### PlayerBloc

Manages the full audio playback lifecycle.

| Event | State |
|---|---|
| `PlayerPlayRequested` | `loading` → `playing` \| `error` |
| `PlayerPauseRequested` | `paused` |
| `PlayerResumeRequested` | `playing` |
| `PlayerSeekRequested` | position updated |
| `PlayerPositionUpdated` | position updated (from stream) |
| `PlayerDurationUpdated` | duration updated (from stream) |
| `PlayerPlaybackCompleted` | `completed` |
| `PlayerStopRequested` | `idle` |

---

## API

All data comes from the [AlQuran Cloud API](https://alquran.cloud/api).

| Endpoint | Usage |
|---|---|
| `GET /v1/surah` | Fetch all 114 surahs |
| `GET /v1/surah/:id` | Fetch a single surah |

Audio is streamed from:

```
https://cdn.islamic.network/quran/audio-surah/128/ar.alafasy/{number}.mp3
```

---

## Getting Started

### Requirements

- Flutter `>=3.10.0`
- Dart `>=3.1.0`
- Android SDK or Xcode
- Internet connection

### Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Test

```bash
flutter test
```

### Test with coverage

```bash
flutter test --coverage
```

---

## Tests

| File | Coverage |
|---|---|
| `test/blocs/surah_list_bloc_test.dart` | All BLoC event → state transitions |
| `test/unit/quran_repository_test.dart` | HTTP success, error handling, model parsing |
| `test/unit/duration_formatter_test.dart` | Edge cases: zero, minutes, hours |
| `test/widgets/surah_list_tile_test.dart` | Render, tap, icon, caption |

---

## Design Tokens

All values are defined in `lib/utils/app_theme.dart`.

| Token | Hex |
|---|---|
| Primary | `#1A8C6E` |
| Primary Dark | `#0F5C48` |
| Primary Light | `#4DB898` |
| Accent (gold) | `#D4AF37` |
| Surface | `#121212` |
| Surface Card | `#252525` |
| Error | `#CF6679` |

---

## Dependencies

```yaml
flutter_bloc: ^8.1.3
bloc: ^8.1.2
equatable: ^2.0.5
http: ^1.1.0
just_audio: ^0.9.36
shimmer: ^3.0.0

# dev
bloc_test: ^9.1.5
mockito: ^5.4.3
build_runner: ^2.4.6
```

---

## Platform Setup

### Android

Internet and foreground service permissions are declared in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

### iOS

Background audio mode is declared in `Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

---

## License

MIT

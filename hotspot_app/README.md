# HotSpot V0.1

Hyper-local event discovery app built with Flutter.

---

## Setup (Do This First)

### 1. Install Flutter
https://docs.flutter.dev/get-started/install

Choose your OS. Follow the guide completely.
Run `flutter doctor` at the end — fix any red items before continuing.

### 2. Clone / open this project
Open a terminal in this folder.

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run the app
```bash
# On a connected Android/iOS device:
flutter run

# On an emulator (must be running first):
flutter run

# To pick a specific device:
flutter devices
flutter run -d <device_id>
```

---

## Project Structure

```
lib/
├── main.dart                  # App entry point + bottom navigation
├── models/
│   └── event.dart             # Event data model + enums
├── screens/
│   ├── home_screen.dart       # Discovery feed
│   ├── calendar_screen.dart   # RSVP'd events
│   ├── profile_screen.dart    # Static profile
│   └── event_detail_screen.dart  # Full event view
├── widgets/
│   └── event_card.dart        # Reusable event card component
└── services/
    └── mock_data.dart         # Hardcoded events (replaced by Firebase in Phase 5)
```

---

## V0.1 Feature Scope

| Feature | Status |
|---|---|
| Home feed with event cards | ✅ |
| Filter chips (Today, Music, Food, etc.) | ✅ |
| Event detail screen | ✅ |
| RSVP toggle (Interested / Going) | ✅ |
| Save (star) toggle | ✅ |
| Calendar screen showing RSVP'd events | ✅ |
| Static profile screen | ✅ |
| Bottom navigation | ✅ |

---

## Phase Roadmap

- **Phase 1** (Current): Static events, navigation, RSVP UI
- **Phase 2**: Dart models, reusable components ✅ (done alongside Phase 1)
- **Phase 3**: State management (Provider or Riverpod)
- **Phase 4**: Local persistence (SharedPreferences or Hive)
- **Phase 5**: Firebase — Firestore events, Auth

---

## Usability Fixes Applied (from user interviews)

- Renamed "Go" → "RSVP" (unclear original label)
- RSVP has 3 states: None → Interested → Going (not binary)
- FREE label prominently shown in green
- Paid event price shown in dark badge
- Category color tags for visual scanning
- "+" moved out of feed (was confused with "add to calendar")
- Text hierarchy increased for readability
- Verification badge is green checkmark (people only, not events)

---

## Next Question to Ask Claude

> "How do I implement proper state management so RSVP changes on HomeScreen reflect on CalendarScreen without rebuilding both?"

That's your Phase 3 problem. That's the right next question.

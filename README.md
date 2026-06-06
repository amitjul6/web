# CalorieDesi 🍛

A professional Android health tracker that combines **Indian food calorie logging**
with **activity tracking** (phone step sensor + manual exercises), a **net-calorie
engine**, weight trends, and streaks/badges. Built with **Flutter**, local-first.

> Status: complete Flutter source. The Flutter/Android SDK is **not** bundled here —
> build locally with the steps below to produce an APK.

## Features
- **Step tracking** from the phone's built-in step counter (`pedometer`), with a
  per-day baseline that survives reboots.
- **Manual step override** per day when the sensor is unavailable (e.g. emulator).
- **Exercise logging** (cycling, running, push-ups, yoga, …) that **calculates
  calories burned** via MET / rep formulas using your weight.
- **Indian food library** of ~65 items (portion + calories + macros). Search,
  filter by category, add with quantity, edit/delete.
- **Net calorie balance**: `calories in − (BMR + step + exercise calories)`, with a
  BMR/TDEE engine (Mifflin-St Jeor) computed from your profile.
- **Weight log + trend chart** (`fl_chart`) toward a goal.
- **Goals, streaks & badges** for motivation.
- **Google (Gmail) sign-in** + profile (with a guest fallback so the app runs
  without Firebase configured).
- Polished **Material 3** UI (teal), light & dark.
- **Local-first**: all data stored on-device via Hive. No backend.

## Tech stack
| Area | Choice |
|------|--------|
| Framework | Flutter (Dart), Material 3 |
| State | Riverpod (`flutter_riverpod`) |
| Storage | Hive CE (`hive_ce`) + `shared_preferences` |
| Sensors | `pedometer`, `permission_handler` (ACTIVITY_RECOGNITION) |
| Auth | `google_sign_in` |
| Charts | `fl_chart` |

## Project layout
```
lib/
  core/        formulas, exercise calc, date utils, constants
  models/      profile, food, exercise, weight, goals, steps, streak, summary, app_data
  data/        food_library, exercise_catalog, badge_catalog, local_store (Hive)
  services/    pedometer, permission, auth, streak
  providers/   service providers, app_data notifier, auth, steps controller
  screens/     login, onboarding, home, food, exercise, weight, profile
  widgets/     calorie_ring, weight_chart, date_selector, section_card
test/          formulas, daily_summary, streak, exercise_calc unit tests
reference/     original single-file HTML prototype (kept for reference)
docs/          android_setup.md (manifest, gradle, Google sign-in, signing)
```

## Build & run (local)
Prerequisites: [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.35+)
with the Android toolchain (`flutter doctor` all green).

The `android/` platform folder is **already included** (with the
`ACTIVITY_RECOGNITION` permission wired in), so you can build straight away:

```bash
flutter pub get
flutter test                # 19 unit tests
flutter run                 # on a connected device/emulator
flutter build apk --debug   # build/app/outputs/flutter-apk/app-debug.apk
```

> Verified: this project passes `flutter analyze` (no issues) and `flutter test`
> (all green), and compiles end-to-end on Flutter 3.44.1.

For a **signed release APK / Play Store bundle** and **Google sign-in setup**
(Firebase project, `google-services.json`, SHA-1 registration, keystore), follow
[`docs/android_setup.md`](docs/android_setup.md).

## Calorie model
- **BMR (Mifflin-St Jeor):** `10·kg + 6.25·cm − 5·age + 5` (male) / `− 161` (female).
- **TDEE:** BMR × activity factor (1.2 – 1.9).
- **Steps:** `steps × 0.00057 × weightKg` kcal.
- **Exercise (duration):** `MET × 3.5 × weightKg / 200 × minutes`; reps use a
  weight-scaled kcal/rep; distance (running) converts km→minutes via pace.
- **Net:** `caloriesIn − (BMR + stepCalories + exerciseCalories)`. BMR (not TDEE)
  is the baseline so the activity factor isn't double-counted.

All values are typical estimates for general wellness tracking — not medical advice.

## Known limitations (this version)
- No cloud sync — data is per-device. Sign-in is required each launch (in-memory).
- Emulators have no step sensor; use the manual **Override** to test step features.
- Google sign-in needs Firebase config + SHA-1 to work in a real build (guest mode
  works without it).

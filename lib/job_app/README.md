# 💼 DreamJob – Flutter App

A complete Flutter job-finder app matching the orange/white UI design.

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Splash** | Animated logo, auto-routes based on login state |
| **Welcome** | Illustration + Login / Register buttons |
| **Login** | Email/password form, social auth icons, validation |
| **Register** | Create account form with confirm password |
| **Dashboard** | Job list, category filter, search bar, stats |
| **Job Detail** | Full job info, apply button, bookmark |
| **Saved Jobs** | All bookmarked jobs |
| **Profile** | User stats, info fields |
| **Settings** | Toggles (dark mode, notifications, location), logout |

## 🗄️ LocalStorage (shared_preferences)

| Key | Type | Description |
|-----|------|-------------|
| `user_email` | String | Logged-in user's email |
| `user_name` | String | Derived from email |
| `is_logged_in` | bool | Auth state for splash routing |
| `saved_jobs` | JSON List | Bookmarked job IDs |
| `applied_jobs` | JSON List | Applied job IDs |
| `dark_mode` | bool | UI preference |
| `notifications_enabled` | bool | Alert preference |
| `location_enabled` | bool | Location permission preference |

## 🚀 Getting Started

```bash
flutter pub get
flutter run
```

## 📦 Dependencies

```yaml
shared_preferences: ^2.2.2   # LocalStorage
cupertino_icons: ^1.0.6       # iOS icons
```

## 🗂️ Project Structure

```
lib/
├── main.dart                  # App entry + routes
├── theme/
│   └── app_theme.dart         # Colors, theme, input styles
├── models/
│   └── job_model.dart         # Job data class + sample data
├── services/
│   └── storage_service.dart   # SharedPreferences wrapper
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart       # Dashboard + BottomNav
│   ├── job_detail_screen.dart
│   ├── saved_jobs_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
└── widgets/
    └── job_card.dart          # Reusable job card
```

## 🎨 Design

- **Primary**: `#E84A1C` (orange-red from the mockup)
- **Background**: `#FAF4F0` (warm off-white)
- **Cards**: Pure white with soft shadows
- **Typography**: Roboto with heavy weights for headings

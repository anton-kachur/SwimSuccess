# Swim Success — Test Assignment

This is my implementation of the Flutter test task for the Strong Junior / Middle Developer position. The app has two main features: a synchronized pace selector with network debouncing and a strictly typed user directory fetched from an API.

## Features Implemented

### 1. Pace Selector Screen
* **Time Input**: Standard custom fields for minutes and seconds with manual keyboard entry validation (0-59 range) and up/down arrow buttons.
* **Synchronized Slider**: A horizontal slider that updates along with the text fields and vice versa.
* **Swimmer Level**: Automatically updates the level string based on the total seconds calculated.
* **Debounced API Request**: Built with `rxdart` to ensure that dragging the slider doesn't spam the server. It waits for a **500ms pause** before triggering the `POST` request to `/posts`.

### 2. User Directory Screen
* **API Integration**: Fetches the user list via a `GET` request from `/users`.
* **Type Safety**: No raw `Map<String, dynamic>` maps inside the UI. Everything is fully parsed into clean immutable models right after fetching.
* **Search & Filter**: Real-time client-side search filtering by name.
* **Pull-to-Refresh**: Standard swipe-to-refresh action to reload the data from the server.
* **Detail Screen**: Shows the complete profile upon tap, including nested address details and company info.

---

## Architecture & State Management

I used a **Feature-First** structure to separate concerns properly:

```text
lib/
├── core/
│   ├── network/      # Base ApiClient wrapper
│   └── theme/        # Global dark theme
└── features/
    ├── pace_selector/
    │   ├── data/     # PaceRepository for POST requests
    │   ├── domain/   # SwimmerLevelCalculator (pure business logic)
    │   └── presentation/ # UI widgets and PaceProvider
    └── user_list/
        ├── data/     # UserModel and UserRepository
        └── presentation/ # UserListScreen and UserDetailScreen
```

### Why Provider?
I chose **`Provider`** with `ChangeNotifier` because it is lightweight and perfectly fits the scope of this project. It keeps the state logic separated from the UI layer without adding massive BLoC-like boilerplate. It also makes it easy to close and dispose of the `rxdart` streams properly.

---

## Swim Level Thresholds (Domain Logic)
* `Total Time <= 65s` -> **Elite**
* `Total Time 66s - 90s` -> **Advanced**
* `Total Time 91s - 130s` -> **Intermediate**
* `Total Time > 130s` -> **Beginner**

---

## Project Setup & Run

```bash
# Clone the project
git clone https://github.com

# Install packages
cd swim_success
flutter pub get

# Run the app
flutter run
```

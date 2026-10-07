# Flutter API Integration with Provider

A Flutter app that fetches data from a public REST API (JSONPlaceholder) using the `http` package and manages state with `Provider`.

## Features 

- **GET request:** loads a list of posts from the API
- **POST request:** creates a new post through an "Add post" dialog
- **Model class:** `Post` with `fromJson` and `toJson` for JSON conversion
- **Loading state:** spinner while data is being fetched
- **Error state:** error message with a Retry button (handles no internet, timeouts and bad status codes)
- **Pull to refresh** and a refresh button in the app bar
- **State management** with `Provider` (`ChangeNotifier`)

## Screenshots

*(Add your screenshots here, for example `screenshots/list.png` and `screenshots/error.png`.)*

## Tech Stack

- Flutter / Dart
- [`http`](https://pub.dev/packages/http) for network requests
- [`provider`](https://pub.dev/packages/provider) for state management
- API: [JSONPlaceholder](https://jsonplaceholder.typicode.com/)

## Project Structure

```
lib/
├── main.dart                      # App entry point, sets up Provider
├── models/
│   └── post.dart                  # Post model with fromJson / toJson
├── providers/
│   └── post_provider.dart         # GET and POST logic, loading and error state
└── screens/
    └── post_list_screen.dart      # UI: list, spinner, error + retry, add dialog
```

## How It Works

1. When the app starts, `PostProvider` sends a **GET** request to `https://jsonplaceholder.typicode.com/posts`.
2. The server responds with a status code (`200 OK`) and a JSON body.
3. `jsonDecode` converts the body into Dart maps, and `Post.fromJson` turns each one into a `Post` object.
4. The provider calls `notifyListeners()`, and the screen rebuilds with the new data.
5. Adding a post sends a **POST** request with `post.toJson()` as the body. A `201 Created` response means success.

| Status code | Meaning |
|---|---|
| 200 | OK (GET succeeded) |
| 201 | Created (POST succeeded) |
| 404 | Not found |
| 500 | Server error |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code with the Flutter and Dart plugins
- An Android emulator, a physical device, or Chrome

### Run the app

```bash
git clone https://github.com/ZainabJunaid003/flutter-api-provider-demo.git
cd flutter-api-provider-demo
flutter pub get
flutter run
```

## Notes

- JSONPlaceholder is a fake API for testing. It returns placeholder (Latin) text, and POST requests return a created post with an id but are **not saved**, so a new post disappears after refreshing.

## Author

Zainab Junaid

# Sodium Recipe App

A mobile recipe app for Android and iOS built with Flutter. Users can create, view, edit, search, and delete their personal recipes. All data is stored locally on-device.

## Features (MVP)

- Create recipes (title, ingredients, instructions)
- View recipe list
- View recipe details
- Edit recipes
- Delete recipes (with confirmation)
- Search recipes by title

## Technology Stack

| Component | Choice |
|-----------|--------|
| Framework | Flutter |
| Language | Dart |
| Database | Isar |
| State Management | Riverpod |

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Android Studio or Xcode

### Installation

```bash
# Clone the repository
git clone https://github.com/philipp-gatzka/sodium.git

# Navigate to project directory
cd sodium

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Running Tests

```bash
flutter test
```

## Project Structure

```
lib/
├── main.dart           # App entry point
├── app.dart            # MaterialApp configuration
├── models/             # Data models
├── repositories/       # Data access layer
├── providers/          # Riverpod providers
├── screens/            # Full-page screens
├── widgets/            # Reusable components
└── theme/              # Styling
```

## Contributing

Please read [CLAUDE.md](CLAUDE.md) for project rules and contribution guidelines.

## License

This project is private and not open source.

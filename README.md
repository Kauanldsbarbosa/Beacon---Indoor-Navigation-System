# Beacon - Indoor Navigation System

A Flutter-based indoor navigation application that uses Bluetooth Low Energy (BLE) beacons to help users navigate through indoor spaces with voice guidance.

## Overview

Beacon is an assistive technology application designed to solve the challenge of indoor navigation where GPS signals are unavailable or unreliable. The system uses BLE beacons strategically placed throughout indoor environments to provide real-time location tracking and voice-guided navigation to users.

**Key Problems Solved:**
- Indoor positioning without GPS
- Accessibility for visually impaired users through voice feedback
- Room identification and navigation guidance
- Real-time proximity detection

## Technologies Used

### Core Framework
- **Flutter 3.10.0-290.4.beta** - Cross-platform mobile development
- **Dart** - Programming language

### Key Dependencies
- **flutter_blue_plus ^1.4.0** - Bluetooth Low Energy communication
- **isar ^3.1.0+1** - Local database for beacon and room data
- **provider ^6.1.5+1** - State management
- **flutter_tts ^4.2.3** - Text-to-speech for voice guidance
- **permission_handler ^11.0.0** - Runtime permissions management
- **path_provider ^2.1.5** - File system access
- **google_fonts ^6.3.3** - Typography

### Development Tools
- **mocktail ^1.0.4** - Testing framework
- **build_runner ^2.4.13** - Code generation
- **isar_generator ^3.1.0+1** - Database schema generation

## Setup

### Prerequisites
- Flutter SDK 3.10.0-290.4.beta or higher
- Android Studio / Xcode (for mobile development)
- Git

### Installation Steps

1. **Clone the repository**
```bash
git clone <repository-url>
cd beacon
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Isar database schemas**
```bash
dart run build_runner build
```

4. **Run the application**
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For a specific device
flutter devices
flutter run -d <device-id>
```

### Platform-Specific Setup

#### Android
- Minimum SDK: API level specified in `android/app/build.gradle`
- Bluetooth permissions are required (automatically requested at runtime)

#### iOS
- Minimum iOS version specified in `ios/Podfile`
- Bluetooth permissions configured in `ios/Runner/Info.plist`

#### Linux
- GTK3 development libraries required
- Build using `linux/CMakeLists.txt`

#### macOS
- Build configuration in `macos/Runner.xcodeproj/project.pbxproj`

#### Windows
- Build using `windows/CMakeLists.txt`

## Project Structure

```
beacon/
├── lib/
│   ├── controllers/          # State management (Providers)
│   │   ├── beacon_provider.dart
│   │   ├── navigator_provider.dart
│   │   └── room_provider.dart
│   ├── models/              # Data models
│   │   ├── beacon.dart
│   │   ├── navigation.dart
│   │   └── room.dart
│   ├── pages/               # UI screens
│   │   ├── home/
│   │   ├── navigation/
│   │   └── room/
│   ├── repositories/        # Data access layer
│   │   ├── beacon_repository.dart
│   │   ├── navigation_repository.dart
│   │   └── room_repository.dart
│   ├── utils/              # Helper functions
│   │   ├── date_utils.dart
│   │   └── speak.dart
│   └── main.dart           # Application entry point
├── test/                   # Unit and widget tests
├── android/               # Android platform code
├── ios/                   # iOS platform code
├── linux/                 # Linux platform code
├── macos/                 # macOS platform code
├── windows/               # Windows platform code
├── web/                   # Web platform assets
└── pubspec.yaml          # Dependencies configuration
```

### Key Directories

- **`lib/controllers`**: Contains Provider classes for state management across the app
- **`lib/models`**: Isar database models with schema definitions
- **`lib/pages`**: UI components organized by feature
- **`lib/repositories`**: Data access abstraction layer interfacing with Isar database
- **`lib/utils`**: Shared utilities including TTS and time formatting

## Architecture

### Data Flow Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User Interface Layer                  │
│  (Flutter Widgets - HomePage, RoomPage, NavigationPage) │
└────────────────┬────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────┐
│                   State Management Layer                 │
│    (Provider - BeaconProvider, RoomProvider,            │
│                NavigatorProvider)                        │
└────────────────┬────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────┐
│                    Repository Layer                      │
│  (BeaconRepository, RoomRepository,                     │
│   NavigationRepository)                                  │
└────────────────┬────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────┐
│                   Persistence Layer                      │
│              (Isar Database - Local Storage)             │
└─────────────────────────────────────────────────────────┘
                 │
                 ↓
┌─────────────────────────────────────────────────────────┐
│                    Hardware Layer                        │
│         (BLE Hardware via flutter_blue_plus)            │
└─────────────────────────────────────────────────────────┘
```

### Component Interactions

1. **Initialization Flow** (`main.dart`)
   - App initializes Isar database
   - Creates repository instances
   - Injects repositories into providers
   - Providers are registered with MultiProvider
   - BeaconProvider starts scanning automatically

2. **Beacon Detection Flow**
   - `BeaconProvider` continuously scans for BLE devices
   - Detected beacons are stored in `BeaconRepository`
   - UI updates reactively through Provider listeners
   - Proximity calculations determine nearest beacon

3. **Room Management Flow**
   - Users create rooms via `RoomPage`
   - `RoomProvider` manages room state
   - Rooms are associated with beacons through `RoomRepository`
   - Data persists in Isar database (`Room` model)

4. **Navigation Flow**
   - User selects destination room
   - `NavigatorProvider` calculates route
   - Voice guidance provided via `AppVoice` utility
   - Real-time updates based on beacon proximity
   - Navigation history stored in `NavigationRepository`

5. **Voice Feedback System**
   - `AppVoice` wrapper around flutter_tts
   - Configured for Portuguese (pt-BR)
   - Provides spoken feedback for navigation and room identification
   - Automatic speech interruption for new messages

### State Management

The application uses the **Provider** pattern:

- **BeaconProvider**: Manages BLE scanning state and beacon list
- **RoomProvider**: Handles room CRUD operations
- **NavigatorProvider**: Controls navigation logic and route calculation

All providers follow the ChangeNotifier pattern, ensuring UI rebuilds when data changes.

### Database Schema

**Isar Collections:**

1. **Beacon** (`lib/models/beacon.dart`)
   - Stores BLE beacon information
   - Fields: id, name, address, rssi, lastSeen

2. **Room** (`lib/models/room.dart`)
   - Represents physical rooms
   - Links to Beacon via relationship
   - Fields: id, name, beacon reference

3. **Navigation** (`lib/models/navigation.dart`)
   - Tracks navigation history
   - Fields: id, destinationRoom, timestamp, completed

## Usage Examples

### Scanning for Beacons

The app automatically starts scanning when launched. View detected beacons on the home screen:

```dart
// BeaconProvider handles scanning automatically in main.dart
BeaconProvider(beaconRepository: beaconRepository)..startBeacon()
```

### Creating a Room

1. Navigate to Room Management page
2. Click "Add Room" button
3. Enter room name
4. Select associated beacon from detected list
5. Save

```dart
// Example from room_page.dart
await roomProvider.saveRoom(nome, beacon);
```

### Starting Navigation

1. Select destination room from navigation page
2. System calculates route based on beacon proximity
3. Voice guidance provides turn-by-turn instructions
4. Follow audio cues to reach destination

### Voice Feedback

```dart
// Utility example from speak.dart
await AppVoice.speak("Você está próximo à sala A");
```

## Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_blue_plus | ^1.4.0 | Bluetooth Low Energy communication |
| isar | ^3.1.0+1 | NoSQL database for local storage |
| isar_flutter_libs | ^3.1.0+1 | Platform-specific Isar libraries |
| provider | ^6.1.5+1 | State management solution |
| flutter_tts | ^4.2.3 | Text-to-speech engine |
| permission_handler | ^11.0.0 | Runtime permission requests |
| path_provider | ^2.1.5 | Access to file system directories |
| google_fonts | ^6.3.3 | Custom typography |
| cupertino_icons | ^1.0.2 | iOS-style icons |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_test | SDK | Testing framework |
| flutter_lints | ^6.0.0 | Dart code analysis |
| isar_generator | ^3.1.0+1 | Code generation for Isar schemas |
| build_runner | ^2.4.13 | Code generation tool |
| mocktail | ^1.0.4 | Mocking library for tests |

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/path/to/test_file.dart
```

### Testing Guidelines

Tests follow the **Given-When-Then** pattern as defined in `TEST_GUIDELINES.md`:

```dart
test('Should return success when API call is 200') {
  // Given: Setup initial state
  // When: Execute action
  // Then: Verify outcome
}
```

**Test Structure:**
- Use `setUp` for initialization
- Use `tearDown` for cleanup
- Test happy path scenarios
- Test error handling
- Mock dependencies with mocktail

## Contributing

We welcome contributions! Here's how you can help:

### Getting Started

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Write tests** following `TEST_GUIDELINES.md`
5. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
6. **Push to your branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Code Standards

- Follow Flutter/Dart style guide
- Use meaningful variable names
- Comment complex logic
- Write tests for new features
- Ensure all tests pass before submitting PR
- Run `flutter analyze` to check for issues

### Areas for Contribution

- **New Features**: Additional navigation algorithms, beacon types
- **UI/UX**: Accessibility improvements, dark mode
- **Performance**: Optimize BLE scanning, reduce battery consumption
- **Documentation**: Improve README, add inline comments
- **Testing**: Increase test coverage
- **Localization**: Add support for additional languages beyond pt-BR

### Reporting Issues

When reporting bugs, please include:
- Flutter version (`flutter --version`)
- Device/platform information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## License

See license information in generated notices:
- `NOTICES`

## Platform Support

- ✅ Android
- ✅ iOS  
## Troubleshooting

### Common Issues

**Bluetooth permissions denied:**
- Ensure location permissions are granted on Android
- Check Bluetooth permissions in iOS Settings

**Database initialization fails:**
- Delete app data and reinstall
- Check `path_provider` has proper permissions

**Beacons not detected:**
- Ensure Bluetooth is enabled
- Verify beacons are powered on and broadcasting
- Check beacon UUID matches expected format

**Build failures:**
- Run `flutter clean`
- Delete `build` directory
- Run `flutter pub get`
- Regenerate code with `dart run build_runner build --delete-conflicting-outputs`

---

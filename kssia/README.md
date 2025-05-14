# KSSIA Package Integration Guide

This package provides a seamless integration of the KSSIA login functionality into your existing Flutter application.

## Setup Instructions

1. Add the following dependencies to your `pubspec.yaml`:
```yaml
dependencies:
  kssia:
    path: ../path_to_kssia_package
```

2. Initialize the package in your app's `main.dart`:
```dart
import 'package:kssia/kssia.dart';

void main() async {
  await KssiaPackage.initialize();  // This will also initialize assets
  runApp(MyApp());
}
```

3. To navigate to the KSSIA login screen from your app:
```dart
import 'package:kssia/kssia.dart';

// In your button's onPressed callback:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => KssiaPackage.getLoginScreen(),
  ),
);
```

## Features
- Secure login integration
- Seamless navigation flow
- Maintains your app's state while using KSSIA features
- All required assets and fonts are included in the package

## Important Security Notes
1. Only import the package using `import 'package:kssia/kssia.dart'`
2. Do not attempt to import internal classes directly
3. The only public API is the `KssiaPackage` class
4. All internal implementation details are hidden and cannot be accessed

## Asset Handling
The package includes all necessary assets and fonts. You don't need to:
- Copy any assets to your project
- Configure any additional asset paths
- Handle font loading

All assets are automatically loaded when you call `KssiaPackage.initialize()`.

## Note
The package handles all necessary Firebase initialization, state management, and asset loading internally. You don't need to worry about the implementation details.

# vpn_checker_example

Demonstrates how to use the vpn_checker plugin.

## Getting Started

This example app shows how to use the VPN Checker plugin to detect if the device is currently using a VPN connection.

### Running the Example

1. Make sure you have Flutter installed and set up properly.

2. Navigate to the example directory:
```bash
cd example
```

3. Get the dependencies:
```bash
flutter pub get
```

4. Run the app on your desired platform:

For Android:
```bash
flutter run -d android
```

For iOS:
```bash
flutter run -d ios
```

For macOS:
```bash
flutter run -d macos
```

For Windows:
```bash
flutter run -d windows
```

For Linux:
```bash
flutter run -d linux
```

### Testing VPN Detection

To properly test the VPN detection functionality:

1. **Without VPN**: Run the app normally - it should show "VPN is Not Active"
2. **With VPN**: Connect to a VPN on your device, then run the app or tap the "Check Again" button - it should show "VPN is Active"

### Supported VPN Types

The plugin can detect various types of VPN connections:

- OpenVPN
- WireGuard
- PPTP
- L2TP
- IPSec
- Cisco AnyConnect
- And many other VPN implementations

## Code Example

```dart
import 'package:vpn_checker/vpn_checker.dart';

// Check if VPN is active
bool isActive = await VpnChecker.isVpnActive();

if (isActive) {
  print('VPN is currently active');
} else {
  print('VPN is not active');
}
```


# VPN Checker

A Flutter plugin to detect if the device is currently using a VPN connection. This plugin supports Android, iOS, macOS, Windows, and Linux platforms.

## Features

- ✅ Detect VPN connections on Android (API 21+)
- ✅ Detect VPN/Proxy connections on iOS
- ✅ Detect VPN connections on macOS
- ✅ Detect VPN connections on Windows
- ✅ Detect VPN connections on Linux
- ✅ Simple and easy-to-use API

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  vpn_checker: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Configuration

✨ **Great News: No additional configuration required on any platform!**

- ✅ **Android**: Permissions auto-added (`ACCESS_NETWORK_STATE`)
- ✅ **iOS**: No configuration needed, uses public APIs
- ✅ **macOS**: No configuration needed, uses public APIs
- ✅ **Windows**: No configuration needed, libraries auto-linked
- ✅ **Linux**: No configuration needed, uses standard permissions

**Plug and play - just add the dependency and start using!** 🎉

For detailed integration guide, see [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)

## Usage

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

## Platform-Specific Implementation

### Android
- Uses `ConnectivityManager` to check for VPN transport type (API 23+)
- Checks network interface names (tun, tap, ppp, etc.)
- Reads routing table from `/proc/net/route`

### iOS
- **Direct network interface detection** (using `getifaddrs()`, most reliable)
- Checks system proxy settings (URL-specific proxy)
- Detects VPN interfaces (tap, tun, ppp, ipsec, utun, wg)
- Checks HTTP/HTTPS/SOCKS proxy configuration
- Scoped network settings check
- Recursive proxy key detection

### macOS
- Identical implementation to iOS
- **Direct network interface detection** (using `getifaddrs()`)
- Supports all iOS detection methods

### Windows
- Uses WMI (Windows Management Instrumentation) to query network adapters
- Checks for VPN-type network interfaces

### Linux
- Reads network interfaces from `/proc/net/dev`
- Checks routing table from `/proc/net/route`

## Requirements

- Flutter: >=3.0.0
- Dart: >=3.0.0
- Android: minSdkVersion 21
- iOS: 12.0+
- macOS: 10.14+
- Windows: Windows 10+
- Linux: Any modern distribution

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Issues

If you encounter any issues or have questions, please file them on the [GitHub issue tracker](https://github.com/tikoua/vpn_checker/issues).


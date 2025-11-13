## 0.1.0

* Initial release
* Support for Android VPN detection
  - ConnectivityManager API check (Android 6.0+)
  - Network interface name check
  - Routing table check
* Support for iOS VPN/Proxy detection
  - Direct network interface check using `getifaddrs()`
  - URL-specific proxy check
  - HTTP/HTTPS/SOCKS proxy detection
  - Scoped network settings check
  - Recursive proxy key detection
* Support for macOS VPN detection (same as iOS)
* Support for Windows VPN detection
  - Network adapter description check
  - Tunnel interface detection
* Support for Linux VPN detection
  - `/proc/net/dev` interface check
  - `/proc/net/route` routing table check
* Simple API: `VpnChecker.isVpnActive()`


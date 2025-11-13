/// A Flutter plugin to detect if the device is using a VPN connection.
library vpn_checker;

import 'vpn_checker_platform_interface.dart';

/// The main class for VPN detection.
class VpnChecker {
  /// Checks if the device is currently using a VPN connection.
  ///
  /// Returns `true` if a VPN is active, `false` otherwise.
  ///
  /// Throws a [PlatformException] if the check fails.
  ///
  /// Example:
  /// ```dart
  /// bool isActive = await VpnChecker.isVpnActive();
  /// if (isActive) {
  ///   print('VPN is currently active');
  /// } else {
  ///   print('VPN is not active');
  /// }
  /// ```
  static Future<bool> isVpnActive() {
    return VpnCheckerPlatform.instance.isVpnActive();
  }
}


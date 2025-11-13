import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'vpn_checker_platform_interface.dart';

/// An implementation of [VpnCheckerPlatform] that uses method channels.
class MethodChannelVpnChecker extends VpnCheckerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vpn_checker');

  @override
  Future<bool> isVpnActive() async {
    try {
      final bool? result = await methodChannel.invokeMethod<bool>('isVpnActive');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check VPN status: ${e.message}');
      return false;
    }
  }
}


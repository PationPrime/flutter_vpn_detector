import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'vpn_checker_method_channel.dart';

/// The interface that implementations of vpn_checker must implement.
///
/// Platform implementations should extend this class rather than implement it as `vpn_checker`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [VpnCheckerPlatform] methods.
abstract class VpnCheckerPlatform extends PlatformInterface {
  /// Constructs a VpnCheckerPlatform.
  VpnCheckerPlatform() : super(token: _token);

  static final Object _token = Object();

  static VpnCheckerPlatform _instance = MethodChannelVpnChecker();

  /// The default instance of [VpnCheckerPlatform] to use.
  ///
  /// Defaults to [MethodChannelVpnChecker].
  static VpnCheckerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VpnCheckerPlatform] when
  /// they register themselves.
  static set instance(VpnCheckerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Checks if the device is currently using a VPN connection.
  ///
  /// Returns `true` if a VPN is active, `false` otherwise.
  Future<bool> isVpnActive() {
    throw UnimplementedError('isVpnActive() has not been implemented.');
  }
}


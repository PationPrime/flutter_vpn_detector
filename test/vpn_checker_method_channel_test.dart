import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vpn_detector/vpn_checker_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelVpnChecker platform = MethodChannelVpnChecker();
  const MethodChannel channel = MethodChannel('vpn_checker');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'isVpnActive') {
          return false;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('isVpnActive returns false when VPN is not active', () async {
    expect(await platform.isVpnActive(), false);
  });

  test('isVpnActive returns true when VPN is active', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'isVpnActive') {
          return true;
        }
        return null;
      },
    );

    expect(await platform.isVpnActive(), true);
  });
}


# Flutter VPN Detector (Flutter VPN检测器)

一个用于检测设备当前是否使用VPN连接的Flutter插件。支持Android、iOS、macOS、Windows和Linux平台。

## 功能特性

- ✅ 检测Android上的VPN连接（API 21+）
- ✅ 检测iOS上的VPN/代理连接
- ✅ 检测macOS上的VPN连接
- ✅ 检测Windows上的VPN连接
- ✅ 检测Linux上的VPN连接
- ✅ 简单易用的API

## 安装

在你的 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  flutter_vpn_detector: ^0.1.0
```

然后运行：

```bash
flutter pub get
```

## 配置要求

✨ **好消息：所有平台都无需额外配置！**

- ✅ **Android**：权限自动添加（`ACCESS_NETWORK_STATE`）
- ✅ **iOS**：无需配置，使用系统公开API
- ✅ **macOS**：无需配置，使用系统公开API
- ✅ **Windows**：无需配置，自动链接所需库
- ✅ **Linux**：无需配置，使用标准权限

**即插即用，添加依赖后直接使用！** 🎉

详细的集成指南请查看 [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md)

## 使用方法

```dart
import 'package:flutter_vpn_detector/vpn_checker.dart';

// 检查VPN是否激活
bool isActive = await VpnChecker.isVpnActive();

if (isActive) {
  print('VPN当前处于激活状态');
} else {
  print('VPN未激活');
}
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:vpn_checker/vpn_checker.dart';

class VpnCheckScreen extends StatefulWidget {
  @override
  _VpnCheckScreenState createState() => _VpnCheckScreenState();
}

class _VpnCheckScreenState extends State<VpnCheckScreen> {
  bool? _isVpnActive;

  @override
  void initState() {
    super.initState();
    _checkVpn();
  }

  Future<void> _checkVpn() async {
    try {
      bool isActive = await VpnChecker.isVpnActive();
      setState(() {
        _isVpnActive = isActive;
      });
    } catch (e) {
      print('检查VPN状态失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VPN检测')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isVpnActive == null
                  ? '正在检查...'
                  : _isVpnActive!
                      ? 'VPN已激活 ✓'
                      : 'VPN未激活 ✗',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkVpn,
              child: Text('重新检查'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 平台特定实现

### Android
- 使用 `ConnectivityManager` 检查VPN传输类型（API 23+）
- 检查网络接口名称（tun、tap、ppp等）
- 从 `/proc/net/route` 读取路由表

### iOS
- **直接网络接口检测**（使用 `getifaddrs()`，最可靠）
- 检查系统代理设置（URL特定代理）
- 检测VPN接口（tap、tun、ppp、ipsec、utun、wg）
- 检查HTTP/HTTPS/SOCKS代理配置
- Scoped网络设置检查
- 递归代理键检测

### macOS
- 与iOS完全相同的实现
- **直接网络接口检测**（使用 `getifaddrs()`）
- 支持所有iOS的检测方法

### Windows
- 使用Windows API查询网络适配器
- 检查VPN类型的网络接口

### Linux
- 从 `/proc/net/dev` 读取网络接口
- 从 `/proc/net/route` 读取路由表

## 可检测的VPN类型

本插件可以检测多种VPN连接类型：

- OpenVPN
- WireGuard
- PPTP
- L2TP
- IPSec
- Cisco AnyConnect
- Fortinet
- SonicWall
- 以及其他大多数VPN实现

## 系统要求

- Flutter: >=3.0.0
- Dart: >=3.0.0
- Android: minSdkVersion 21
- iOS: 12.0+
- macOS: 10.14+
- Windows: Windows 10+
- Linux: 任何现代发行版

## 权限

### Android
插件会自动在 `AndroidManifest.xml` 中添加以下权限：

```xml
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS/macOS
无需额外权限。

### Windows/Linux
无需额外权限。

## 注意事项

1. **Android**: 在某些定制化的Android系统上，VPN检测可能不够准确。
2. **iOS/macOS**: 可以检测系统级VPN和代理设置。
3. **准确性**: 虽然插件使用多种方法检测VPN，但无法保证100%准确，某些特殊的网络配置可能会影响检测结果。

## 常见问题

### Q: 为什么有时检测不到VPN？
A: 某些VPN应用使用特殊的实现方式，可能不会创建标准的VPN接口。本插件使用多种检测方法，但无法涵盖所有情况。

### Q: 可以检测特定的VPN应用吗？
A: 本插件只检测系统级别的VPN连接状态，不能识别具体的VPN应用。

### Q: 支持VPN连接状态监听吗？
A: 当前版本只提供一次性检测，不支持实时监听。如需监听，可以使用定时器定期调用 `isVpnActive()` 方法。

## 许可证

MIT License - 详见 LICENSE 文件。

## 贡献

欢迎贡献！如果你发现bug或有改进建议，请提交 Issue 或 Pull Request。

## 问题反馈

如果遇到任何问题或有疑问，请在 [GitHub issue tracker](https://github.com/tikoua/flutter_vpn_detector/issues) 上提交。

## 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解版本更新内容。


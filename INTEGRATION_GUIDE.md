# 集成指南 (Integration Guide)

本文档详细说明第三方应用如何集成和使用 `vpn_checker` 插件。

## 📦 基本集成

### 1. 添加依赖

在你的 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  vpn_checker: ^0.1.0
```

然后运行：
```bash
flutter pub get
```

### 2. 导入包

```dart
import 'package:vpn_checker/vpn_checker.dart';
```

### 3. 使用

```dart
bool isVpnActive = await VpnChecker.isVpnActive();
```

## ✅ 平台配置要求

### 🤖 Android - **无需额外配置** ✨

**自动处理的配置：**
- ✅ `ACCESS_NETWORK_STATE` 权限已在插件中声明
- ✅ 自动合并到应用的 `AndroidManifest.xml`
- ✅ minSdkVersion 21 会自动应用

**你不需要做任何事情！**

插件的 `AndroidManifest.xml` 会自动合并到你的应用中：
```xml
<!-- 这些权限会自动添加，你不需要手动配置 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 🍎 iOS - **无需额外配置** ✨

**自动处理的配置：**
- ✅ 使用的都是系统公开API（`getifaddrs`, `CFNetwork`）
- ✅ 不需要特殊权限
- ✅ 不需要修改 `Info.plist`
- ✅ 不需要添加 capabilities

**你不需要做任何事情！**

**最低版本要求：**
- iOS 12.0+（插件已配置）

### 💻 macOS - **无需额外配置** ✨

**自动处理的配置：**
- ✅ 使用的都是系统公开API
- ✅ 不需要特殊权限
- ✅ 不需要修改 entitlements
- ✅ 不需要修改 `Info.plist`

**你不需要做任何事情！**

**最低版本要求：**
- macOS 10.14+（插件已配置）

### 🪟 Windows - **无需额外配置** ✨

**自动处理的配置：**
- ✅ 使用 Windows 标准 API
- ✅ 不需要管理员权限
- ✅ 自动链接所需的库（iphlpapi.lib, ws2_32.lib）

**你不需要做任何事情！**

**最低版本要求：**
- Windows 10+

### 🐧 Linux - **无需额外配置** ✨

**自动处理的配置：**
- ✅ 读取 `/proc/net/dev` 和 `/proc/net/route`（标准权限）
- ✅ 不需要 root 权限
- ✅ 不需要额外的系统包

**你不需要做任何事情！**

## 📝 完整示例

### 简单示例

```dart
import 'package:flutter/material.dart';
import 'package:vpn_checker/vpn_checker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('VPN Checker')),
        body: Center(
          child: VpnCheckButton(),
        ),
      ),
    );
  }
}

class VpnCheckButton extends StatefulWidget {
  @override
  _VpnCheckButtonState createState() => _VpnCheckButtonState();
}

class _VpnCheckButtonState extends State<VpnCheckButton> {
  String _status = 'Press button to check';

  Future<void> _checkVpn() async {
    bool isActive = await VpnChecker.isVpnActive();
    setState(() {
      _status = isActive ? 'VPN is Active ✓' : 'VPN is Not Active ✗';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_status, style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _checkVpn,
          child: Text('Check VPN'),
        ),
      ],
    );
  }
}
```

### 带错误处理的示例

```dart
Future<void> checkVpnWithErrorHandling() async {
  try {
    bool isVpnActive = await VpnChecker.isVpnActive();
    
    if (isVpnActive) {
      print('✓ VPN is currently active');
      // 执行VPN相关逻辑
    } else {
      print('✗ VPN is not active');
      // 执行非VPN逻辑
    }
  } catch (e) {
    print('Error checking VPN status: $e');
    // 处理错误情况
  }
}
```

### 定期检查示例

```dart
import 'dart:async';
import 'package:vpn_checker/vpn_checker.dart';

class VpnMonitor {
  Timer? _timer;
  bool _lastVpnState = false;
  
  void startMonitoring({Duration interval = const Duration(seconds: 5)}) {
    _timer = Timer.periodic(interval, (timer) async {
      bool isActive = await VpnChecker.isVpnActive();
      
      if (isActive != _lastVpnState) {
        // VPN状态发生变化
        print('VPN状态变化: ${isActive ? "已连接" : "已断开"}');
        _lastVpnState = isActive;
        // 触发回调或状态更新
      }
    });
  }
  
  void stopMonitoring() {
    _timer?.cancel();
    _timer = null;
  }
}

// 使用示例
final monitor = VpnMonitor();
monitor.startMonitoring(interval: Duration(seconds: 10));

// 停止监控
monitor.stopMonitoring();
```

## ⚙️ 高级配置（可选）

### 调整最低SDK版本（Android）

如果你的应用需要支持更低的Android版本，请注意：
- 插件要求 `minSdkVersion 21` (Android 5.0)
- 如果你的应用设置了更低的版本，会自动使用插件的要求

在 `android/app/build.gradle` 中：
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // 插件要求的最低版本
    }
}
```

### 调整最低iOS版本

插件要求 iOS 12.0+，在 `ios/Podfile` 中：
```ruby
platform :ios, '12.0'  # 插件要求的最低版本
```

### 调整最低macOS版本

插件要求 macOS 10.14+，在 `macos/Podfile` 中：
```ruby
platform :osx, '10.14'  # 插件要求的最低版本
```

## 🔍 故障排查

### 问题1：Android编译错误

**错误信息：** `Manifest merger failed`

**解决方案：**
检查你的 `AndroidManifest.xml` 中是否有冲突的权限声明。插件的权限会自动合并。

### 问题2：iOS编译错误

**错误信息：** `Undefined symbols for architecture`

**解决方案：**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### 问题3：macOS权限问题

**错误信息：** 运行时崩溃或权限错误

**解决方案：**
macOS应用需要启用网络权限，在 `macos/Runner/DebugProfile.entitlements` 和 `Release.entitlements` 中添加：
```xml
<key>com.apple.security.network.client</key>
<true/>
```

**注意：** 这通常在Flutter项目创建时已经自动配置。

### 问题4：返回结果不准确

**可能原因：**
1. 某些VPN使用特殊实现，可能无法检测
2. 企业VPN或特殊网络配置

**调试建议：**
```dart
// 在不同网络环境下测试
print('Testing without VPN...');
bool result1 = await VpnChecker.isVpnActive();

print('Please connect VPN and press button...');
await Future.delayed(Duration(seconds: 5));

print('Testing with VPN...');
bool result2 = await VpnChecker.isVpnActive();

print('Without VPN: $result1, With VPN: $result2');
```

## 📊 性能考虑

### 调用频率建议

```dart
// ✅ 推荐：按需检查
void onUserAction() async {
  bool isVpnActive = await VpnChecker.isVpnActive();
  // 处理结果
}

// ✅ 推荐：定期检查（间隔不要太短）
Timer.periodic(Duration(seconds: 30), (timer) async {
  bool isVpnActive = await VpnChecker.isVpnActive();
});

// ⚠️ 不推荐：频繁检查
Timer.periodic(Duration(milliseconds: 100), (timer) async {
  // 太频繁，可能影响性能
  bool isVpnActive = await VpnChecker.isVpnActive();
});
```

### 性能特点

- **首次调用：** ~1-5ms（直接接口检查）
- **后续调用：** ~1-3ms（已缓存部分系统信息）
- **内存占用：** 极小（< 1MB）
- **CPU占用：** 极低

## 🎯 最佳实践

### 1. 应用启动时检查

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isVpnActive;

  @override
  void initState() {
    super.initState();
    _checkVpnOnStartup();
  }

  Future<void> _checkVpnOnStartup() async {
    final isActive = await VpnChecker.isVpnActive();
    setState(() {
      _isVpnActive = isActive;
    });
    
    if (isActive) {
      // 显示VPN相关提示或调整应用行为
    }
  }

  @override
  Widget build(BuildContext context) {
    // 构建UI
  }
}
```

### 2. 网络请求前检查

```dart
Future<void> makeSecureRequest() async {
  bool isVpnActive = await VpnChecker.isVpnActive();
  
  if (isVpnActive) {
    // VPN环境下的特殊处理
    print('Warning: VPN detected, some features may be restricted');
  }
  
  // 继续执行网络请求
}
```

### 3. 状态管理集成（使用Provider）

```dart
import 'package:provider/provider.dart';
import 'package:vpn_checker/vpn_checker.dart';

class VpnState extends ChangeNotifier {
  bool _isVpnActive = false;
  bool get isVpnActive => _isVpnActive;

  Future<void> checkVpn() async {
    _isVpnActive = await VpnChecker.isVpnActive();
    notifyListeners();
  }
}

// 在应用中使用
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => VpnState(),
      child: MyApp(),
    ),
  );
}

// 在Widget中访问
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vpnState = context.watch<VpnState>();
    return Text(vpnState.isVpnActive ? 'VPN Active' : 'VPN Inactive');
  }
}
```

## 📚 总结

**核心要点：**
1. ✅ **只需添加依赖** - 所有平台都无需额外配置
2. ✅ **权限自动处理** - Android权限自动合并
3. ✅ **即插即用** - 导入包后直接调用API
4. ✅ **跨平台一致** - 所有平台使用相同的API

**开始使用只需3步：**
```yaml
# 1. pubspec.yaml
dependencies:
  vpn_checker: ^0.1.0
```

```dart
// 2. 导入
import 'package:vpn_checker/vpn_checker.dart';

// 3. 使用
bool isActive = await VpnChecker.isVpnActive();
```

就这么简单！🎉


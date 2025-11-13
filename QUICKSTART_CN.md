# 快速开始指南

## 🚀 5分钟快速开始

### 1. 测试插件（本地开发）

由于插件还未发布到pub.dev，你可以在本地测试：

```bash
# 进入示例应用目录
cd example

# 获取依赖
flutter pub get

# 运行示例应用（选择你的平台）
flutter run -d android   # Android
flutter run -d ios       # iOS
flutter run -d macos     # macOS
flutter run -d windows   # Windows
flutter run -d linux     # Linux
```

### 2. 在现有项目中使用（本地引用）

在你的Flutter项目的 `pubspec.yaml` 中添加本地路径引用：

```yaml
dependencies:
  vpn_checker:
    path: /Users/tikoua/Documents/local.nosync/workspace/tikoua/vpn_checker/vpn_checker
```

然后运行：
```bash
flutter pub get
```

### 3. 基本使用

```dart
import 'package:vpn_checker/vpn_checker.dart';

// 检查VPN状态
bool isVpnActive = await VpnChecker.isVpnActive();
print('VPN状态: ${isVpnActive ? "已连接" : "未连接"}');
```

### 4. 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:vpn_checker/vpn_checker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VpnCheckScreen(),
    );
  }
}

class VpnCheckScreen extends StatefulWidget {
  @override
  _VpnCheckScreenState createState() => _VpnCheckScreenState();
}

class _VpnCheckScreenState extends State<VpnCheckScreen> {
  String _status = '点击按钮检查VPN状态';

  Future<void> _checkVpn() async {
    try {
      bool isActive = await VpnChecker.isVpnActive();
      setState(() {
        _status = isActive ? 'VPN已连接 ✓' : 'VPN未连接 ✗';
      });
    } catch (e) {
      setState(() {
        _status = '检查失败: $e';
      });
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
            Text(_status, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkVpn,
              child: Text('检查VPN'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 📱 平台特定说明

### Android
- 最低SDK版本：21
- 自动添加 `ACCESS_NETWORK_STATE` 权限

### iOS
- 最低版本：12.0
- 无需额外配置

### macOS
- 最低版本：10.14
- 无需额外配置

### Windows
- Windows 10或更高版本
- 无需额外配置

### Linux
- 任何现代Linux发行版
- 无需额外配置

## 🧪 测试VPN检测

### 方法1：使用真实VPN
1. 在设备上安装VPN应用（如OpenVPN、WireGuard等）
2. 连接VPN
3. 运行应用并检查结果

### 方法2：使用系统VPN设置
1. 在系统设置中配置VPN连接
2. 连接VPN
3. 运行应用并检查结果

### 预期结果
- **未连接VPN**：`isVpnActive()` 返回 `false`
- **已连接VPN**：`isVpnActive()` 返回 `true`

## 🔍 调试

如果检测不准确，请检查：

1. **Android**: 查看logcat日志
```bash
flutter logs
```

2. **iOS/macOS**: 查看Xcode控制台

3. **Windows/Linux**: 查看终端输出

## 📦 发布到pub.dev

准备发布时，按照以下步骤：

1. 确保所有平台测试通过
2. 更新版本号和更新日志
3. 运行预发布检查：
```bash
flutter pub publish --dry-run
```

4. 发布：
```bash
flutter pub publish
```

详细步骤见 [PUBLISH.md](PUBLISH.md)

## ❓ 常见问题

**Q: 为什么检测不到我的VPN？**  
A: 某些VPN使用特殊实现，可能无法被检测到。本插件已实现多种检测方法，覆盖大多数场景。

**Q: 可以实时监听VPN状态变化吗？**  
A: 当前版本不支持。你可以使用Timer定期调用 `isVpnActive()`。

**Q: 支持哪些VPN类型？**  
A: 支持大多数VPN类型，包括OpenVPN、WireGuard、PPTP、L2TP、IPSec等。

## 📞 获取帮助

- 查看 [README_CN.md](README_CN.md) 了解详细文档
- 查看 [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) 了解项目结构
- 提交问题到 GitHub Issues

## 🎉 开始使用

现在你已经准备好了！运行示例应用或在自己的项目中集成VPN检测功能吧！

```bash
cd example
flutter run
```

祝你使用愉快！ 🚀


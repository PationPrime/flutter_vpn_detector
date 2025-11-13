# 快速参考 (Quick Reference)

## 🚀 三步集成

```yaml
# 1️⃣ pubspec.yaml - 添加依赖
dependencies:
  vpn_checker: ^0.1.0
```

```dart
// 2️⃣ 导入包
import 'package:vpn_checker/vpn_checker.dart';
```

```dart
// 3️⃣ 使用
bool isVpnActive = await VpnChecker.isVpnActive();
```

## ✅ 配置要求

| 平台 | 额外配置 | 说明 |
|------|---------|------|
| 🤖 Android | ❌ 不需要 | 权限自动添加 |
| 🍎 iOS | ❌ 不需要 | 使用公开API |
| 💻 macOS | ❌ 不需要 | 使用公开API |
| 🪟 Windows | ❌ 不需要 | 自动链接库 |
| 🐧 Linux | ❌ 不需要 | 标准权限 |

**所有平台即插即用！🎉**

## 📱 平台要求

| 平台 | 最低版本 | 自动配置 |
|------|---------|---------|
| Android | API 21 (5.0) | ✅ |
| iOS | 12.0 | ✅ |
| macOS | 10.14 | ✅ |
| Windows | 10 | ✅ |
| Linux | Any modern | ✅ |

## 🎯 使用示例

### 基础用法

```dart
// 简单检查
bool isActive = await VpnChecker.isVpnActive();
print(isActive ? 'VPN已连接' : 'VPN未连接');
```

### 带UI的完整示例

```dart
class VpnCheckWidget extends StatefulWidget {
  @override
  _VpnCheckWidgetState createState() => _VpnCheckWidgetState();
}

class _VpnCheckWidgetState extends State<VpnCheckWidget> {
  bool? _isVpnActive;

  Future<void> _check() async {
    final result = await VpnChecker.isVpnActive();
    setState(() => _isVpnActive = result);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_isVpnActive == true ? 'VPN ✓' : 'No VPN ✗'),
        ElevatedButton(
          onPressed: _check,
          child: Text('检查'),
        ),
      ],
    );
  }
}
```

### 定期监控

```dart
Timer.periodic(Duration(seconds: 30), (timer) async {
  bool isVpnActive = await VpnChecker.isVpnActive();
  if (isVpnActive) {
    // VPN已连接，执行相应逻辑
  }
});
```

## 🔍 可检测的VPN类型

✅ OpenVPN  
✅ WireGuard  
✅ IPSec  
✅ PPTP/L2TP  
✅ iOS系统VPN  
✅ HTTP/HTTPS代理  
✅ SOCKS代理  
✅ 企业VPN  

## 📊 性能

- **响应时间**: 1-5ms
- **CPU占用**: 极低
- **内存占用**: < 1MB
- **电池影响**: 可忽略

## 🔧 故障排查

### Android编译错误

```bash
flutter clean
flutter pub get
flutter run
```

### iOS/macOS编译错误

```bash
cd ios  # 或 cd macos
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### 检测不准确

1. 确保在真实设备上测试
2. 连接/断开VPN后重新检查
3. 查看平台日志：`flutter logs`

## 📚 文档链接

- [README_CN.md](README_CN.md) - 完整中文文档
- [README.md](README.md) - 完整英文文档
- [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) - 详细集成指南
- [QUICKSTART_CN.md](QUICKSTART_CN.md) - 快速开始指南
- [IOS_IMPLEMENTATION_COMPARISON.md](IOS_IMPLEMENTATION_COMPARISON.md) - iOS实现对比

## ⚡ 最佳实践

### ✅ 推荐

```dart
// 按需检查
void onButtonPress() async {
  bool result = await VpnChecker.isVpnActive();
}

// 合理的定期检查（30秒或更长）
Timer.periodic(Duration(seconds: 30), checkVpn);

// 应用启动时检查一次
@override
void initState() {
  super.initState();
  VpnChecker.isVpnActive().then((result) {
    // 处理结果
  });
}
```

### ❌ 不推荐

```dart
// 不要过于频繁检查
Timer.periodic(Duration(milliseconds: 100), checkVpn); // ❌ 太频繁

// 不要阻塞主线程
bool result = VpnChecker.isVpnActive(); // ❌ 缺少 await
```

## 🎯 常见问题

**Q: 需要申请权限吗？**  
A: 不需要，所有权限自动处理。

**Q: 支持模拟器吗？**  
A: 支持，但建议在真实设备上测试。

**Q: 能检测所有VPN吗？**  
A: 能检测大多数常见VPN，但某些特殊实现可能检测不到。

**Q: 影响性能吗？**  
A: 几乎没有影响，调用非常轻量级。

**Q: 需要网络权限吗？**  
A: Android会自动添加 `ACCESS_NETWORK_STATE`，其他平台不需要。

## 💡 提示

1. ✅ 所有平台无需手动配置
2. ✅ 添加依赖后立即可用
3. ✅ 使用 async/await 调用
4. ✅ 建议在真实设备上测试
5. ✅ 定期检查间隔建议 ≥ 30秒

## 📞 获取帮助

- 📖 查看详细文档
- 🐛 提交 GitHub Issue
- 💬 查看示例应用：`example/`

---

**开始使用只需3步，无需任何配置！** 🚀


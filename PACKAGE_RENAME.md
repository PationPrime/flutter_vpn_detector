# 包名更改说明

## 📌 重要通知

由于 `vpn_checker` 包名在 pub.dev 已被占用，插件已更名为 **`flutter_vpn_detector`**。

## 🔄 更改内容

| 项目 | 旧名称 | 新名称 |
|------|-------|--------|
| **包名** | `vpn_checker` | `flutter_vpn_detector` |
| **导入路径** | `package:vpn_checker/vpn_checker.dart` | `package:flutter_vpn_detector/vpn_checker.dart` |
| **Android包** | `com.tikoua.vpn_checker` | `com.tikoua.flutter_vpn_detector` |
| **Android类** | `VpnCheckerPlugin` | `FlutterVpnDetectorPlugin` |
| **iOS/macOS类** | `VpnCheckerPlugin` | `FlutterVpnDetectorPlugin` |
| **Method Channel** | `vpn_checker` | `flutter_vpn_detector` |
| **GitHub** | `/vpn_checker` | `/flutter_vpn_detector` |

## ✅ 使用新包名

### 安装

```yaml
dependencies:
  flutter_vpn_detector: ^0.1.0
```

### 导入

```dart
import 'package:flutter_vpn_detector/vpn_checker.dart';
```

### 使用（API不变）

```dart
bool isVpnActive = await VpnChecker.isVpnActive();
```

## 📝 注意事项

- ✅ **API完全相同**：只需更改导入语句
- ✅ **功能不变**：所有功能保持不变
- ✅ **平台支持不变**：仍支持所有5个平台

## 🚀 迁移指南

如果你之前测试过 `vpn_checker`（本地版本），迁移步骤：

### 1. 更新 pubspec.yaml

```yaml
# 旧的
dependencies:
  vpn_checker: ^0.1.0

# 新的
dependencies:
  flutter_vpn_detector: ^0.1.0
```

### 2. 更新导入语句

```dart
// 旧的
import 'package:vpn_checker/vpn_checker.dart';

// 新的
import 'package:flutter_vpn_detector/vpn_checker.dart';
```

### 3. 运行命令

```bash
flutter clean
flutter pub get
```

## 💡 为什么改名？

1. **pub.dev已占用**：`vpn_checker` 包名已被其他开发者注册
2. **更专业的命名**：`flutter_vpn_detector` 使用 "detector"（检测器）比 "checker"（检查器）更专业
3. **简洁明了**：语义更清晰，更符合Flutter插件命名规范
4. **避免冲突**：遵循Flutter插件命名最佳实践

## 📦 pub.dev链接

- **新包**: https://pub.dev/packages/flutter_vpn_detector
- **GitHub**: https://github.com/tikoua/flutter_vpn_detector

---

**感谢理解！新包名将给你带来更好的使用体验。** 🎉


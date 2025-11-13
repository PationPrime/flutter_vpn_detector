# 发布前检查清单

## ✅ 包名已更改

- ✅ 包名从 `vpn_checker` 改为 **`flutter_vpn_checker`**
- ✅ 所有文件已更新完毕

## 📝 已更新的文件（共30+个文件）

### 核心配置
- ✅ `pubspec.yaml` - 包名、Android包名、类名
- ✅ `android/build.gradle` - Android包名和namespace
- ✅ `android/settings.gradle` - 项目名
- ✅ `android/.../FlutterVpnCheckerPlugin.kt` - 新的Android实现类
- ✅ `ios/Classes/VpnCheckerPlugin.swift` - iOS类名和channel
- ✅ `ios/vpn_checker.podspec` - Podspec名称
- ✅ `macos/Classes/VpnCheckerPlugin.swift` - macOS类名和channel  
- ✅ `macos/vpn_checker.podspec` - Podspec名称
- ✅ `lib/vpn_checker_method_channel.dart` - Method Channel名称

### 示例应用
- ✅ `example/pubspec.yaml` - 依赖更新
- ✅ `example/lib/main.dart` - 导入语句更新

### 文档
- ✅ `README.md` - 英文文档
- ✅ `README_CN.md` - 中文文档
- ✅ `PACKAGE_RENAME.md` - 包名更改说明（新建）
- ✅ `PUBLISH_CHECKLIST.md` - 本文件（新建）

## 🚀 发布步骤

### 1. 清理并测试

```bash
# 清理旧的构建文件
flutter clean

# 获取依赖
flutter pub get

# 运行测试
flutter test

# 代码分析
flutter analyze
```

### 2. 测试示例应用（可选但推荐）

```bash
cd example
flutter pub get

# 在各平台测试
flutter run -d android
flutter run -d ios
flutter run -d macos
```

### 3. 预发布检查

```bash
# 回到项目根目录
cd ..

# 运行pub发布预检查
flutter pub publish --dry-run
```

**确认输出无错误！**

### 4. 正式发布

```bash
# 登录pub.dev（如果还未登录）
flutter pub login

# 发布包
flutter pub publish
```

### 5. 发布后验证

- 访问 https://pub.dev/packages/flutter_vpn_checker
- 确认包信息正确
- 确认文档显示正常
- 确认示例代码正确

## ⚠️ 重要提示

### GitHub仓库

如果你使用GitHub，请：
1. 更新仓库名称为 `flutter_vpn_checker`
2. 或更新 `pubspec.yaml` 中的 `homepage` 字段为实际的GitHub URL

### 首次发布

如果这是首次发布到pub.dev：
- 需要验证邮箱
- 需要确认发布条款
- 首次发布会要求人工审核

### 版本号

当前版本：`0.1.0`
- 首次发布建议使用 `0.1.0`
- 后续更新根据变更类型递增版本号

## 📋 发布命令速查

```bash
# 一键发布流程
flutter clean && \
flutter pub get && \
flutter analyze && \
flutter test && \
flutter pub publish --dry-run

# 如果预检查通过，执行发布
flutter pub publish
```

## 🎯 预期结果

发布成功后，用户可以通过以下方式使用你的插件：

```yaml
dependencies:
  flutter_vpn_checker: ^0.1.0
```

```dart
import 'package:flutter_vpn_checker/vpn_checker.dart';

bool isActive = await VpnChecker.isVpnActive();
```

## 💡 常见问题

### Q: 发布失败怎么办？
A: 查看错误信息，通常是：
- 包名冲突（已解决）
- 缺少必要字段（已完成）
- 格式错误（运行 `flutter pub publish --dry-run` 检查）

### Q: 如何更新已发布的包？
A: 
1. 修改代码
2. 更新 `CHANGELOG.md`
3. 递增 `pubspec.yaml` 中的版本号
4. 运行 `flutter pub publish`

### Q: 包名还是被占用怎么办？
A: 如果 `flutter_vpn_checker` 也被占用，可以尝试：
- `vpn_connection_checker`
- `device_vpn_checker`
- `vpn_detector`
- `network_vpn_checker`

## ✨ 完成！

所有文件已准备就绪，你现在可以发布了！

**祝发布顺利！🎉**


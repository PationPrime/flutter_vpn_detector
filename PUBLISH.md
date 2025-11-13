# 发布指南 (Publishing Guide)

本文档说明如何将 `vpn_checker` 插件发布到 pub.dev。

## 发布前检查清单

### 1. 确保所有文件完整

- [x] `pubspec.yaml` - 包含正确的版本号和依赖
- [x] `README.md` - 详细的使用说明
- [x] `CHANGELOG.md` - 版本更新日志
- [x] `LICENSE` - MIT 许可证
- [x] `lib/` - Dart API 代码
- [x] `android/` - Android 平台实现
- [x] `ios/` - iOS 平台实现
- [x] `macos/` - macOS 平台实现
- [x] `windows/` - Windows 平台实现
- [x] `linux/` - Linux 平台实现
- [x] `example/` - 示例应用

### 2. 运行测试

```bash
# 分析代码
flutter analyze

# 运行测试（如果有）
flutter test

# 检查发布前的问题
flutter pub publish --dry-run
```

### 3. 更新版本号

在 `pubspec.yaml` 中更新版本号，并在 `CHANGELOG.md` 中添加更新内容。

### 4. 测试各平台

确保在以下平台测试过插件：

```bash
# Android
cd example
flutter run -d android

# iOS（需要 macOS）
flutter run -d ios

# macOS
flutter run -d macos

# Windows（需要 Windows）
flutter run -d windows

# Linux（需要 Linux）
flutter run -d linux
```

### 5. 发布到 pub.dev

```bash
# 登录 pub.dev（如果还未登录）
flutter pub login

# 发布包
flutter pub publish
```

按照提示完成发布流程。

## 发布后

1. 在 GitHub 上创建对应版本的 Release
2. 在 pub.dev 上查看包页面，确认信息正确
3. 更新 README 中的版本号示例
4. 向社区宣传你的包！

## 版本号规范

遵循语义化版本（Semantic Versioning）：

- **主版本号（Major）**: 不兼容的 API 修改
- **次版本号（Minor）**: 向下兼容的功能性新增
- **修订号（Patch）**: 向下兼容的问题修正

示例：
- `0.1.0` - 初始版本
- `0.1.1` - Bug 修复
- `0.2.0` - 新功能
- `1.0.0` - 稳定版本

## 常见问题

### Q: 发布失败，提示包名已存在
A: 检查 pub.dev 上是否已有同名包，如需要更改包名，修改 `pubspec.yaml` 中的 `name` 字段。

### Q: 发布后发现问题怎么办？
A: 立即发布一个修复版本，不能撤销已发布的版本。

### Q: 如何更新包？
A: 修改代码后，更新版本号，再次运行 `flutter pub publish`。

## 参考链接

- [Pub.dev 发布文档](https://dart.dev/tools/pub/publishing)
- [Flutter 插件开发](https://flutter.dev/docs/development/packages-and-plugins/developing-packages)
- [语义化版本](https://semver.org/)


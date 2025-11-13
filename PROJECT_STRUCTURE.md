# 项目结构说明

## 目录结构

```
vpn_checker/
├── lib/                                    # Dart代码
│   ├── vpn_checker.dart                   # 主API入口
│   ├── vpn_checker_platform_interface.dart # 平台接口定义
│   └── vpn_checker_method_channel.dart    # Method Channel实现
│
├── android/                                # Android平台实现
│   ├── build.gradle                       # Android构建配置
│   ├── settings.gradle                    # Android设置
│   ├── gradle.properties                  # Gradle属性
│   └── src/main/
│       ├── AndroidManifest.xml           # Android权限配置
│       └── kotlin/com/tikoua/vpn_checker/
│           └── VpnCheckerPlugin.kt       # Android VPN检测实现
│
├── ios/                                   # iOS平台实现
│   ├── vpn_checker.podspec               # iOS CocoaPods配置
│   └── Classes/
│       └── VpnCheckerPlugin.swift        # iOS VPN检测实现
│
├── macos/                                 # macOS平台实现
│   ├── vpn_checker.podspec               # macOS CocoaPods配置
│   └── Classes/
│       └── VpnCheckerPlugin.swift        # macOS VPN检测实现
│
├── windows/                               # Windows平台实现
│   ├── CMakeLists.txt                    # Windows构建配置
│   ├── vpn_checker_plugin.cpp            # Windows VPN检测实现
│   └── include/vpn_checker/
│       └── vpn_checker_plugin.h          # Windows头文件
│
├── linux/                                 # Linux平台实现
│   ├── CMakeLists.txt                    # Linux构建配置
│   ├── vpn_checker_plugin.cc             # Linux VPN检测实现
│   └── include/vpn_checker/
│       └── vpn_checker_plugin.h          # Linux头文件
│
├── test/                                  # 单元测试
│   ├── vpn_checker_test.dart            # 主测试文件
│   └── vpn_checker_method_channel_test.dart # Method Channel测试
│
├── example/                               # 示例应用
│   ├── lib/
│   │   └── main.dart                     # 示例应用主文件
│   ├── pubspec.yaml                      # 示例应用依赖
│   └── README.md                         # 示例应用说明
│
├── pubspec.yaml                          # 插件依赖配置
├── README.md                             # 英文说明文档
├── README_CN.md                          # 中文说明文档
├── CHANGELOG.md                          # 更新日志
├── LICENSE                               # MIT许可证
├── PUBLISH.md                            # 发布指南
├── analysis_options.yaml                 # 代码分析配置
└── .gitignore                            # Git忽略配置
```

## 核心文件说明

### Dart层（lib/）

#### vpn_checker.dart
- 插件的主要公共API
- 提供 `VpnChecker.isVpnActive()` 方法
- 用户直接调用的接口

#### vpn_checker_platform_interface.dart
- 定义平台接口规范
- 使用 `plugin_platform_interface` 包确保类型安全
- 所有平台实现必须遵循此接口

#### vpn_checker_method_channel.dart
- 实现Method Channel通信
- 处理Dart与原生平台的消息传递
- 包含错误处理逻辑

### Android平台（android/）

#### VpnCheckerPlugin.kt
实现三种VPN检测方法：
1. **ConnectivityManager检测** (API 23+)
   - 检查 `TRANSPORT_VPN` 传输类型
   - 检查 `NET_CAPABILITY_NOT_VPN` 能力

2. **网络接口检测**
   - 检查接口名称（tun、tap、ppp等）
   - 验证接口是否处于UP状态
   - 排除回环接口

3. **路由表检测**
   - 读取 `/proc/net/route` 文件
   - 查找VPN相关路由条目

### iOS平台（ios/）

#### VpnCheckerPlugin.swift
实现四种检测方法：
1. **代理设置检测**
   - 使用 `CFNetworkCopySystemProxySettings`
   - 检查代理类型

2. **网络可达性检测**
   - 使用 `SCNetworkReachability`

3. **代理配置检测**
   - 检查HTTP/HTTPS代理是否启用
   - 检查代理主机和端口

4. **VPN接口检测**
   - 检查 `__SCOPED__` 网络设置
   - 查找tap、tun、ppp、ipsec、utun接口

### macOS平台（macos/）

#### VpnCheckerPlugin.swift
- 实现与iOS相同的检测逻辑
- 使用相同的系统API
- 支持macOS特定的网络配置

### Windows平台（windows/）

#### vpn_checker_plugin.cpp
实现两种检测方法：
1. **网络适配器检测**
   - 使用 `GetAdaptersAddresses` API
   - 检查适配器描述和名称
   - 识别隧道接口（IF_TYPE_TUNNEL）

2. **接口描述检测**
   - 使用 `GetInterfaceInfo` API
   - 检查接口名称中的VPN关键字

### Linux平台（linux/）

#### vpn_checker_plugin.cc
实现两种检测方法：
1. **网络接口检测**
   - 读取 `/proc/net/dev` 文件
   - 解析接口名称
   - 检查接口流量

2. **路由表检测**
   - 读取 `/proc/net/route` 文件
   - 查找VPN相关路由

## 使用流程

```
用户调用
    ↓
VpnChecker.isVpnActive()
    ↓
VpnCheckerPlatform.instance.isVpnActive()
    ↓
MethodChannelVpnChecker.isVpnActive()
    ↓
Method Channel ("vpn_checker")
    ↓
原生平台实现 (Android/iOS/macOS/Windows/Linux)
    ↓
返回 bool 结果
```

## 测试

### 运行单元测试
```bash
flutter test
```

### 运行示例应用
```bash
cd example
flutter run -d <platform>
```

### 代码分析
```bash
flutter analyze
```

## 发布前检查

1. 更新版本号（pubspec.yaml）
2. 更新更新日志（CHANGELOG.md）
3. 运行所有测试
4. 在所有平台测试
5. 运行 `flutter pub publish --dry-run`
6. 执行 `flutter pub publish`

## 开发建议

### 添加新功能
1. 在 `vpn_checker_platform_interface.dart` 中定义接口
2. 在 `vpn_checker_method_channel.dart` 中实现Method Channel调用
3. 在各平台原生代码中实现具体逻辑
4. 在 `vpn_checker.dart` 中暴露公共API
5. 添加测试用例
6. 更新文档

### 修复Bug
1. 定位问题所在平台
2. 修改对应平台的原生代码
3. 测试修复效果
4. 更新版本号和更新日志

## 技术栈

- **Dart/Flutter**: 3.0+
- **Kotlin**: Android实现
- **Swift**: iOS/macOS实现
- **C++**: Windows/Linux实现
- **Android API**: 21+
- **iOS**: 12.0+
- **macOS**: 10.14+

## 依赖包

- `flutter`: SDK
- `plugin_platform_interface`: ^2.1.0（平台接口）
- `flutter_lints`: ^3.0.0（代码规范）

## 许可证

MIT License - 允许商业和个人使用


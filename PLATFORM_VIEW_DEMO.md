# PlatformView 演示 - 嵌入原生进度条

本示例展示如何使用 PlatformView 将原生 Android/iOS 组件嵌入到 Flutter 应用中。

## 功能说明

- 在 Flutter 页面中嵌入原生进度条（ProgressBar/UIProgressView）
- 通过 MethodChannel 从 Dart 控制原生组件的进度
- 展示 Flutter 与原生平台的混合开发能力

## 文件结构

### Dart 端
- `lib/widget/platform_view_demo_page.dart` - Flutter 页面，使用 AndroidView/UiKitView

### Android 端
- `android/app/src/main/kotlin/.../MainActivity.kt` - 注册 PlatformView
- `android/app/src/main/kotlin/.../NativeProgressBar.kt` - 原生进度条实现

### iOS 端
- `ios/Runner/AppDelegate.swift` - 注册 PlatformView
- `ios/Runner/NativeProgressBar.swift` - 原生进度条实现

## 核心概念

### 1. PlatformView 注册

**Android:**
```kotlin
flutterEngine
    .platformViewsController
    .registry
    .registerViewFactory("native-progress-bar", NativeProgressBarFactory())
```

**iOS:**
```swift
let factory = NativeProgressBarFactory(messenger: registrar.messenger())
registrar.register(factory, withId: "native-progress-bar")
```

### 2. Flutter 端使用

```dart
// Android
AndroidView(
  viewType: 'native-progress-bar',
  creationParams: {'progress': 0.5},
  creationParamsCodec: const StandardMessageCodec(),
)

// iOS
UiKitView(
  viewType: 'native-progress-bar',
  creationParams: {'progress': 0.5},
  creationParamsCodec: const StandardMessageCodec(),
)
```

### 3. 通过 MethodChannel 通信

```dart
// Dart 调用原生方法更新进度
await platform.invokeMethod('updateProgress', {'progress': 0.8});
```

## 使用场景

1. **复用原生组件** - 当 Flutter 没有提供某个特定原生组件时
2. **性能优化** - 某些场景下原生组件性能更好
3. **集成现有代码** - 集成已有的原生 UI 库
4. **平台特性** - 使用平台专属的 UI 特性

## 注意事项

1. PlatformView 有一定的性能开销，不要过度使用
2. 在 Android 上建议使用 Hybrid Composition 模式（Flutter 3.0+）
3. 需要分别为 Android 和 iOS 实现原生代码
4. 调试时注意查看原生端的日志

## 运行

```bash
# 在 Android 设备上运行
flutter run -d <device-id>

# 在 iOS 设备/模拟器上运行
flutter run -d <device-id>
```

在应用中找到 "PlatformView 嵌入原生进度条" 条目即可查看演示。


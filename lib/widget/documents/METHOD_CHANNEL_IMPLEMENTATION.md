# MethodChannel 平台端实现说明

本文档说明了 Flutter MethodChannel 在 Android 和 iOS 平台的实现细节。

## 概述

MethodChannel 是 Flutter 与原生平台通信的桥梁，支持：
- 异步方法调用
- 双向通信（Flutter ↔ Native）
- 类型安全的数据传递
- 错误处理

## Channel 名称
```
com.example.demo/method_channel
```
**注意：** Flutter 端和原生端的 Channel 名称必须完全一致。

---

## Android 端实现

### 文件位置
`android/app/src/main/kotlin/com/gsy/shuyu/gsy_flutter_demo/MainActivity.kt`

### 实现要点

#### 1. 创建 MethodChannel
```kotlin
private val CHANNEL = "com.example.demo/method_channel"
private var methodChannel: MethodChannel? = null

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
}
```

#### 2. 处理 Flutter 调用
```kotlin
methodChannel?.setMethodCallHandler { call, result ->
    when (call.method) {
        "getBatteryLevel" -> {
            // 处理获取电量请求
            val batteryLevel = getBatteryLevel()
            result.success(batteryLevel)
        }
        else -> result.notImplemented()
    }
}
```

#### 3. 主动调用 Flutter 方法
```kotlin
methodChannel?.invokeMethod("onPlatformCallback", "消息内容")
```

#### 4. 获取电池电量实现
使用 Android BatteryManager API：
```kotlin
private fun getBatteryLevel(): Int {
    val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
}
```

#### 5. 清理资源
```kotlin
override fun onDestroy() {
    super.onDestroy()
    methodChannel?.setMethodCallHandler(null)
}
```

### 支持的方法

| 方法名 | 参数 | 返回值 | 说明 |
|--------|------|--------|------|
| `getBatteryLevel` | 无 | Int | 获取电池电量百分比 |
| `getPlatformVersion` | 无 | String | 获取 Android 版本信息 |
| `sendData` | Map<String, Any> | String | 接收并处理数据 |

---

## iOS 端实现

### 文件位置
`ios/Runner/AppDelegate.swift`

### 实现要点

#### 1. 创建 MethodChannel
```swift
private var methodChannel: FlutterMethodChannel?

override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
) -> Bool {
  guard let controller = window?.rootViewController as? FlutterViewController else {
    fatalError("rootViewController is not type FlutterViewController")
  }
  
  let channelName = "com.example.demo/method_channel"
  methodChannel = FlutterMethodChannel(name: channelName,
                                       binaryMessenger: controller.binaryMessenger)
}
```

#### 2. 处理 Flutter 调用
```swift
methodChannel?.setMethodCallHandler({ [weak self]
  (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
  
  switch call.method {
  case "getBatteryLevel":
    self?.receiveBatteryLevel(result: result)
  default:
    result(FlutterMethodNotImplemented)
  }
})
```

#### 3. 主动调用 Flutter 方法
```swift
methodChannel?.invokeMethod("onPlatformCallback", arguments: "消息内容")
```

#### 4. 获取电池电量实现
使用 iOS UIDevice API：
```swift
private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  
  if device.batteryState == .unknown {
    result(FlutterError(code: "UNAVAILABLE",
                       message: "Battery level not available.",
                       details: nil))
  } else {
    let batteryLevel = Int(device.batteryLevel * 100)
    result(batteryLevel)
  }
}
```

### 支持的方法

| 方法名 | 参数 | 返回值 | 说明 |
|--------|------|--------|------|
| `getBatteryLevel` | 无 | Int | 获取电池电量百分比 |
| `getPlatformVersion` | 无 | String | 获取 iOS 版本信息 |
| `sendData` | [String: Any] | String | 接收并处理数据 |

---

## 数据传递

### Flutter → Native
支持的数据类型：
- `null`
- `bool`
- `int`
- `double`
- `String`
- `List`
- `Map`

### Native → Flutter
- Android: 使用 Kotlin 基本类型
- iOS: 使用 Swift 基本类型

### 示例：传递复杂数据

**Flutter 端：**
```dart
final result = await platform.invokeMethod('sendData', {
  'name': 'Flutter',
  'value': 42,
  'timestamp': DateTime.now().millisecondsSinceEpoch,
});
```

**Android 端：**
```kotlin
val data = call.arguments as? Map<String, Any>
val name = data["name"] as? String
val value = data["value"] as? Int
val timestamp = data["timestamp"] as? Long
```

**iOS 端：**
```swift
guard let args = call.arguments as? [String: Any] else { return }
let name = args["name"] as? String ?? "unknown"
let value = args["value"] as? Int ?? 0
let timestamp = args["timestamp"] as? Int64 ?? 0
```

---

## 错误处理

### Flutter 端
```dart
try {
  final result = await platform.invokeMethod('methodName');
} on PlatformException catch (e) {
  print("Error: ${e.message}");
}
```

### Android 端
```kotlin
result.error("ERROR_CODE", "Error message", additionalDetails)
```

### iOS 端
```swift
result(FlutterError(code: "ERROR_CODE",
                   message: "Error message",
                   details: nil))
```

---

## 测试方法

### 1. 运行应用
```bash
flutter run
```

### 2. 测试功能
在 MethodChannel 演示页面中：
1. 点击"获取电量"按钮 → 应显示当前设备电量
2. 点击"获取版本"按钮 → 应显示平台版本信息
3. 点击"发送数据"按钮 → 应显示平台响应消息

### 3. 查看日志
**Android:**
```bash
adb logcat | grep Flutter
```

**iOS:**
在 Xcode 中查看控制台输出

---

## 常见问题

### 1. Channel 名称不匹配
**错误：** `MissingPluginException`
**解决：** 确保 Flutter、Android、iOS 三端的 Channel 名称完全一致

### 2. 方法未实现
**错误：** `PlatformException`
**解决：** 在原生端实现对应的方法处理逻辑

### 3. 数据类型转换失败
**错误：** 类型转换异常
**解决：** 
- 使用安全类型转换（`as?` in Kotlin/Swift）
- 提供默认值
- 检查数据格式

### 4. 生命周期问题
**Android:** 在 `onDestroy()` 中清理 MethodChannel
**iOS:** 使用 `[weak self]` 避免循环引用

---

## 最佳实践

### 1. 单一职责
每个 Channel 负责一类功能，不要把所有方法都放在一个 Channel 中。

### 2. 错误处理
总是提供清晰的错误信息，帮助调试。

### 3. 异步处理
原生端的耗时操作应在后台线程执行，避免阻塞 UI。

### 4. 类型安全
使用强类型，避免直接类型转换。

### 5. 文档注释
为每个方法添加清晰的注释说明。

---

## 扩展阅读

- [Flutter Platform Channels](https://docs.flutter.dev/development/platform-integration/platform-channels)
- [Writing custom platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels)
- [MethodChannel API Reference](https://api.flutter.dev/flutter/services/MethodChannel-class.html)

---

## 更新记录

- 2025-11-25: 初始版本，实现基本的 MethodChannel 通信功能


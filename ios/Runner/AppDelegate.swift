import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var methodChannel: FlutterMethodChannel?
  private var progressChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    // 获取 FlutterViewController
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }

    // 注册 PlatformView
    let registrar = self.registrar(forPlugin: "NativeProgressBar")!
    let factory = NativeProgressBarFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "native-progress-bar")

    // 创建 MethodChannel
    let channelName = "com.example.demo/method_channel"
    methodChannel = FlutterMethodChannel(name: channelName,
                                         binaryMessenger: controller.binaryMessenger)

    // 创建进度条控制 MethodChannel
    let progressChannelName = "com.example.platform_view/progress"
    progressChannel = FlutterMethodChannel(name: progressChannelName,
                                          binaryMessenger: controller.binaryMessenger)

    progressChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "updateProgress" {
        if let args = call.arguments as? [String: Any],
           let progress = args["progress"] as? Double {
          NativeProgressBarFactory.updateProgress(Float(progress))
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT",
                            message: "Invalid progress value",
                            details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    // 设置方法调用处理器
    methodChannel?.setMethodCallHandler({ [weak self]
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

      switch call.method {
      case "getBatteryLevel":
        self?.receiveBatteryLevel(result: result)

      case "getPlatformVersion":
        self?.getPlatformVersion(result: result)

      case "sendData":
        self?.handleSendData(call: call, result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// 获取电池电量
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

  /// 获取平台版本
  private func getPlatformVersion(result: FlutterResult) {
    let systemVersion = UIDevice.current.systemVersion
    let model = UIDevice.current.model
    let version = "iOS \(systemVersion) (\(model))"
    result(version)
  }

  /// 处理发送的数据
  private func handleSendData(call: FlutterMethodCall, result: FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "INVALID_ARGUMENT",
                         message: "Invalid data format",
                         details: nil))
      return
    }

    let name = args["name"] as? String ?? "unknown"
    let value = args["value"] as? Int ?? 0
    let timestamp = args["timestamp"] as? Int64 ?? 0

    // 处理数据
    let response = "Received: name=\(name), value=\(value), timestamp=\(timestamp)"

    // 可以主动调用 Flutter 的方法
    methodChannel?.invokeMethod("onPlatformCallback",
                               arguments: "iOS processed your data")

    result(response)
  }
}

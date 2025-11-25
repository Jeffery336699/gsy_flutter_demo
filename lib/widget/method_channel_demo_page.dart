import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// MethodChannel 平台通信演示
/// 演示 Flutter 与原生平台通信的基本用法
class MethodChannelDemoPage extends StatefulWidget {
  const MethodChannelDemoPage({super.key});

  @override
  State<MethodChannelDemoPage> createState() => _MethodChannelDemoPageState();
}

class _MethodChannelDemoPageState extends State<MethodChannelDemoPage> {
  static const platform = MethodChannel('com.example.demo/method_channel');

  String _batteryLevel = 'Unknown';
  String _platformVersion = 'Unknown';
  String _platformMessage = 'Unknown';

  @override
  void initState() {
    super.initState();
    _setupMethodCallHandler();
  }

  /// 设置接收原生平台的方法调用
  void _setupMethodCallHandler() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onPlatformCallback') {
        setState(() {
          _platformMessage = call.arguments as String;
        });
        return 'Flutter received: ${call.arguments}';
      }
      throw PlatformException(
        code: 'Unimplemented',
        details: 'Method ${call.method} not implemented',
      );
    });
  }

  /// 获取电池电量（示例方法）
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    } catch (e) {
      batteryLevel = 'Error: $e';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  /// 获取平台版本
  Future<void> _getPlatformVersion() async {
    String platformVersion;
    try {
      final String result = await platform.invokeMethod('getPlatformVersion');
      platformVersion = 'Platform: $result';
    } on PlatformException catch (e) {
      platformVersion = "Failed to get platform version: '${e.message}'.";
    } catch (e) {
      platformVersion = 'Platform version is not implemented in native code.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  /// 发送数据到原生平台
  Future<void> _sendDataToPlatform() async {
    try {
      final result = await platform.invokeMethod('sendData', {
        'name': 'Flutter',
        'value': 42,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Platform response: $result')),
        );
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Method not implemented: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MethodChannel 演示'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 说明卡片
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'MethodChannel 简介',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'MethodChannel 用于 Flutter 与原生平台之间的方法调用通信。'
                      '\n\n特点：'
                      '\n• 异步方法调用'
                      '\n• 支持双向通信'
                      '\n• 类型安全的数据传递'
                      '\n• 支持错误处理',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 电池电量示例
            _buildDemoCard(
              title: '获取电池电量',
              description: '调用原生方法获取设备电池电量',
              result: _batteryLevel,
              onPressed: _getBatteryLevel,
              buttonText: '获取电量',
              icon: Icons.battery_full,
            ),

            const SizedBox(height: 16),

            // 平台版本示例
            _buildDemoCard(
              title: '获取平台版本',
              description: '获取 Android/iOS 平台版本信息',
              result: _platformVersion,
              onPressed: _getPlatformVersion,
              buttonText: '获取版本',
              icon: Icons.phone_android,
            ),

            const SizedBox(height: 16),

            // 发送数据示例
            _buildDemoCard(
              title: '发送数据到平台',
              description: '发送 Map 数据到原生平台',
              result: _platformMessage,
              onPressed: _sendDataToPlatform,
              buttonText: '发送数据',
              icon: Icons.send,
            ),

            const SizedBox(height: 20),

            // 代码示例
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '代码示例',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '// 创建 MethodChannel\n'
                        'static const platform = MethodChannel(\n'
                        '  \'com.example.demo/method_channel\'\n'
                        ');\n\n'
                        '// 调用原生方法\n'
                        'final result = await platform\n'
                        '  .invokeMethod(\'methodName\', args);\n\n'
                        '// 接收原生调用\n'
                        'platform.setMethodCallHandler((call) async {\n'
                        '  if (call.method == \'onCallback\') {\n'
                        '    // 处理回调\n'
                        '  }\n'
                        '});',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 注意事项
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          '注意事项',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• 本示例的原生方法未实现，实际调用会失败\n'
                      '• 需要在 Android 和 iOS 原生代码中实现对应方法\n'
                      '• Channel 名称必须在 Flutter 和原生端保持一致\n'
                      '• 支持的数据类型：null, bool, int, double, String, List, Map',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard({
    required String title,
    required String description,
    required String result,
    required VoidCallback onPressed,
    required String buttonText,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


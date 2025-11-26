import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// PlatformView 演示页面 - 嵌入原生进度条
class PlatformViewDemoPage extends StatefulWidget {
  const PlatformViewDemoPage({super.key});

  @override
  State<PlatformViewDemoPage> createState() => _PlatformViewDemoPageState();
}

class _PlatformViewDemoPageState extends State<PlatformViewDemoPage> {
  static const platform = MethodChannel('com.example.platform_view/progress');
  double _progress = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PlatformView 原生进度条"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '原生进度条示例',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 嵌入原生进度条
          SizedBox(
            height: 100,
            child: _buildNativeProgressBar(),
          ),

          const SizedBox(height: 30),

          // Flutter 进度条作为对比
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const Text('Flutter 进度条（对比）'),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 进度值显示
          Text(
            '进度: ${(_progress * 100).toInt()}%',
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // 控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _progress > 0 ? () => _updateProgress(-0.1) : null,
                child: const Text('减少'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _progress < 1 ? () => _updateProgress(0.1) : null,
                child: const Text('增加'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNativeProgressBar() {
    // Android 平台使用 AndroidView
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'native-progress-bar',
        creationParams: {'progress': _progress},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          debugPrint('PlatformView created with id: $id');
        },
      );
    }
    // iOS 平台使用 UiKitView
    else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'native-progress-bar',
        creationParams: {'progress': _progress},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          debugPrint('PlatformView created with id: $id');
        },
      );
    }
    // 其他平台降级为 Flutter 组件
    else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('当前平台不支持 PlatformView'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 8,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _updateProgress(double delta) {
    setState(() {
      _progress = (_progress + delta).clamp(0.0, 1.0);
      _sendProgressToNative();
    });
  }

  Future<void> _sendProgressToNative() async {
    try {
      await platform.invokeMethod('updateProgress', {'progress': _progress});
    } on PlatformException catch (e) {
      debugPrint('Failed to update progress: ${e.message}');
    }
  }
}


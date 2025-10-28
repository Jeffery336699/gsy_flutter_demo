import 'dart:ui';

import 'package:flutter/material.dart';

class AppLifecycleListenerDemoPage extends StatefulWidget {
  const AppLifecycleListenerDemoPage({super.key});

  @override
  State<AppLifecycleListenerDemoPage> createState() =>
      _AppLifecycleListenerDemoPageState();
}

class _AppLifecycleListenerDemoPageState
    extends State<AppLifecycleListenerDemoPage> {
  final List<String> _logs = [];
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _addLog('页面初始化');

    _lifecycleListener = AppLifecycleListener(
      onShow: () => _addLog('onShow: 应用从隐藏变为可见'),
      onResume: () => _addLog('onResume: 应用恢复（从后台回到前台）'),
      onHide: () => _addLog('onHide: 应用被隐藏'),
      onInactive: () => _addLog('onInactive: 应用处于非活动状态'),
      onPause: () => _addLog('onPause: 应用暂停（进入后台）'),
      onDetach: () => _addLog('onDetach: 应用分离'),
      onRestart: () => _addLog('onRestart: 应用重启'),
      // onStateChange: (state) => _addLog('onStateChange: 状态变更为 $state'),
      onExitRequested: () async {
        _addLog('onExitRequested: 应用请求退出');
        // 返回 AppExitResponse.exit 允许退出
        // 返回 AppExitResponse.cancel 取消退出
        return AppExitResponse.exit;
      },
    );
  }

  void _addLog(String log) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toString().substring(11, 19)} - $log');
    });
    print(log);
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppLifecycleListener Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearLogs,
            tooltip: '清空日志',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '操作说明：',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text('1. 点击 Home 键将应用切到后台，观察 onPause 回调'),
                Text('2. 重新打开应用，观察 onResume 回调'),
                Text('3. 下拉通知栏，观察 onInactive 回调'),
                Text('4. 在 Android 最近任务中切换应用，观察状态变化'),
                Text('5. 所有生命周期变化都会记录在下方日志中'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _logs.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '暂无日志\n请切换应用状态以查看生命周期回调',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: _logs.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getLogColor(index),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _logs[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getLogColor(int index) {
    if (_logs[index].contains('onResume') || _logs[index].contains('onShow')) {
      return Colors.green;
    } else if (_logs[index].contains('onPause') ||
        _logs[index].contains('onHide')) {
      return Colors.orange;
    } else if (_logs[index].contains('onDetach') ||
        _logs[index].contains('onExitRequested')) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}


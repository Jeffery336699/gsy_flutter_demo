import 'package:flutter/material.dart';

/// 自定义通知类 - 携带消息内容
class MessageNotification extends Notification {
  final String message;
  final int count;

  MessageNotification(this.message, this.count);
}

/// 自定义通知类 - 滚动通知
class CustomScrollNotification extends Notification {
  final double scrollPosition;

  const CustomScrollNotification(this.scrollPosition);
}

/// 通知演示页面
class NotificationDemoPage extends StatefulWidget {
  const NotificationDemoPage({super.key});

  @override
  State<NotificationDemoPage> createState() => _NotificationDemoPageState();
}

class _NotificationDemoPageState extends State<NotificationDemoPage> {
  String _receivedMessage = '等待通知...';
  int _notificationCount = 0;
  double _scrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification 使用演示'),
        backgroundColor: Colors.blue,
      ),
      body: NotificationListener<MessageNotification>(
        onNotification: (notification) {
          // 接收到通知后更新UI
          setState(() {
            _receivedMessage = notification.message;
            _notificationCount = notification.count;
          });
          // 返回true表示阻止通知继续向上冒泡，返回false则继续向上传递
          return true;
        },
        /// 这样我仅监听我自定义的，而我发出的地方是我需要监听的子孙组件，这样就不会被其他滚动对象干扰到
        child: NotificationListener<CustomScrollNotification>(
          onNotification: (notification) {
            setState(() {
              _scrollPosition = notification.scrollPosition;
            });
            return true;
          },
          child: Column(
            children: [
              // 顶部状态显示区域
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.blue.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '接收到的消息:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _receivedMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '通知次数: $_notificationCount',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '滚动位置: ${_scrollPosition.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 内容区域
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      '什么是 Notification？',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notification 是 Flutter 中用于从子 Widget 向父 Widget 传递消息的机制。'
                      '它采用冒泡的方式向上传递，任何祖先 Widget 都可以通过 NotificationListener 来监听。',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '点击下方按钮发送通知：',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Optimize: 这里只有子孙类的context才能发送通知成功，所以需要包裹层Builder为的是获取正确的context
                    _NotificationSender(
                      onSend: (context,count) {
                        // 发送自定义通知
                        MessageNotification(
                          '按钮点击了 $count 次',
                          count,
                        ).dispatch(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '滚动通知（底层监听后，构建自定义的再次分发上去）：',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 滚动列表
                    _ScrollNotificationWidget(),
                    const SizedBox(height: 24),
                    _UsageCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 通知发送器组件
class _NotificationSender extends StatefulWidget {
  final Function(BuildContext, int) onSend;

  const _NotificationSender({required this.onSend});

  @override
  State<_NotificationSender> createState() => _NotificationSenderState();
}

class _NotificationSenderState extends State<_NotificationSender> {
  int _clickCount = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '点击次数: $_clickCount',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _clickCount++;
                    });
                    widget.onSend(context,_clickCount);
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('发送通知'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _clickCount = 0;
                    });
                    widget.onSend(context,0);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('重置'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 滚动通知组件
class _ScrollNotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            /// 构建自定义滚动通知并分发,用于监听特定的滚动对象，在顶层仅需要监听CustomScrollNotification即可，
            /// 这样做的好处天然过滤其他滚动对象（内部会发送通知）的干扰。
            /// 但另一个方案也可以直接在顶层进行ScrollNotification的depth深度参数来判断是哪个滚动对象。
            CustomScrollNotification(notification.metrics.pixels)
                .dispatch(context);
          }
          // 监听listview组件内部发出来的，返回 false 允许通知继续向上传递
          return true;
        },
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text('${index + 1}'),
              ),
              title: Text('列表项 ${index + 1}'),
              subtitle: Text('滚动我会发送通知'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            );
          },
        ),
      ),
    );
  }
}

/// 使用说明卡片
class _UsageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Text(
                  'Notification 使用要点',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip('1. 继承 Notification 类创建自定义通知'),
            _buildTip('2. 使用 NotificationListener 监听通知'),
            _buildTip('3. 通过 dispatch(context) 发送通知'),
            _buildTip('4. 返回 true 阻止冒泡，返回 false 继续向上传递'),
            _buildTip('5. 可以携带自定义数据'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


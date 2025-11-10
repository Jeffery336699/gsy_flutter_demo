import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsy_flutter_demo/main.dart';

/// Flutter 触摸和滑动原理以及事件竞争演示页面
/// 深入讲解触摸事件处理机制和常见的事件竞争场景
class GestureEventCompetitionDemoPage extends StatefulWidget {
  const GestureEventCompetitionDemoPage({super.key});

  @override
  State<GestureEventCompetitionDemoPage> createState() =>
      _GestureEventCompetitionDemoPageState();
}

class _GestureEventCompetitionDemoPageState
    extends State<GestureEventCompetitionDemoPage> {
  final List<DemoItem> _demos = [
    DemoItem(
      title: '1. 基础：触摸事件流程',
      description: '演示触摸事件从 Down → Move → Up 的完整流程',
      builder: (context) => const TouchEventFlowDemo(),
    ),
    DemoItem(
      title: '2. 手势竞争：Tap vs LongPress',
      description: '点击和长按事件的竞争关系',
      builder: (context) => const TapVsLongPressDemo(),
    ),
    DemoItem(
      title: '3. 手势竞争：Tap vs Pan',
      description: '点击和滑动事件的竞争（最常见）',
      builder: (context) => const TapVsPanDemo(),
    ),
    DemoItem(
      title: '4. 手势竞争：垂直滑动 vs 水平滑动',
      description: '滑动方向的识别和竞争',
      builder: (context) => const VerticalVsHorizontalDemo(),
    ),
    DemoItem(
      title: '5. 父子手势冲突：ListView 中的按钮',
      description: '滚动列表中的点击事件',
      builder: (context) => const ListViewWithButtonDemo(),
    ),
    DemoItem(
      title: '6. 父子手势冲突：可滑动卡片',
      description: 'PageView 中的可拖拽卡片',
      builder: (context) => const PageViewWithDraggableDemo(),
    ),
    DemoItem(
      title: '7. 手势竞技场 Arena 机制',
      description: '理解 GestureArena 的竞争和获胜机制',
      builder: (context) => const GestureArenaDemo(),
    ),
    DemoItem(
      title: '8. RawGestureDetector 自定义',
      description: '使用 RawGestureDetector 自定义手势行为',
      builder: (context) => const RawGestureDemo(),
    ),
    DemoItem(
      title: '9. HitTest 命中测试',
      description: '理解触摸点如何找到目标控件',
      builder: (context) => const HitTestDemo(),
    ),
    DemoItem(
      title: '10. 实战：嵌套滚动解决方案',
      description: '水平滚动中嵌套垂直滚动',
      builder: (context) => const NestedScrollSolutionDemo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 触摸事件与手势竞争'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _demos.length,
        itemBuilder: (context, index) {
          final demo = _demos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: demo.builder,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      demo.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DemoItem {
  final String title;
  final String description;
  final WidgetBuilder builder;

  DemoItem({
    required this.title,
    required this.description,
    required this.builder,
  });
}

// ==================== 1. 触摸事件流程演示 ====================
class TouchEventFlowDemo extends StatefulWidget {
  const TouchEventFlowDemo({super.key});

  @override
  State<TouchEventFlowDemo> createState() => _TouchEventFlowDemoState();
}

class _TouchEventFlowDemoState extends State<TouchEventFlowDemo> {
  final List<String> _events = [];
  Offset? _currentPosition;

  void _addEvent(String event) {
    setState(() {
      _events.add('${DateTime.now().millisecondsSinceEpoch % 100000}: $event');
      if (_events.length > 20) {
        _events.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('触摸事件流程')),
      body: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (event) {
                _addEvent('⬇️ PointerDown: ${event.position}');
                setState(() => _currentPosition = event.position);
              },
              onPointerMove: (event) {
                _addEvent('➡️ PointerMove: ${event.position}');
                setState(() => _currentPosition = event.position);
              },
              onPointerUp: (event) {
                _addEvent('⬆️ PointerUp: ${event.position}');
                setState(() => _currentPosition = null);
              },
              onPointerCancel: (event) {
                _addEvent('❌ PointerCancel');
                setState(() => _currentPosition = null);
              },
              child: Container(
                color: Colors.blue[50],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '在这里触摸和滑动',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      if (_currentPosition != null)
                        Text(
                          '当前位置: ${_currentPosition!.dx.toStringAsFixed(1)}, '
                          '${_currentPosition!.dy.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 300,
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '事件日志：',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _events.clear()),
                        child: const Text('清空'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Text(
                          _events[_events.length - 1 - index],
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 2. Tap vs LongPress ====================
class TapVsLongPressDemo extends StatefulWidget {
  const TapVsLongPressDemo({super.key});

  @override
  State<TapVsLongPressDemo> createState() => _TapVsLongPressDemoState();
}

class _TapVsLongPressDemoState extends State<TapVsLongPressDemo> {
  String _status = '等待操作...';
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap vs LongPress 竞争')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '原理说明：\n'
                  '1. 手指按下时，Tap 和 LongPress 都进入竞技场\n'
                  '2. 如果在 500ms 内抬起，Tap 获胜\n'
                  '3. 如果超过 500ms 未抬起，LongPress 获胜，Tap 出局\n'
                  '4. 一旦 LongPress 触发，后续的 Up 不会触发 Tap',
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _status = '⬇️ 按下：Tap 和 LongPress 进入竞技场';
                  print('⬇️ 按下：Tap 和 LongPress 进入竞技场');
                  _color = Colors.orange;
                });
              },
              onTapUp: (_) {
                setState(() {
                  _status = '⬆️ 快速抬起';
                  print('⬆️ 快速抬起');
                });
              },
              onTap: () {
                setState(() {
                  _status = '✅ Tap 获胜！（快速点击）';
                  print('✅ Tap 获胜！（快速点击）');
                  _color = Colors.green;
                });
              },
              onLongPress: () {
                setState(() {
                  _status = '⏰ LongPress 获胜！（长按超过 500ms）';
                  print('⏰ LongPress 获胜！（长按超过 500ms）');
                  _color = Colors.purple;
                });
              },
              onLongPressStart: (details) {
                setState(() {
                  _status = '⏰ LongPressStart（长按超过 500ms）';
                  print('⏰ LongPressStart（长按超过 500ms）');
                  _color = Colors.purple;
                });
              },
              onLongPressCancel: () {
                setState(() {
                  _status = '❌ LongPress 被取消';
                  print('❌ LongPress 被取消');
                });
              },
              onTapCancel: () {
                setState(() {
                  _status = '❌ Tap 被取消（LongPress 获胜）';
                  print('❌ Tap 被取消（LongPress 获胜）');
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _color.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '按住我\n试试快按和长按',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 3. Tap vs Pan ====================
class TapVsPanDemo extends StatefulWidget {
  const TapVsPanDemo({super.key});

  @override
  State<TapVsPanDemo> createState() => _TapVsPanDemoState();
}

class _TapVsPanDemoState extends State<TapVsPanDemo> {
  String _status = '等待操作...';
  Offset _position = Offset.zero;
  final List<String> _log = [];
  double? stackHeight;

  void _addLog(String msg) {
    setState(() {
      _log.add(msg);
      if (_log.length > 10) _log.removeAt(0);
    });
  }

  GlobalKey gk=GlobalKey();
  double? _getWidgetHeight() {
    final RenderBox? renderBox = gk.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size.height;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stackHeight = _getWidgetHeight();
      logger.w('Widget height: $stackHeight');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap vs Pan 竞争')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '原理说明：\n'
                '1. 手指按下时，Tap 和 Pan 都进入竞技场\n'
                '2. 如果移动距离小于 18px（kTouchSlop），两者都等待\n'
                '3. 如果移动超过 18px，Pan 获胜，Tap 被取消\n'
                '4. 如果在原地抬起，Tap 获胜\n'
                '这是最常见的手势冲突场景！',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (_) {
                _addLog('⬇️ TapDown: 竞技场开始');
                setState(() => _status = '按下：等待判断是点击还是拖动...');
              },
              onTap: () {
                _addLog('✅ Tap 获胜');
                setState(() => _status = '✅ 识别为点击（移动 < 18px）');
              },
              onTapCancel: () {
                _addLog('❌ Tap 被取消');
              },
              onPanStart: (details) {
                _addLog('🎯 PanStart: Pan 获胜');
                setState(() {
                  _status = '🎯 识别为拖动（移动 ≥ 18px）';
                  _position = details.globalPosition;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _position = details.localPosition;
                  _status = '➡️ 拖动中... 移动量: '
                      '${details.delta.dx.toStringAsFixed(1)}, '
                      '${details.delta.dy.toStringAsFixed(1)}';
                });
              },
              onPanEnd: (details) {
                _addLog('⬆️ PanEnd');
                setState(() => _status = '拖动结束');
              },
              child: Container(
                color: Colors.blue[50],
                child: Stack(
                  key: gk,
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '试试点击和拖动',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _status,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '提示：移动小于 18px 算点击\n移动大于等于 18px 算拖动',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (_position != Offset.zero && stackHeight != null)
                      Positioned(
                        left: (_position.dx  - 25).clamp(0, MediaQuery.of(context).size.width - 50),
                        top: (_position.dy - 25).clamp(0, stackHeight! - 50),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '事件日志：',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _log.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _log[_log.length - 1 - index],
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 4. 垂直 vs 水平滑动 ====================
class VerticalVsHorizontalDemo extends StatefulWidget {
  const VerticalVsHorizontalDemo({super.key});

  @override
  State<VerticalVsHorizontalDemo> createState() =>
      _VerticalVsHorizontalDemoState();
}

class _VerticalVsHorizontalDemoState extends State<VerticalVsHorizontalDemo> {
  String _winner = '等待滑动...';
  double _dx = 0;
  double _dy = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('垂直 vs 水平滑动竞争')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '原理说明：\n'
                '1. 同时监听垂直和水平滑动时，系统会判断滑动方向\n'
                '2. 根据首次移动的主要方向决定胜者\n'
                '3. 一旦确定方向，另一个方向的手势被取消\n'
                '4. onVerticalDragStart 和 onHorizontalDragStart 互斥',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragStart: (details) {
                setState(() => _winner = '⬆️⬇️ 垂直滑动获胜！');
              },
              onVerticalDragUpdate: (details) {
                setState(() {
                  _dy += details.delta.dy;
                  _winner = '⬆️⬇️ 垂直滑动中... dy: ${_dy.toStringAsFixed(1)}';
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  _winner = '垂直滑动结束';
                  _dy = 0;
                });
              },
              onHorizontalDragStart: (details) {
                setState(() => _winner = '⬅️➡️ 水平滑动获胜！');
              },
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dx += details.delta.dx;
                  _winner = '⬅️➡️ 水平滑动中... dx: ${_dx.toStringAsFixed(1)}';
                });
              },
              onHorizontalDragEnd: (details) {
                setState(() {
                  _winner = '水平滑动结束';
                  _dx = 0;
                });
              },
              child: Container(
                color: Colors.blue[50],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.open_with, size: 64, color: Colors.blue),
                      const SizedBox(height: 32),
                      const Text(
                        '在这里滑动',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _winner,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '提示：首次滑动的主要方向决定胜者',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 5. ListView 中的按钮 ====================
class ListViewWithButtonDemo extends StatelessWidget {
  const ListViewWithButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView 中的按钮冲突')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '常见问题：\n'
                '列表滚动和按钮点击事件冲突\n\n'
                '解决方案：\n'
                '1. ListView 的滚动手势优先级更高\n'
                '2. 点击按钮时，如果不滑动，按钮获胜\n'
                '3. 如果滑动超过阈值，ListView 滚动获胜，按钮失效\n'
                '4. 这是 Flutter 默认的良好行为',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('列表项 ${index + 1}'),
                    subtitle: const Text('试试点击按钮和滚动列表'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('按钮 ${index + 1} 被点击'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text('点击'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 6. PageView 中的可拖拽卡片 ====================
class PageViewWithDraggableDemo extends StatefulWidget {
  const PageViewWithDraggableDemo({super.key});

  @override
  State<PageViewWithDraggableDemo> createState() =>
      _PageViewWithDraggableDemoState();
}

class _PageViewWithDraggableDemoState
    extends State<PageViewWithDraggableDemo> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PageView 中的拖拽卡片')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '复杂场景：\n'
                '水平的 PageView + 可垂直拖动的卡片\n\n'
                '冲突：\n'
                '- 水平滑动应该切换页面\n'
                '- 垂直滑动应该拖动卡片\n\n'
                '解决：\n'
                'Flutter 会根据首次滑动方向判断',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: 3,
              itemBuilder: (context, pageIndex) {
                return _DraggableCardPage(
                  pageIndex: pageIndex,
                  currentPage: _currentPage,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DraggableCardPage extends StatefulWidget {
  final int pageIndex;
  final int currentPage;

  const _DraggableCardPage({
    required this.pageIndex,
    required this.currentPage,
  });

  @override
  State<_DraggableCardPage> createState() => _DraggableCardPageState();
}

class _DraggableCardPageState extends State<_DraggableCardPage> {
  double _top = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '页面 ${widget.pageIndex + 1}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Stack(
              // fit: StackFit.expand,
              children: [
                Center(
                  child: Text(
                    '垂直拖动卡片\n水平滑动切页',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                Positioned(
                  top: _top,
                  left: 0,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _top += details.delta.dy;
                        _top = _top.clamp(0, 250);
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '拖动我',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 7. 手势竞技场 Arena ====================
class GestureArenaDemo extends StatefulWidget {
  const GestureArenaDemo({super.key});

  @override
  State<GestureArenaDemo> createState() => _GestureArenaDemoState();
}

class _GestureArenaDemoState extends State<GestureArenaDemo> {
  final List<String> _arenaLog = [];

  void _addLog(String msg) {
    setState(() {
      _arenaLog.add('${DateTime.now().millisecondsSinceEpoch % 100000}: $msg');
      if (_arenaLog.length > 15) _arenaLog.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手势竞技场机制')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.purple,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'GestureArena 竞技场机制：\n\n'
                '1. PointerDown：所有感兴趣的手势进入竞技场\n'
                '2. 竞争阶段：各个手势根据条件声明自己的意图\n'
                '3. 决出胜者：满足条件的手势获胜，其他被取消\n'
                '4. 获胜者独占：只有获胜的手势接收后续事件\n\n'
                '优先级规则：\n'
                '- 明确的手势 > 模糊的手势\n'
                '- 子控件 > 父控件（默认）',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTapDown: (_) => _addLog('🔵 外层 TapDown - 进入竞技场'),
                onTap: () => _addLog('🔵 外层 Tap 获胜'),
                onTapCancel: () => _addLog('🔵 外层 Tap 被取消'),
                child: Container(
                  color: Colors.blue[100],
                  child: Center(
                    child: GestureDetector(
                      onTapDown: (_) => _addLog('🟢 内层 TapDown - 进入竞技场'),
                      onTap: () => _addLog('🟢 内层 Tap 获胜（子控件优先）'),
                      onTapCancel: () => _addLog('🟢 内层 Tap 被取消'),
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.green[300],
                        child: const Center(
                          child: Text(
                            '点击内层\n子控件优先',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 250,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '竞技场日志：',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _arenaLog.clear()),
                      child: const Text('清空'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _arenaLog.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _arenaLog[_arenaLog.length - 1 - index],
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 8. RawGestureDetector ====================
class RawGestureDemo extends StatefulWidget {
  const RawGestureDemo({super.key});

  @override
  State<RawGestureDemo> createState() => _RawGestureDemoState();
}

class _RawGestureDemoState extends State<RawGestureDemo> {
  String _status = '等待操作...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RawGestureDetector 自定义')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.teal,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'RawGestureDetector 用途：\n\n'
                '1. 自定义手势识别器\n'
                '2. 修改手势竞技场行为\n'
                '3. 同时响应多个冲突手势\n'
                '4. 精细控制手势优先级\n\n'
                '示例：让 Tap 和 Pan 同时生效',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: RawGestureDetector(
              gestures: {
                // 自定义 Tap 识别器，设置为立即获胜
                AllowMultipleGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                        AllowMultipleGestureRecognizer>(
                  () => AllowMultipleGestureRecognizer(),
                  (instance) {
                    instance.onTap = () {
                      setState(() => _status = '✅ Tap 触发（同时支持拖动）');
                    };
                  },
                ),
                // Pan 识别器
                PanGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                  () => PanGestureRecognizer(),
                  (instance) {
                    instance.onStart = (details) {
                      setState(() => _status = '🎯 Pan 开始');
                    };
                    instance.onUpdate = (details) {
                      setState(() =>
                          _status = '➡️ Pan 更新: ${details.delta}');
                    };
                    instance.onEnd = (details) {
                      setState(() => _status = '⬆️ Pan 结束');
                    };
                  },
                ),
              },
              child: Container(
                color: Colors.teal[50],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '点击和拖动都可以触发！',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        _status,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 自定义手势识别器：允许多个手势同时存在
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    // 不拒绝，允许其他手势同时进行
    acceptGesture(pointer);
  }
}

// ==================== 9. HitTest 命中测试 ====================
class HitTestDemo extends StatefulWidget {
  const HitTestDemo({super.key});

  @override
  State<HitTestDemo> createState() => _HitTestDemoState();
}

class _HitTestDemoState extends State<HitTestDemo> {
  final List<String> _hitLog = [];
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HitTest 命中测试')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.indigo,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'HitTest 工作流程：\n\n'
                '1. 从根节点开始，向下遍历 Widget 树\n'
                '2. 每个节点判断触摸点是否在自己范围内\n'
                '3. 如果命中，将自己加入命中列表\n'
                '4. 继续测试子节点（从后往前，后绘制的在上层）\n'
                '5. 最终得到一个命中链表，从子到父\n\n'
                '特殊情况：\n'
                '- behavior: HitTestBehavior 控制测试行为\n'
                '- ignorePointer: 忽略自己和子节点',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // 父容器
                Listener(
                  onPointerDown: (event) {
                    setState(() {
                      _tapPosition = event.position;
                      _hitLog.clear();
                      _hitLog.add('🔴 父容器被命中');
                    });
                  },
                  child: Container(
                    color: Colors.red[100],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 子容器1 - 可穿透
                          Listener(
                            behavior: HitTestBehavior.translucent,
                            onPointerDown: (event) {
                              _hitLog.add('🟡 黄色区域被命中（translucent）');
                            },
                            child: Container(
                              width: 200,
                              height: 100,
                              color: Colors.yellow[300],
                              child: const Center(
                                child: Text('黄色：可穿透'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // 子容器2 - 阻止
                          Listener(
                            behavior: HitTestBehavior.opaque,
                            onPointerDown: (event) {
                              _hitLog.add('🟢 绿色区域被命中（opaque，阻止父级）');
                            },
                            child: Container(
                              width: 200,
                              height: 100,
                              color: Colors.green[300],
                              child: const Center(
                                child: Text('绿色：阻止父级'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_tapPosition != null)
                  Positioned(
                    left: _tapPosition!.dx - 15,
                    top: _tapPosition!.dy - 15,
                    child: IgnorePointer(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            height: 150,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '命中结果：',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _hitLog.length,
                    itemBuilder: (context, index) {
                      return Text(_hitLog[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 10. 嵌套滚动解决方案 ====================
class NestedScrollSolutionDemo extends StatelessWidget {
  const NestedScrollSolutionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('嵌套滚动解决方案')),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.deepOrange,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '问题：水平滚动中嵌套垂直滚动\n\n'
                '方案1：根据滑动方向判断（已实现）\n'
                '方案2：使用 NeverScrollableScrollPhysics 禁用内部滚动\n'
                '方案3：使用 RawGestureDetector 自定义\n'
                '方案4：使用 NotificationListener 监听滚动\n\n'
                '下方演示：水平 PageView + 垂直 ListView',
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, pageIndex) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.primaries[pageIndex % Colors.primaries.length]
                        [100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '页面 ${pageIndex + 1}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(child: Text('${index + 1}')),
                              title: Text('项目 ${index + 1}'),
                              subtitle: const Text('垂直滚动'),
                            );
                          },
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
}


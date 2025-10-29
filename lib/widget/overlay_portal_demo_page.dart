import 'package:flutter/material.dart';

///OverlayPortal 演示页面
///展示如何使用 OverlayPortal 创建浮层效果
class OverlayPortalDemoPage extends StatefulWidget {
  const OverlayPortalDemoPage({super.key});

  @override
  State<OverlayPortalDemoPage> createState() => _OverlayPortalDemoPageState();
}

class _OverlayPortalDemoPageState extends State<OverlayPortalDemoPage> {
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final OverlayPortalController _menuController = OverlayPortalController();
  final OverlayPortalController _dialogController = OverlayPortalController();

  ///使用 Overlay + OverlayEntry 实现真正的全局悬浮球
  OverlayEntry? _floatingBallEntry;
  Offset _ballPosition = const Offset(300, 400);
  int _counter = 0;

  ///创建全局悬浮球 OverlayEntry
  OverlayEntry _createFloatingBallEntry() {
    return OverlayEntry(
      builder: (context) {
        ///获取屏幕尺寸用于边界检测
        final screenSize = MediaQuery.of(context).size;
        const ballSize = 60.0;

        return Positioned(
          left: _ballPosition.dx,
          top: _ballPosition.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                ///计算新位置
                double newX = _ballPosition.dx + details.delta.dx;
                double newY = _ballPosition.dy + details.delta.dy;

                ///边界限制：确保小球不会超出屏幕
                newX = newX.clamp(0.0, screenSize.width - ballSize);
                newY = newY.clamp(0.0, screenSize.height - ballSize);

                _ballPosition = Offset(newX, newY);
              });
              ///更新悬浮球位置
              _floatingBallEntry?.markNeedsBuild();
            },
          onTap: () {
            setState(() {
              _counter++;
            });
            ///更新悬浮球显示
            _floatingBallEntry?.markNeedsBuild();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('悬浮球被点击了 $_counter 次')),
            );
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.touch_app, color: Colors.white, size: 24),
                  Text(
                    '$_counter',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }

  ///显示悬浮球
  void _showFloatingBall() {
    if (_floatingBallEntry != null) return;

    ///获取应用根 Overlay，而不是当前页面的 Overlay，因为目前就一个navigator,rootOverlay设置与否无影响
    final overlay = Overlay.of(context, rootOverlay: false);
    _floatingBallEntry = _createFloatingBallEntry();
    overlay.insert(_floatingBallEntry!);
  }

  ///隐藏悬浮球
  void _hideFloatingBall() {
    _floatingBallEntry?.remove();
    _floatingBallEntry = null;
  }

  @override
  void dispose() {
    ///页面销毁时移除悬浮球
    _hideFloatingBall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OverlayPortal 演示'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
              style: const TextStyle(fontSize: 16, color: Colors.green),
              child: OverlayPortal(
                controller: _tooltipController,
                overlayChildBuilder: (BuildContext context) {
                  return Positioned(
                    top: 80,
                    left: 0,
                    /// 如果此处使用Material会覆盖上面的DefaultTextStyle效果，导致内部的Text无法继承到绿色样式
                    /// 1.【可共享页面状态特性】
                    /// 不同于 OverlayEntry 与页面互为平级、无法通过 InheritedWidget 共享状态
                    /// OverlayPortal 可以继承父页面的状态（如 Theme、DefaultTextStyle），实现组件跨层级的样式和数据同步（它本身在tree中）
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '这是一个 Tooltip',
                      ),
                    ),
                  );
                },
                child: ElevatedButton(
                  onPressed: () {
                    _tooltipController.toggle();
                  },
                  child: const Text('显示/隐藏 Tooltip'),
                ),
              ),
            ),
            ///Tooltip 效果

            const SizedBox(height: 40),

            ///菜单效果
            OverlayPortal(
              controller: _menuController,
              overlayChildBuilder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    _menuController.hide();
                  },
                  ///点击外部区域能隐藏菜单，是因为这里Container占满了整个屏幕，相当于上面的GestureDetector#onTap触发
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('编辑'),
                                onTap: () {
                                  _menuController.hide();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('点击了编辑')),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.share),
                                title: const Text('分享'),
                                onTap: () {
                                  _menuController.hide();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('点击了分享')),
                                  );
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('删除'),
                                onTap: () {
                                  _menuController.hide();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('点击了删除')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: ElevatedButton(
                onPressed: () {
                  _menuController.toggle();
                },
                child: const Text('显示/隐藏 菜单'),
              ),
            ),
            const SizedBox(height: 40),

            ///自定义对话框效果
            OverlayPortal(
              controller: _dialogController,
              overlayChildBuilder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    _dialogController.hide();
                  },
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: Material(
                        elevation: 16,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 300,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '操作成功',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '这是一个使用 OverlayPortal 实现的自定义对话框',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _dialogController.hide();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('确定'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: ElevatedButton(
                onPressed: () {
                  _dialogController.show();
                },
                child: const Text('显示自定义对话框'),
              ),
            ),
            const SizedBox(height: 40),

            ///跨页面悬浮球效果 - 使用 Overlay + OverlayEntry 实现
            ///3.【真正的跨页面持久化显示特性】
            ///OverlayPortal 的浮层实际上是基于当前页面的，无法真正跨页面显示
            ///要实现真正的全局悬浮球，需要使用 Overlay.of(context, rootOverlay: true)
            ///将 OverlayEntry 插入到应用根 Overlay 中，这样即使页面切换，悬浮球依然保持显示
            ElevatedButton(
              onPressed: () {
                if (_floatingBallEntry == null) {
                  _showFloatingBall();
                } else {
                  _hideFloatingBall();
                }
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(_floatingBallEntry == null
                  ? '显示悬浮球 (Overlay)'
                  : '隐藏悬浮球 (Overlay)'),
            ),
            const SizedBox(height: 20),

            ///导航到新页面测试悬浮球是否保持显示
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const _TestPage(),
                  ),
                );
              },
              icon: const Icon(Icons.navigate_next),
              label: const Text('跳转新页面测试悬浮球'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///测试页面 - 用于验证悬浮球跨页面显示
class _TestPage extends StatelessWidget {
  const _TestPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试页面'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              '这是一个新页面',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '注意：悬浮球依然显示在屏幕上',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回上一页'),
            ),
          ],
        ),
      ),
    );
  }
}


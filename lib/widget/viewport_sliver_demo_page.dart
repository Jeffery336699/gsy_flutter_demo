import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gsy_flutter_demo/main.dart';
import 'package:gsy_flutter_demo/widget/pin_sliver/pin_sliver2.dart';

import 'pin_sliver/pin_sliver.dart';

class ViewportSliverDemoPage extends StatelessWidget {
  ViewportSliverDemoPage({super.key});

  final ViewportOffset position = ViewportOffset.zero();
  final List<Color> _colors = List<Color>.generate(
    6,
    (index) => Colors.blue[(index + 3) * 100] ?? Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    print('position: ${position.pixels}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewport 与 Sliver 关系'),
        actions: [
          CircleAvatar(
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                /// Scrollable的作用：
                /// ①往上接收滚动手势事件，触发位置的变化，并给到Viewport ViewportOffset这个可监听对象
                /// ②统筹规划，做好最大滚动范围的约束，该例中也加约束，底部就出现白屏了
                /// ③做完上述这些后，通知Viewport去更新，后续的重新构建布局就是Viewport的事了
                position.correctBy(-100);
                position.notifyListeners();
              },
            ),
          ),
          Padding(padding: const EdgeInsets.only(right: 16))
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: true,
            child: Expanded(
              child: Scrollable(
                axisDirection: AxisDirection.down,
                physics: const BouncingScrollPhysics(),
                viewportBuilder: (BuildContext context, ViewportOffset position) {
                  logger.i('Viewport build with offset: $position');
                  position.addListener(() {
                    logger.i('Viewport offset changed: $position');
                  });
                  return Viewport(
                    offset: position,
                    axisDirection: AxisDirection.down,
                    slivers: <Widget>[
                      // buildSliverAppBar,
                      mySliverPersistentHeader,
                      // fixedHeaderSliver,
                      // buildSliverToBoxAdapterHeader,
                      // sliverFixedExtentList,
                      // buildSliverToBoxAdapter,
                      ///1. SliverToBoxAdapter 的子组件是一个 Column。
                      ///2. Column 会一次性渲染其所有的子组件（10个高度为200的 Container），因此 Column 的总高度为 2000。
                      ///3. SliverToBoxAdapter 会将这 2000 的高度作为一个整体内容呈现在 Viewport 中。
                      ///   因此，虽然 Scrollable 会使整个 SliverToBoxAdapter（作为一个高度为 2000 的巨大 Sliver）可以滚动，
                      ///但您看到的滚动效果是整个 Column 在上下移动，而不是 Column 内部的元素滚动。
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue.shade900,
                                Colors.blue.shade800,
                                Colors.blue.shade700,
                                Colors.blue.shade600,
                                Colors.blue.shade500,
                                Colors.blue.shade400,
                                Colors.blue.shade300,
                                Colors.blue.shade200,
                                Colors.blue.shade100,
                                Colors.blue.shade50,
                              ],
                            ),
                          ),
                          child: Column(
                            children: List.generate(
                              10,
                              (index) => Container(
                                height: 200,
                                alignment: Alignment.center,
                                child: Text("Item $index", style: const TextStyle(color: Colors.white, fontSize: 24)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      sliverFixedExtentList,
                      // SliverPadding(padding: EdgeInsets.symmetric(vertical: 1000)),
                    ],
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Expanded(
                child: Viewport(
              offset: position,
              axisDirection: AxisDirection.down,
              slivers: <Widget>[
                ///1. SliverToBoxAdapter 的子组件是一个 Column。
                ///2. Column 会一次性渲染其所有的子组件（10个高度为200的 Container），因此 Column 的总高度为 2000。
                ///3. SliverToBoxAdapter 会将这 2000 的高度作为一个整体内容呈现在 Viewport 中。
                ///   因此，虽然 Scrollable 会使整个 SliverToBoxAdapter（作为一个高度为 2000 的巨大 Sliver）可以滚动，
                ///但您看到的滚动效果是整个 Column 在上下移动，而不是 Column 内部的元素滚动。
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade900,
                          Colors.blue.shade800,
                          Colors.blue.shade700,
                          Colors.blue.shade600,
                          Colors.blue.shade500,
                          Colors.blue.shade400,
                          Colors.blue.shade300,
                          Colors.blue.shade200,
                          Colors.blue.shade100,
                          Colors.blue.shade50,
                        ],
                      ),
                    ),
                    child: Column(
                      children: List.generate(
                        10,
                        (index) => Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Text("Item2 - $index", style: const TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                      ),
                    ),
                  ),
                ),
                // SliverPadding(padding: EdgeInsets.symmetric(vertical: 1000)),
              ],
            )),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter get buildSliverToBoxAdapterHeader {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.amber.shade100,
        padding: const EdgeInsets.all(16),
        child: const Text(
          'SliverToBoxAdapter：充当普通盒子组件，被 Viewport 当作第一个 Sliver。'
          '它通常用于放介绍性区域或 Header。',
        ),
      ),
    );
  }

  SliverAppBar get buildSliverAppBar {
    return SliverAppBar(
        pinned: true, // 关键：吸顶
        expandedHeight: 200.0, // 展开时 200 高
        flexibleSpace: FlexibleSpaceBar(
          title: const Text('SliverAppBar 示例'),
          background: Image.asset(
            'static/test.jpeg',
            fit: BoxFit.cover,
          ),
        ));
  }

  /// 还有问题，得找找其他方式(Flutter实战中？安德烈小册？)或者仿照系统得SliverAppBar
  FixedHeaderSliver get fixedHeaderSliver {
    return FixedHeaderSliver(
      height: 56.0, // 展开时 200 高
      child: Container(
          color: Colors.deepOrangeAccent.shade100.withOpacity(1),
          alignment: Alignment.centerLeft,
          child: Text('简单文本')),
    );
  }

  MySliverPersistentHeader get mySliverPersistentHeader {
    return MySliverPersistentHeader(
      maxHeight: 200,
      minHeight: kTextTabBarHeight,
    );
  }

  SliverToBoxAdapter get buildSliverToBoxAdapter {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.greenAccent.shade100,
        child: const Text(
          '总结：Scrollable 持有滚动位置，Viewport 读取位置并依次向 Sliver 请求布局，Sliver 再将可见的子节点绘制出来。',
        ),
      ),
    );
  }

  SliverFixedExtentList get sliverFixedExtentList => SliverFixedExtentList(
        itemExtent: 80,
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              color: _colors[index % _colors.length].withOpacity(0.4),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('SliverList Item $index — Viewport 正在拉取第 ${index + 1} 个 SliverChild'),
            );
          },
          childCount: 16,
        ),
      );

}

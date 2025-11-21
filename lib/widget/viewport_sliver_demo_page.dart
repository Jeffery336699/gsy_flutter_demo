import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ViewportSliverDemoPage extends StatelessWidget {
  ViewportSliverDemoPage({super.key});

  final List<Color> _colors = List<Color>.generate(
    6,
    (index) => Colors.blue[(index + 3) * 100] ?? Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Viewport 与 Sliver 关系'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Viewport 是可滚动区域真正的 "视口"，它持有 Scrollable 提供的 offset，并驱动多个 Sliver 依次布局与绘制。'
              '下面的示例直接使用 Scrollable+Viewport，将 SliverToBoxAdapter 与 SliverList 组合起来，'
              '方便观察 Viewport 如何按顺序拉起不同类型的 Sliver。',
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Scrollable(
              axisDirection: AxisDirection.down,
              viewportBuilder: (BuildContext context, ViewportOffset position) {

                return Viewport(
                  offset: position,
                  axisDirection: AxisDirection.down,
                  anchor: 0.5,
                  slivers: <Widget>[
                    // buildSliverToBoxAdapterHeader,
                    // sliverFixedExtentList,
                    // buildSliverToBoxAdapter,
                    SliverToBoxAdapter(child: Container(color: Colors.blue,child: SizedBox(height: 100,),),)

                  ],
                );
              },
            ),
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
      childCount: 10,
    ),
  );
}


import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

class SimpleSliver extends LeafRenderObjectWidget {
  final Color color;
  final double extent;

  const SimpleSliver({
    super.key,
    this.color = Colors.blue,
    this.extent = 200.0,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    // 创建 RenderObject 并把颜色和高度传过去
    return RenderSimpleSliver(
      color: color,
      extent: extent,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSimpleSliver renderObject) {
    // 当 Widget 属性变化时，更新 RenderObject
    renderObject
      ..color = color
      ..extent = extent;
  }
}

class RenderSimpleSliver extends RenderSliver {
  // 从 Widget 接收颜色和高度
  RenderSimpleSliver({
    required Color color,
    required double extent,
  })  : _color = color,
        _extent = extent;
  Color _color;
  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    markNeedsPaint(); // 颜色变了，需要重绘
  }

  double _extent;
  double get extent => _extent;
  set extent(double value) {
    if (_extent == value) return;
    _extent = value;
    markNeedsLayout(); // 高度变了，需要重新布局
  }
  @override
  void performLayout() {
    // 计算 Sliver 可见的绘制高度
    final double paintExtent = (_extent - constraints.scrollOffset).clamp(0.0, _extent);
    // 设置 Sliver 的几何属性
    geometry = SliverGeometry(
      scrollExtent: _extent,       // 总的可滚动范围
      paintExtent: paintExtent,      // 当前帧需要绘制的高度
      maxPaintExtent: _extent,     // 最大可绘制高度
      layoutExtent: paintExtent,     // 在主轴上占据的布局空间
      visible: paintExtent > 0,    // 是否可见
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // 如果可见高度大于0，才进行绘制
    if (geometry!.paintExtent > 0.0) {
      // 创建画笔并设置颜色
      final Paint paint = Paint()..color = _color;
      // 在指定位置绘制一个矩形，矩形大小为 Sliver 的可用宽高
      context.canvas.drawRect(
        Rect.fromLTWH(
          offset.dx,
          offset.dy,
          constraints.crossAxisExtent, // 宽度
          geometry!.paintExtent,       // 可见高度
        ),
        paint,
      );
    }
  }
}

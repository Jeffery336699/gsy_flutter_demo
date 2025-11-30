import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gsy_flutter_demo/main.dart';

/// 固定头部 Sliver，永远固定在顶部，但是只能放到第一个sliver，非第一个有问题
/// 作为了解sliver中pin的原理，简单入手。。
class RenderFixedHeaderSliver extends RenderSliverSingleBoxAdapter {
  double _height;

  RenderFixedHeaderSliver({
    required double height,
    super.child,
  }) : _height = height;

  double get height => _height;

  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    logger.w('pin_sliver:${constraints.toJson()}');
    // 1. 布局子组件
    if (child != null) {
      child!.layout(
        constraints.asBoxConstraints(
          minExtent: _height,
          maxExtent: _height,
        ),
        parentUsesSize: true,
      );
    }

    // 当前 viewport 主轴长度（垂直方向就是可视高度）
    final double viewportExtent = constraints.viewportMainAxisExtent;

    // 这个头部本身永远不随滚动离开视口，它不消耗 scrollExtent。
    // 只是在 viewport 中画出来一块高度为 height 的区域。
    final double paintExtent = height.clamp(0.0, viewportExtent);

    geometry = SliverGeometry(
      paintOrigin: constraints.overlap,
      paintExtent: paintExtent,
      layoutExtent: paintExtent,
      maxPaintExtent: height,
      maxScrollObstructionExtent: height,
      hasVisualOverflow: true,
    );
  }
}

class FixedHeaderSliver extends SingleChildRenderObjectWidget {
  final double height;

  const FixedHeaderSliver({
    super.key,
    required this.height,
    required Widget child,
  }) : super(child: child);

  @override
  RenderFixedHeaderSliver createRenderObject(BuildContext context) {
    return RenderFixedHeaderSliver(height: height);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderFixedHeaderSliver renderObject,
  ) {
    renderObject.height = height;
  }
}

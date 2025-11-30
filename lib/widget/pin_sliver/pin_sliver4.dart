import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class MySimpleSliver extends SingleChildRenderObjectWidget {
  const MySimpleSliver({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMySimpleSliver();
  }
}

class RenderMySimpleSliver extends RenderSliver
    with RenderObjectWithChildMixin<RenderBox> , RenderSliverHelpers {
  @override
  void setupParentData(RenderObject child) {
    // 确保子节点使用 SliverPhysicalParentData
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      // 如果没有子节点，几何信息为空
      geometry = SliverGeometry.zero;
      return;
    }

    // 1. 对子节点进行布局,我们将 Sliver 的约束传递给子节点，但主轴方向是无限的
    child!.layout(
      constraints.asBoxConstraints(),
      parentUsesSize: true,
    );

    // 2. 获取子节点的大小
    final double childExtent = child!.size.height;

    // 3. 计算 Sliver 的几何信息, 计算可见的绘制高度
    final double paintExtent = (childExtent - constraints.scrollOffset).clamp(0.0, childExtent);

    // 计算布局高度，即它在主轴上占据的空间
    final double layoutExtent = (childExtent - constraints.scrollOffset).clamp(0.0, constraints.remainingPaintExtent);

    geometry = SliverGeometry(
      scrollExtent: childExtent, // 总滚动长度
      paintExtent: paintExtent, // 绘制区域
      layoutExtent: layoutExtent, // 布局区域
      maxPaintExtent: childExtent, // 最大绘制长度
      hitTestExtent: paintExtent, // 命中测试区域
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );

    // 4. 设置子节点的绘制偏移
    // childMainAxisPosition 返回子节点相对于 Sliver 起点的偏移
    // 这里子节点从 Sliver 的 (0,0) 开始，所以偏移为 0
    final SliverPhysicalParentData parentData = child!.parentData as SliverPhysicalParentData;
    parentData.paintOffset = Offset(0.0, -constraints.scrollOffset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // 如果有子节点且可见区域大于 0，则进行绘制
    if (child != null && geometry!.paintExtent > 0.0) {
      final SliverPhysicalParentData parentData = child!.parentData as SliverPhysicalParentData;
      // 使用 performLayout 中计算好的 paintOffset 来绘制 child
      context.paintChild(child!, offset + parentData.paintOffset);
    }
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    // 子节点的主轴位置。因为只有一个子节点，它从 0 开始。
    return 0.0;
  }

  @override
  bool hitTestChildren(SliverHitTestResult result, {required double mainAxisPosition, required double crossAxisPosition}) {
    /// 这里才能给出正确的命中测试结果!!
    if (child != null && geometry!.hitTestExtent > 0.0) {
      // 将命中测试委托给子节点
      return result.addWithAxisOffset(
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
        paintOffset: (child!.parentData as SliverPhysicalParentData).paintOffset,
        crossAxisOffset: 0.0,
        mainAxisOffset: 0.0,
        hitTest: (SliverHitTestResult result, { required double mainAxisPosition, required double crossAxisPosition }) {
         return hitTestBoxChild( BoxHitTestResult.wrap(result), child!, mainAxisPosition: mainAxisPosition, crossAxisPosition: crossAxisPosition, ); },
      );
    }
    return false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    // 应用绘制变换
    final SliverPhysicalParentData parentData = child.parentData as SliverPhysicalParentData;
    parentData.applyPaintTransform(transform);
  }
}
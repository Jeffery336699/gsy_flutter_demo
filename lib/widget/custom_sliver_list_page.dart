import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 自定义 SliverList 演示页面
class CustomSliverListPage extends StatefulWidget {
  const CustomSliverListPage({super.key});

  @override
  State<CustomSliverListPage> createState() => _CustomSliverListPageState();
}

class _CustomSliverListPageState extends State<CustomSliverListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom SliverList Demo'),
      ),
      body: Scrollable(
        axisDirection: AxisDirection.down,
        controller: _scrollController,
        viewportBuilder: (BuildContext context, ViewportOffset position) {
          return Viewport(
            axisDirection: AxisDirection.down,
            offset: position,
            slivers: [
              // SliverToBoxAdapter(
              //   child: Container(
              //     height: 100,
              //     color: Colors.blue.shade100,
              //     alignment: Alignment.center,
              //     child: const Text('Header'),
              //   ),
              // ),
              CustomSliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // 模拟一个拥有 50 个元素的列表
                    if (index >= 50) return null;
                    return Container(
                      height: 56,
                      alignment: Alignment.center,
                      color: Colors.lightGreen[100 * (index % 9)],
                      child: Text('Item $index'),
                    );
                  },
                  childCount: 50, // 提供 childCount 有助于优化
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Container(
              //     height: 100,
              //     color: Colors.blue.shade100,
              //     alignment: Alignment.center,
              //     child: const Text('Footer'),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}

/// 自定义 SliverList 组件
/// 职责：创建 RenderObject 并通过 Element 传递 delegate
class CustomSliverList extends SliverMultiBoxAdaptorWidget {
  const CustomSliverList({
    super.key,
    required super.delegate,
  });

  @override
  RenderSliverMultiBoxAdaptor createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return RenderCustomSliverList(childManager: element);
  }
}

/// 自定义 SliverList 的 RenderObject
/// 核心职责：实现子元素的按需布局和几何计算
class RenderCustomSliverList extends RenderSliverMultiBoxAdaptor {
  RenderCustomSliverList({
    required super.childManager,
  });

  double _getChildMainAxisExtent(RenderBox child) {
    return constraints.axis == Axis.vertical ? child.size.height : child.size.width;
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    final double remainingExtent = constraints.remainingCacheExtent;
    final double targetEndScrollOffset = scrollOffset + remainingExtent;

    // 初始化第一个子元素
    if (firstChild == null) {
      if (!addInitialChild(index: 0, layoutOffset: 0.0)) {
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }

    // 确保 firstChild 有正确的 layoutOffset
    var firstChildParentData =
        firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
    firstChildParentData.layoutOffset ??= 0.0;

    // 第一步：布局所有现有子元素
    RenderBox? child = firstChild;
    double endScrollOffset = 0.0;

    while (child != null) {
      child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
      endScrollOffset =
          (child.parentData! as SliverMultiBoxAdaptorParentData).layoutOffset! +
              _getChildMainAxisExtent(child);
      child = childAfter(child);
    }

    // 第二步：向前回收不在缓存区域内的子元素
    int? firstGarbageIndex;
    child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as SliverMultiBoxAdaptorParentData;
      final childExtent = _getChildMainAxisExtent(child);
      final childEndOffset = parentData.layoutOffset! + childExtent;

      if (childEndOffset < scrollOffset) {
        firstGarbageIndex = indexOf(child);
        child = childAfter(child);
      } else {
        break;
      }
    }

    // 执行回收
    if (firstGarbageIndex != null) {
      collectGarbage(firstGarbageIndex, firstGarbageIndex);
    }

    // 如果所有元素都被回收，重新创建
    if (firstChild == null) {
      if (!addInitialChild(index: 0, layoutOffset: 0.0)) {
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
      firstChildParentData =
          firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
      firstChildParentData.layoutOffset = 0.0;

      // 重新布局第一个子元素
      firstChild!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
      endScrollOffset = _getChildMainAxisExtent(firstChild!);
    }

    // 第三步：向后添加子元素
    while (endScrollOffset < targetEndScrollOffset) {
      final newChild = insertAndLayoutChild(
        constraints.asBoxConstraints(),
        after: lastChild,
        parentUsesSize: true,
      );

      if (newChild == null) break;

      final newChildParentData =
          newChild.parentData! as SliverMultiBoxAdaptorParentData;
      newChildParentData.layoutOffset = endScrollOffset;
      endScrollOffset += _getChildMainAxisExtent(newChild);
    }

    // 第四步：回收向后的元素
    int? lastGarbageIndex;
    child = lastChild;
    while (child != null) {
      final parentData = child.parentData! as SliverMultiBoxAdaptorParentData;
      if (parentData.layoutOffset! >= targetEndScrollOffset) {
        lastGarbageIndex = indexOf(child);
        child = childBefore(child);
      } else {
        break;
      }
    }

    // 执行回收
    if (lastGarbageIndex != null) {
      collectGarbage(lastGarbageIndex, lastGarbageIndex);
    }

    // 计算几何信息
    if (firstChild == null) {
      geometry = SliverGeometry.zero;
      childManager.didFinishLayout();
      return;
    }

    final firstIndex = indexOf(firstChild!);
    final lastIndex = indexOf(lastChild!);
    final firstChildData =
        firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
    final lastChildData =
        lastChild!.parentData! as SliverMultiBoxAdaptorParentData;

    final leadingScrollOffset = firstChildData.layoutOffset!;
    final trailingScrollOffset =
        lastChildData.layoutOffset! + _getChildMainAxisExtent(lastChild!);

    final estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
      constraints,
      firstIndex: firstIndex,
      lastIndex: lastIndex,
      leadingScrollOffset: leadingScrollOffset,
      trailingScrollOffset: trailingScrollOffset,
    );

    final paintExtent = calculatePaintOffset(
      constraints,
      from: leadingScrollOffset,
      to: trailingScrollOffset,
    );

    final cacheExtent = calculateCacheOffset(
      constraints,
      from: leadingScrollOffset,
      to: trailingScrollOffset,
    );

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      hasVisualOverflow: trailingScrollOffset > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );

    childManager.didFinishLayout();
  }
}


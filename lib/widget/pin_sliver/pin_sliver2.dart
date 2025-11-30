import 'package:flutter/material.dart';
import 'dart:math' as math;

class MySliverPersistentHeader extends StatelessWidget {
  final double minHeight;
  final double maxHeight;

  const MySliverPersistentHeader({
    super.key,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    /// 最终的renderObject是_RenderSliverPinnedPersistentHeaderForWidgets,
    /// 一个RenderSliver的renderObject就行
    return SliverPersistentHeader(
      pinned: true,
      delegate: MySliverPersistentHeaderDelegate(
        minHeight: minHeight,
        maxHeight: maxHeight,
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;

  MySliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build( BuildContext context, double shrinkOffset, bool overlapsContent) {
    print('==>> shrinkOffset: $shrinkOffset, maxExtent: $maxExtent, minExtent: $minExtent');
    final Widget widget=Container(
      alignment: Alignment.centerLeft,
      height: math.max(minExtent, maxExtent - shrinkOffset),
      color: Colors.redAccent,
      child: Text('text'),
    );
    return widget;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

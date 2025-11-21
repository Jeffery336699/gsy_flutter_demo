import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyFlexibleSpaceHeaderOpacity extends SingleChildRenderObjectWidget {
  const MyFlexibleSpaceHeaderOpacity(
      {this.opacity = 0.5, required super.child, this.alwaysIncludeSemantics = true, super.key});

  final double opacity;
  final bool alwaysIncludeSemantics;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderFlexibleSpaceHeaderOpacity(opacity: opacity, alwaysIncludeSemantics: alwaysIncludeSemantics);
  }

  @override
  void updateRenderObject(BuildContext context, covariant _RenderFlexibleSpaceHeaderOpacity renderObject) {
    renderObject
      ..alwaysIncludeSemantics = alwaysIncludeSemantics
      ..opacity = opacity;
  }
}

class _RenderFlexibleSpaceHeaderOpacity extends RenderOpacity {
  _RenderFlexibleSpaceHeaderOpacity({super.opacity, super.alwaysIncludeSemantics});

  @override
  bool get isRepaintBoundary => false; // 这里可以改为true试试

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    if (opacity == 0) {
      layer = null;
      return;
    }
    assert(needsCompositing);
    layer = context.pushOpacity(offset, (opacity * 255).round(), super.paint, oldLayer: null);
    assert(() {
      layer!.debugCreator = debugCreator;
      return true;
    }());
  }
}

import 'package:flutter/material.dart';
import 'package:gsy_flutter_demo/widget/drop_select_menu/drop_select_object.dart';

import 'drop_select_controller.dart';

abstract class DropSelectWidget extends StatefulWidget {
  final DropSelectController? controller;

  const DropSelectWidget({super.key, this.controller});

  @override
  DropSelectState<DropSelectWidget> createState();
}

abstract class DropSelectState<T extends DropSelectWidget> extends State<T> {
  DropSelectController? controller;

  @override
  void dispose() {
    controller?.removeListener(_onEvent);
    super.dispose();
  }

  @override
  void didChangeDependencies() {

    controller ??= widget.controller ?? DropSelectMenuContainer.of(context);
    print('$hashCode====> didChangeDependencies controller.hasListeners=${controller?.hasListeners}');
    controller?.addListener(_onEvent);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    // 由于State是跨帧的，当外部widget配置更新时，我这里处理controller变化的情况
    // 在当前state<->Element是绑定关系，在widget（配置）更新时，state对象不会变化
    // 所以就需要对复用的state对象中的controller（数据）进行更新，新的数据在widget中
    if (widget.controller != null) {
      controller?.removeListener(_onEvent);
      controller = widget.controller;
      controller?.addListener(_onEvent);
    }
    // 在 Widget 的生命周期中：
    //
    // 1.  **首次创建时**：`didChangeDependencies` 会在 `initState` 之后被调用，而 `didUpdateWidget` **不会**被调用。
    // 2.  **后续更新时**：当 Widget 的配置发生变化时，`didUpdateWidget` 会先被调用。如果该 Widget 依赖的 `InheritedWidget`
    //      发生了变化，那么 `didChangeDependencies` 会在 `didUpdateWidget` **之后**被调用。
    //
    // 总结来说，在更新流程中，`didUpdateWidget` 先于 `didChangeDependencies`。
    super.didUpdateWidget(oldWidget);
  }

  cloneDataList(List<DropSelectObject> form, List<DropSelectObject> to) {
    to.clear();
    for (var item in form) {
      to.add(item.clone());
    }
  }

  resetList(List<DropSelectObject> list) {
    for (var item in list) {
      item.selected = false;
      item.children?.forEach((child) {
        child.selected = false;
      });
    }
    selectChildFirst(list);
  }

  selectChildFirst(List<DropSelectObject> list) {
    for (var item in list) {
      if (item.children != null) {
        item.children![0].selected = true;
      }
    }
  }

  void _onEvent() {
    onEvent(controller!.event);
  }

  void onEvent(DropSelectEvent? event);
}

class DropSelectMenuContainer extends StatefulWidget {
  const DropSelectMenuContainer({
    super.key,
    required this.child,
    this.onSelected,
  });

  final Widget child;

  final DropOnSelected? onSelected;

  @override
  _DropSelectMenuContainerState createState() =>
      _DropSelectMenuContainerState();

  static DropSelectController? of(BuildContext context) {
    final _DropSelectMenuInherited? scope =
        context.dependOnInheritedWidgetOfExactType<_DropSelectMenuInherited>();
    return scope?.controller;
  }
}

class _DropSelectMenuContainerState extends State<DropSelectMenuContainer>
    with SingleTickerProviderStateMixin {
  DropSelectController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = DropSelectController();
    _controller!.addListener(_onController);
  }

  void _onController() {
    switch (_controller!.event) {
      case DropSelectEvent.SELECT:
        if (widget.onSelected == null) return;
        widget.onSelected!(
          data: _controller!.data,
          menuIndex: _controller!.menuIndex,
          index: _controller!.index,
        );

        break;
      case DropSelectEvent.ACTIVE:
        break;
      case DropSelectEvent.HIDE:
      default:
        break;
    }
  }

  @override
  void dispose() {
    _controller!.removeListener(_onController);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DropSelectMenuInherited(
      controller: _controller,
      enable: TickerMode.of(context),
      child: widget.child,
    );
  }
}

class _DropSelectMenuInherited extends InheritedWidget {
  const _DropSelectMenuInherited(
      {this.controller, this.enable, required super.child});

  final bool? enable;
  final DropSelectController? controller;

  @override
  bool updateShouldNotify(_DropSelectMenuInherited old) {
    return enable != old.enable || controller != old.controller;
  }
}

class DropSelectMenuBuilder {
  final WidgetBuilder builder;
  final double? height;

  DropSelectMenuBuilder({required this.builder, this.height});
}

typedef DropOnSelected = Function({int? menuIndex, int? index, dynamic data});

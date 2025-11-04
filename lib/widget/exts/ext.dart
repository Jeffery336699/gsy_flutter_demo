import 'package:flutter/material.dart';

extension ListStringExtension on List<String> {
  /// 将满足条件的元素移到列表最前面
  /// [condition] 判断条件
  List<String> moveToFrontIf(bool Function(String) condition) {
    var list = List<String>.from(this);
    final matchedItems = list.where(condition).toList();
    list.removeWhere(condition);
    list.insertAll(0, matchedItems);
    return list;
  }

  /// 增加一个反转的方法
  List<String> reversedList() {
    return List<String>.from(reversed);
  }
}

/// 拓展一个为任意Widget添加边框的拓展
/// /// 拓展一个为任意Widget添加边款的拓展方法
/// 拓展一个为任意Widget添加边款的拓展方法
extension WidgetBorderExtension on Widget {
  /// 统一边框
  Widget withBorder({
    Color color = const Color(0xFFDDDDDD),
    double width = 1,
    double radius = 0,
    BorderStyle style = BorderStyle.solid,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: color, width: width, style: style),
        borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
      ),
      child: this,
    );
  }

  /// 自定义各向边框与圆角
  Widget withCustomBorder({
    Border? border,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }
}

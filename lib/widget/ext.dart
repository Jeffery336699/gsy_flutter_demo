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
# 左侧分类右侧详情联动列表 - 快速开始

## 🎯 功能概述

实现了一个类似电商 APP 的分类详情页面：
- 左侧：分类导航列表
- 右侧：商品详情列表
- 支持双向联动和滚动回调

## 🚀 快速运行

### 1. 启动应用
```bash
flutter run
```

### 2. 进入页面
在首页列表中找到并点击：
```
"左侧分类右侧详情联动列表"
```

## 💡 使用示例

### 基础使用
```dart
import 'package:gsy_flutter_demo/widget/vp_list_demo_page.dart';

CategoryDetailListView(
  onCategoryChanged: (index, name) {
    print('当前分类: $name');
  },
)
```

### 完整示例
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoryDetailListView(
        onCategoryChanged: (categoryIndex, categoryName) {
          // 分类切换时触发
          print('切换到分类 $categoryIndex: $categoryName');
          
          // 可以在这里做：
          // 1. 统计埋点
          // 2. 加载更多数据
          // 3. 显示提示信息
          // 4. 更新其他UI状态
        },
      ),
    );
  }
}
```

## 📋 核心特性

### 1. 自动同步
- ✅ 点击左侧 → 右侧自动滚动
- ✅ 滚动右侧 → 左侧自动高亮

### 2. 智能回调
- ✅ 分类切换时自动触发
- ✅ 提供分类索引和名称
- ✅ 防止重复触发

### 3. 流畅动画
- ✅ 300ms 平滑过渡
- ✅ Ease-in-out 缓动曲线
- ✅ 左侧智能居中显示

### 4. 无依赖
- ✅ 纯 Flutter 原生实现
- ✅ 不需要任何第三方库
- ✅ 代码简洁易懂

## 🎨 自定义数据

修改 `lib/widget/vp_list_demo_page.dart` 中的数据：

```dart
final List<CategoryData> _categories = [
  CategoryData(
    name: '水果蔬菜',
    items: ['苹果', '香蕉', '西瓜', '葡萄', '橙子'],
  ),
  CategoryData(
    name: '肉禽蛋品',
    items: ['猪肉', '牛肉', '鸡蛋', '鸭蛋'],
  ),
  CategoryData(
    name: '海鲜水产',
    items: ['三文鱼', '龙虾', '螃蟹', '虾'],
  ),
  // 添加更多分类...
];
```

## 🔧 关键参数说明

### 分类项高度
```dart
final double _categoryItemHeight = 120.0;  // 右侧商品项高度
```

### 分类标题高度
```dart
final double _categoryTitleHeight = 40.0;  // 分类标题高度
```

### 左侧分类宽度
```dart
Widget _buildCategoryList() {
  return Container(
    width: 100,  // 修改这里调整左侧宽度
    // ...
  );
}
```

### 滚动动画时长
```dart
_detailScrollController.animateTo(
  _categoryPositions[index],
  duration: const Duration(milliseconds: 300),  // 修改这里
  curve: Curves.easeInOut,
);
```

## 📱 效果预览

### 界面布局
```
┌─────────────────────────────────┐
│  分类详情联动                    │
├─────────┬───────────────────────┤
│ 热门推荐 │ 热门推荐                │
│         ├───────────────────────┤
│ 新品上市 │ 📦 热门商品 1   ¥99.00 │
│         │ 📦 热门商品 2   ¥109.00│
│ 电子产品 │ 📦 热门商品 3   ¥119.00│
│         │                        │
│ 服装鞋包 │ 新品上市                │
│         ├───────────────────────┤
│ 食品饮料 │ 📦 新品 1       ¥99.00 │
│         │ 📦 新品 2       ¥109.00│
│ 美妆护肤 │                        │
│         │                        │
│ 运动户外 │                        │
│         │                        │
└─────────┴───────────────────────┘
```

## 🎯 实现原理

### 1. 位置计算
```dart
void _calculateCategoryPositions() {
  // 计算每个分类在右侧列表中的起始位置
  // 用于快速定位和滚动
}
```

### 2. 滚动监听
```dart
void _onDetailScroll() {
  // 监听右侧滚动
  // 根据滚动位置找到当前分类
  // 更新左侧选中状态并触发回调
}
```

### 3. 点击跳转
```dart
void _onCategoryTap(int index) {
  // 点击左侧分类
  // 滚动右侧列表到对应位置
  // 使用标志位避免循环触发
}
```

## ⚠️ 常见问题

### Q: 如何修改分类数据？
A: 编辑 `_categories` 列表，添加 `CategoryData` 对象

### Q: 如何调整滚动速度？
A: 修改 `animateTo` 方法的 `duration` 参数

### Q: 如何获取当前选中的分类？
A: 通过 `onCategoryChanged` 回调获取

### Q: 如何自定义UI样式？
A: 修改 `_buildCategoryList` 和 `_buildDetailList` 方法

## 📚 相关文档

- 使用说明：`category_detail_usage_example.md`
- 测试指南：`category_detail_test_guide.md`
- 源码文件：`vp_list_demo_page.dart`

## ✅ 完成清单

- [x] 左侧分类列表
- [x] 右侧详情列表
- [x] 双向滚动联动
- [x] 滚动回调通知
- [x] 平滑动画效果
- [x] 防止循环触发
- [x] 无第三方依赖
- [x] 代码注释完善
- [x] 文档说明完整

---

**现在你可以运行应用并查看效果了！** 🎉


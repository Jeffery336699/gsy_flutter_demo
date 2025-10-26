# 动态高度分类详情联动 - 快速使用指南

## 🚀 运行方式

1. 启动应用:
   ```bash
   flutter run
   ```

2. 在首页列表中找到并点击:
   ```
   "分类详情联动-动态高度"
   ```

## 🎯 查看效果

滚动右侧列表，你会看到：
- ✅ 商品描述长度不同，高度自动适应
- ✅ 左侧分类自动高亮当前可见的分类
- ✅ 点击左侧分类，右侧自动滚动到对应位置
- ✅ 控制台输出分类切换信息

## 📊 与固定高度版本对比

| 版本 | 路由名 | 特点 |
|------|--------|------|
| 固定高度 | "左侧分类右侧详情联动列表" | 商品高度固定120px |
| 动态高度 | "分类详情联动-动态高度" | 商品高度根据描述自适应 |

## 💡 核心代码

### 1. 获取实际渲染高度

```dart
///等待首次渲染完成
WidgetsBinding.instance.addPostFrameCallback((_) {
  ///通过 GlobalKey 获取 RenderBox
  final RenderBox? renderBox =
      _categoryKeys[i].currentContext?.findRenderObject() as RenderBox?;
  
  if (renderBox != null) {
    ///获取实际渲染高度
    double actualHeight = renderBox.size.height;
    currentPosition += actualHeight;
  }
});
```

### 2. 商品项自适应高度

```dart
///商品描述不设置固定高度，自动换行
Text(
  item.description,
  maxLines: 5,
  overflow: TextOverflow.ellipsis,
)
```

## 🔧 自定义数据

修改 `lib/widget/dynamic_height_category_list.dart`:

```dart
final List<DynamicCategoryData> _categories = [
  DynamicCategoryData(
    name: '你的分类',
    items: [
      ProductItem(
        name: '商品1',
        description: '短描述',
      ),
      ProductItem(
        name: '商品2',
        description: '这是一个很长很长的描述信息...',
      ),
    ],
  ),
];
```

## 📁 文件位置

- **实现文件**: `lib/widget/dynamic_height_category_list.dart`
- **详细说明**: `DYNAMIC_HEIGHT_CATEGORY_LIST_README.md`

## 🎨 界面效果

```
┌─────────────────────────────────┐
│  动态高度分类详情联动            │
├─────────┬───────────────────────┤
│ 热门推荐 │ 热门推荐                │
│ ▌       ├───────────────────────┤
│         │ 📦 热门商品 1           │
│ 新品上市 │ 这是简短描述            │
│         │ ¥99.00                 │
│ 电子产品 ├───────────────────────┤
│         │ 📦 热门商品 2           │
│ 服装鞋包 │ 这是一个比较长的商品    │
│         │ 描述，包含了更多的产品  │
│ 食品饮料 │ 信息，让用户能够更好    │
│         │ 地了解这个商品的特点    │
│         │ ¥109.00                │
└─────────┴───────────────────────┘
```

## ⚡ 性能说明

- ✅ 使用 ListView.builder，按需渲染
- ✅ GlobalKey 只在初始化时创建一次
- ✅ 位置计算只在首次布局完成后执行一次
- ✅ 滚动性能与固定高度版本相当

## 🆚 何时使用

**使用动态高度版本**：
- ✅ 商品描述长度差异大
- ✅ 需要完整显示内容
- ✅ 用户体验优先

**使用固定高度版本**：
- ✅ 商品信息统一
- ✅ 追求极致性能
- ✅ 列表项数量巨大

## 🎓 技术要点

1. **GlobalKey**: 获取 Widget 的 RenderBox
2. **addPostFrameCallback**: 等待布局完成
3. **RenderBox.size**: 获取实际渲染尺寸
4. **Column + Expanded**: 实现自适应布局

## 🐛 注意事项

1. 等待 `_isLayoutCalculated` 为 true 后再响应点击和滚动
2. 如果数据动态更新，需要重新计算位置
3. 如果有网络图片，图片加载完成后需要重新计算

## ✅ 完成状态

- ✅ 实现完成
- ✅ 测试通过
- ✅ 无编译错误
- ✅ 无第三方依赖
- ✅ 文档完善

---

**立即运行查看效果吧！** 🎉


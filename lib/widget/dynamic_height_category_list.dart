import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///支持动态高度的左侧分类右侧详情联动列表
///商品项高度根据内容自适应
class DynamicHeightCategoryListView extends StatefulWidget {
  ///当右侧滚动到某个分类时的回调
  final Function(int categoryIndex, String categoryName)? onCategoryChanged;

  const DynamicHeightCategoryListView({super.key, this.onCategoryChanged});

  @override
  _DynamicHeightCategoryListViewState createState() =>
      _DynamicHeightCategoryListViewState();
}

class _DynamicHeightCategoryListViewState
    extends State<DynamicHeightCategoryListView> {
  ///左侧分类控制器
  final ScrollController _categoryScrollController = ScrollController();

  ///右侧详情控制器
  final ScrollController _detailScrollController = ScrollController();

  ///当前选中的分类索引
  int _selectedCategoryIndex = 0;

  ///是否是左侧点击触发的滚动
  bool _isClickScroll = false;

  ///每个分类区域的 GlobalKey，用于获取实际渲染高度
  final List<GlobalKey> _categoryKeys = [];

  ///每个分类在右侧列表中的实际位置（动态计算）
  final List<double> _categoryPositions = [];

  ///是否已经完成首次布局测量
  bool _isLayoutCalculated = false;

  ///模拟分类数据，商品带有不同长度的描述信息
  final List<DynamicCategoryData> _categories = [
    DynamicCategoryData(
      name: '热门推荐',
      items: List.generate(
        8,
        (i) => ProductItem(
          name: '热门商品 ${i + 1}',
          description: i % 3 == 0
              ? '这是一个简短的商品描述'
              : i % 3 == 1
                  ? '这是一个比较长的商品描述，包含了更多的产品信息，让用户能够更好地了解这个商品的特点和优势'
                  : '这是一个超级超级长的商品描述，详细介绍了产品的各种特性、使用方法、注意事项等内容，帮助用户做出更好的购买决策。商品质量上乘，值得信赖。',
        ),
      ),
    ),
    DynamicCategoryData(
      name: '新品上市',
      items: List.generate(
        5,
        (i) => ProductItem(
          name: '新品 ${i + 1}',
          description: i % 2 == 0 ? '全新上市，限时优惠' : '品质保证，新款热销中，欢迎选购！',
        ),
      ),
    ),
    DynamicCategoryData(
      name: '电子产品',
      items: List.generate(
        10,
        (i) => ProductItem(
          name: '电子产品 ${i + 1}',
          description: i % 4 == 0
              ? '高性能电子产品'
              : i % 4 == 1
                  ? '采用最新技术，性能强劲，续航持久'
                  : i % 4 == 2
                      ? '智能科技产品，操作简单方便，适合全家使用，性价比超高'
                      : '顶级配置，旗舰性能，完美体验。搭载先进处理器，运行流畅不卡顿，拍照效果出众，电池容量大。',
        ),
      ),
    ),
    DynamicCategoryData(
      name: '服装鞋包',
      items: List.generate(
        7,
        (i) => ProductItem(
          name: '服装 ${i + 1}',
          description: i % 2 == 0 ? '时尚舒适' : '优质面料，精致做工，穿着舒适透气，彰显品味',
        ),
      ),
    ),
    DynamicCategoryData(
      name: '食品饮料',
      items: List.generate(
        6,
        (i) => ProductItem(
          name: '食品 ${i + 1}',
          description: i % 3 == 0 ? '健康美味' : i % 3 == 1 ? '精选食材，营养丰富，口感极佳' : '绿色有机食品，无添加，健康安全',
        ),
      ),
    ),
  ];

  ///分类标题的固定高度
  final double _categoryTitleHeight = 40.0;

  @override
  void initState() {
    super.initState();
    debugFillProperties(DiagnosticPropertiesBuilder properties) {
      super.debugFillProperties(properties);
      properties.add(IntProperty(
          'selectedCategoryIndex', _selectedCategoryIndex,
          defaultValue: 0));
      properties.add(FlagProperty('isClickScroll',
          value: _isClickScroll, ifTrue: 'isClickScroll'));
      properties.add(FlagProperty('isLayoutCalculated',
          value: _isLayoutCalculated, ifTrue: 'isLayoutCalculated'));
    }
    ///为每个分类创建 GlobalKey
    for (int i = 0; i < _categories.length; i++) {
      _categoryKeys.add(GlobalKey());
    }
    _detailScrollController.addListener(_onDetailScroll);
    // 这两种方式不等价，存在重要区别：
    // 主要差异
    // WidgetsBinding.instance.addPostFrameCallback（被注释的方式）
    //    时机：在当前帧（Frame）的所有布局和绘制工作完成之后才执行回调。
    //    保证：此时，所有的 Widget 都已经完成了 build、layout 和 paint 过程。因此，通过 GlobalKey 去获取 RenderObject 和它的尺寸（size）是安全且准确的。
    //    用途：这是 Flutter 官方推荐的、用于在 Widget 首次渲染完成后执行代码（例如获取尺寸、位置）的标准方法。
    // Future(callback)（当前使用的方式）
    //    时机：将回调添加到一个微任务队列 (Microtask Queue) 中。它会在当前事件循环（Event Loop）的同步代码执行完毕后立即执行，但通常在第一帧渲染完成之前。
    //    保证：它不保证 Widget 已经完成布局和绘制。在 initState 中使用时，它会在 build 方法被调用之前或期间执行，此时 RenderObject 树可能还没有完全建立。
    //    风险：在这种情况下调用 _calculateCategoryPositionsAfterLayout，_categoryKeys[i].currentContext?.findRenderObject() 很有可能返回 null，
    //    因为对应的 Widget 还没有被渲染到屏幕上。
    ///等待首次渲染完成后计算位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateCategoryPositionsAfterLayout();
    });

    // Future((){
    //   _calculateCategoryPositionsAfterLayout();
    // });
    Future.microtask(() => null);
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _detailScrollController.dispose();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    /// 运行应用 (Debug 模式)
    /// 打开 Flutter DevTools，切换到 "Flutter Inspector" 标签页
    /// 在 Widget 树中选中 _DynamicHeightCategoryListViewState
    ///
    /// 在右侧 "Details Tree" 面板中查看:
    /// selectedCategoryIndex: 当前选中的分类索引
    /// isClickScroll: 是否正在执行点击触发的滚动
    /// isLayoutCalculated: 布局是否已完成计算
    /// categoryPositions: 每个分类的实际位置数组
    /// 当您滚动列表或点击分类时，这些值会实时更新，让您可以直观地观察状态变化，极大提升调试效率
    properties.add(IntProperty('selectedCategoryIndex', _selectedCategoryIndex,
        defaultValue: 0));
    properties.add(FlagProperty('isClickScroll',
        value: _isClickScroll, ifTrue: 'isClickScroll'));
    properties.add(FlagProperty('isLayoutCalculated',
        value: _isLayoutCalculated, ifTrue: 'isLayoutCalculated'));
    // 添加对分类位置列表的调试输出
    properties.add(
        IterableProperty<double>('categoryPositions', _categoryPositions));
  }

  ///在布局完成后计算每个分类的实际位置
  ///这是支持动态高度的关键方法
  void _calculateCategoryPositionsAfterLayout() {
    _categoryPositions.clear();
    double currentPosition = 0;

    for (int i = 0; i < _categoryKeys.length; i++) {
      _categoryPositions.add(currentPosition);

      ///获取当前分类区域的实际渲染高度
      final RenderBox? renderBox =
          _categoryKeys[i].currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        ///使用实际渲染高度累加位置
        currentPosition += renderBox.size.height;
      } else {
        ///如果无法获取（极少情况），使用估算值
        currentPosition += _categoryTitleHeight +
            (_categories[i].items.length * 150); ///估算每项150高度
      }
    }

    setState(() {
      _isLayoutCalculated = true;
    });
  }

  ///监听右侧详情列表的滚动
  void _onDetailScroll() {
    if (_isClickScroll || !_isLayoutCalculated) return;

    final scrollOffset = _detailScrollController.offset;

    ///根据滚动位置找到当前应该高亮的分类
    int newIndex = 0;
    for (int i = 0; i < _categoryPositions.length; i++) {
      if (scrollOffset >= _categoryPositions[i]) {
        newIndex = i;
      } else {
        break;
      }
    }

    ///如果分类索引发生变化，更新选中状态
    if (newIndex != _selectedCategoryIndex) {
      setState(() {
        _selectedCategoryIndex = newIndex;
      });

      ///滚动左侧分类列表，让选中项可见
      _scrollCategoryToVisible(newIndex);

      ///触发回调，通知外部分类已改变
      widget.onCategoryChanged?.call(newIndex, _categories[newIndex].name);
    }
  }

  ///滚动左侧分类列表，确保选中项可见
  void _scrollCategoryToVisible(int index) {
    if (!_categoryScrollController.hasClients) return;

    const categoryItemHeight = 60.0;
    final targetOffset = index * categoryItemHeight;
    final viewportHeight =
        _categoryScrollController.position.viewportDimension;

    if (targetOffset < _categoryScrollController.offset ||
        targetOffset >
            _categoryScrollController.offset +
                viewportHeight -
                categoryItemHeight) {
      _categoryScrollController.animateTo(
        (targetOffset - viewportHeight / 2 + categoryItemHeight / 2).clamp(
          0.0,
          _categoryScrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  ///点击左侧分类，滚动右侧列表到对应位置
  void _onCategoryTap(int index) {
    if (!_isLayoutCalculated) return;

    setState(() {
      _selectedCategoryIndex = index;
    });

    _isClickScroll = true;

    _detailScrollController
        .animateTo(
      _categoryPositions[index],
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _isClickScroll = false;
      });
    });

    widget.onCategoryChanged?.call(index, _categories[index].name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("动态高度分类详情联动"),
      ),
      body: Row(
        children: [
          ///左侧分类列表
          _buildCategoryList(),

          ///分隔线
          Container(
            width: 1,
            color: Colors.grey[300],
          ),

          ///右侧详情列表
          Expanded(
            child: _buildDetailList(),
          ),
        ],
      ),
    );
  }

  ///构建左侧分类列表
  Widget _buildCategoryList() {
    return Container(
      width: 100,
      color: Colors.grey[100],
      child: ListView.builder(
        controller: _categoryScrollController,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () => _onCategoryTap(index),
            child: Container(
              height: 60,
              color: isSelected ? Colors.white : Colors.transparent,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  if (isSelected)
                    Positioned(
                      left: 0,
                      top: 15,
                      bottom: 15,
                      child: Container(
                        width: 3,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _categories[index].name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ///构建右侧详情列表（支持动态高度）
  Widget _buildDetailList() {
    return ListView.builder(
      controller: _detailScrollController,
      itemCount: _categories.length,
      itemBuilder: (context, categoryIndex) {
        final category = _categories[categoryIndex];

        ///使用 Column 包裹每个分类的内容，并添加 GlobalKey
        ///这样可以获取整个分类区域的实际渲染高度
        return Container(
          key: _categoryKeys[categoryIndex],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///分类标题
              Container(
                height: _categoryTitleHeight,
                color: Colors.grey[200],
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              ///该分类下的所有商品（高度自适应）
              ...category.items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildProductItem(item, index);
              }),
            ],
          ),
        );
      },
    );
  }

  ///构建商品项（高度根据描述内容自适应）
  Widget _buildProductItem(ProductItem item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, ///关键：顶部对齐
        children: [
          ///商品图片占位
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 12),

          ///商品信息（高度自适应）
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///商品名称
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                ///商品描述（自动换行，高度自适应）
                ///不设置固定高度，让 Text 根据内容自动撑开
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  maxLines: 5, ///最多5行
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                ///价格
                Text(
                  '¥${(index * 10 + 99).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///动态高度分类的数据模型
class DynamicCategoryData {
  final String name;
  final List<ProductItem> items;

  DynamicCategoryData({required this.name, required this.items});
}

///商品数据模型（包含描述信息）
class ProductItem {
  final String name;
  final String description;

  ProductItem({required this.name, required this.description});
}


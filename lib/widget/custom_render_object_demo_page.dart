import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 自定义 RenderObject 演示页面
/// 实现一个自定义的 Column 布局
class CustomRenderObjectDemoPage extends StatefulWidget {
  const CustomRenderObjectDemoPage({super.key});

  @override
  State<CustomRenderObjectDemoPage> createState() =>
      _CustomRenderObjectDemoPageState();
}

class _CustomRenderObjectDemoPageState
    extends State<CustomRenderObjectDemoPage> {
  double _spacing = 10.0;
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义 RenderObject 演示'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildControlPanel(),
            const SizedBox(height: 20),
            const Text(
              '自定义 Column 效果：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomColumn(
                spacing: _spacing,
                mainAxisAlignment: _mainAxisAlignment,
                crossAxisAlignment: _crossAxisAlignment,
                children: [
                  _buildColorBox('Box 1', Colors.red, 80, 80),
                  _buildColorBox('Box 2', Colors.green, 120, 60),
                  _buildColorBox('Box 3', Colors.blue, 100, 100),
                  _buildColorBox('Box 4', Colors.orange, 90, 70),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '对比：原生 Column 效果：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: _mainAxisAlignment,
                crossAxisAlignment: _crossAxisAlignment,
                children: [
                  _buildColorBox('Box 1', Colors.red, 80, 80),
                  SizedBox(height: _spacing),
                  _buildColorBox('Box 2', Colors.green, 120, 60),
                  SizedBox(height: _spacing),
                  _buildColorBox('Box 3', Colors.blue, 100, 100),
                  SizedBox(height: _spacing),
                  _buildColorBox('Box 4', Colors.orange, 90, 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '控制面板',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('间距: ${_spacing.toInt()}'),
            Slider(
              value: _spacing,
              min: 0,
              max: 50,
              divisions: 50,
              onChanged: (value) {
                setState(() {
                  _spacing = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text('主轴对齐方式:'),
            Wrap(
              spacing: 8,
              children: [
                _buildAlignmentChip(
                  'Start',
                  MainAxisAlignment.start,
                  _mainAxisAlignment == MainAxisAlignment.start,
                  () {
                    setState(() {
                      _mainAxisAlignment = MainAxisAlignment.start;
                    });
                  },
                ),
                _buildAlignmentChip(
                  'Center',
                  MainAxisAlignment.center,
                  _mainAxisAlignment == MainAxisAlignment.center,
                  () {
                    setState(() {
                      _mainAxisAlignment = MainAxisAlignment.center;
                    });
                  },
                ),
                _buildAlignmentChip(
                  'End',
                  MainAxisAlignment.end,
                  _mainAxisAlignment == MainAxisAlignment.end,
                  () {
                    setState(() {
                      _mainAxisAlignment = MainAxisAlignment.end;
                    });
                  },
                ),
                _buildAlignmentChip(
                  'SpaceBetween',
                  MainAxisAlignment.spaceBetween,
                  _mainAxisAlignment == MainAxisAlignment.spaceBetween,
                  () {
                    setState(() {
                      _mainAxisAlignment = MainAxisAlignment.spaceBetween;
                    });
                  },
                ),
                _buildAlignmentChip(
                  'SpaceAround',
                  MainAxisAlignment.spaceAround,
                  _mainAxisAlignment == MainAxisAlignment.spaceAround,
                  () {
                    setState(() {
                      _mainAxisAlignment = MainAxisAlignment.spaceAround;
                    });
                  },
                ),
                _buildAlignmentChip(
                  'SpaceEvenly',
                  MainAxisAlignment.spaceEvenly,
                  _mainAxisAlignment == MainAxisAlignment.spaceEvenly,
                  () {
                    setState(() {
                      _mainAxisAlignment = MainAxisAlignment.spaceEvenly;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('交叉轴对齐方式:'),
            Wrap(
              spacing: 8,
              children: [
                _buildCrossAlignmentChip(
                  'Start',
                  CrossAxisAlignment.start,
                  _crossAxisAlignment == CrossAxisAlignment.start,
                  () {
                    setState(() {
                      _crossAxisAlignment = CrossAxisAlignment.start;
                    });
                  },
                ),
                _buildCrossAlignmentChip(
                  'Center',
                  CrossAxisAlignment.center,
                  _crossAxisAlignment == CrossAxisAlignment.center,
                  () {
                    setState(() {
                      _crossAxisAlignment = CrossAxisAlignment.center;
                    });
                  },
                ),
                _buildCrossAlignmentChip(
                  'End',
                  CrossAxisAlignment.end,
                  _crossAxisAlignment == CrossAxisAlignment.end,
                  () {
                    setState(() {
                      _crossAxisAlignment = CrossAxisAlignment.end;
                    });
                  },
                ),
                _buildCrossAlignmentChip(
                  'Stretch',
                  CrossAxisAlignment.stretch,
                  _crossAxisAlignment == CrossAxisAlignment.stretch,
                  () {
                    setState(() {
                      _crossAxisAlignment = CrossAxisAlignment.stretch;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignmentChip(
    String label,
    MainAxisAlignment alignment,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildCrossAlignmentChip(
    String label,
    CrossAxisAlignment alignment,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildColorBox(String text, Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// 自定义 Column Widget
class CustomColumn extends MultiChildRenderObjectWidget {
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomColumn({
    super.key,
    required super.children,
    this.spacing = 0.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn(
      spacing: spacing,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCustomColumn renderObject) {
    renderObject
      ..spacing = spacing
      ..mainAxisAlignment = mainAxisAlignment
      ..crossAxisAlignment = crossAxisAlignment;
  }
}

/// 自定义 RenderObject - 实现类似 Column 的布局
class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData> {
  /**
   * `ContainerRenderObjectMixin<ChildType, ParentDataType>` 是一个为 `RenderObject` 提供管理子节点列表核心功能的混入类。

      它的主要作用是：

      1.  **管理子节点链表**：它实现了一个双向链表来维护子 `RenderObject`。这让你能够通过 `firstChild`、`lastChild` 访问第一个和最后一个子节点，
            并通过子节点的 `parentData` 中的 `nextSibling` 和 `previousSibling` 来遍历所有子节点。
      2.  **提供子节点操作方法**：它提供了如 `add`、`remove`、`move`、`visitChildren` 等方法，用于在渲染树中添加、删除、移动和遍历子节点。
      3.  **关联 ParentData**：它与 `ParentData` 协同工作。`ParentDataType`（在此例中是 `FlexParentData`）用于存储父节点需要
            附加到每个子节点上的信息，比如兄弟节点指针（`nextSibling`），这对于遍历至关重要。

      ### 实战场景

      在实战中，当你需要创建一个可以包含多个子组件、并且需要自定义其布局逻辑的 Widget 时，就会用到 `ContainerRenderObjectMixin`。

      这通常发生在你创建自定义的 `MultiChildRenderObjectWidget` 时，其对应的 `RenderObject` 需要：

   *   接收一个 `children` 列表。
   *   在 `performLayout` 方法中，测量（`layout`）并定位（设置 `parentData.offset`）每一个子节点。
   *   在 `paint` 方法中，绘制所有子节点。

   ** 简单来说，任何时候你想发明一种新的、Flutter 尚未提供的多子元素布局方式（例如瀑布流、环形布局、或者像示例中这样带有特殊间距逻辑的列布局），
   * 你创建的 `RenderObject` 都会使用 `ContainerRenderObjectMixin` 来处理基础的子节点管理工作。**
   * -------------------------------------------------------------------------------------
   * `RenderBoxContainerDefaultsMixin<RenderBox, FlexParentData>` 是一个为“容器”型 `RenderObject` 提供默认行为的混入类。

      ### 它的作用是什么？

      它主要提供了两个常用方法的默认实现：

      1.  **`defaultPaint(PaintingContext context, Offset offset)`**:
      这个方法会遍历所有子节点，并调用 `context.paintChild()` 在它们各自的 `offset` 位置上将它们绘制出来。这是最标准的绘制子节点的方式。

      2.  **`defaultHitTestChildren(BoxHitTestResult result, {required Offset position})`**:
      这个方法会**从后往前**（即从视觉上最上层的子节点开始）遍历所有子节点，并对它们进行命中测试。如果某个子节点被命中，
      它就会停止遍历并返回 `true`。这是处理用户点击、触摸等事件的标准逻辑。

      简单来说，这个 Mixin 帮你处理了绘制和命中测试这两件“脏活累活”，让你不必为每个自定义的容器都重写一遍相同的代码。

      ### 一般用在什么场景？

      当你创建一个自定义的、包含多个子组件的 `RenderObject` 时（通常与 `ContainerRenderObjectMixin` 一起使用），并且满足以下条件，就应该使用它：

   *   **布局是核心**：你的主要工作是在 `performLayout` 方法中计算和设置子节点的大小和位置。
   *
   *   **绘制逻辑标准**：你不需要在子节点之间或之上绘制任何特殊效果（例如自定义分隔线、背景、剪裁等），只需要按顺序把它们画出来即可。
   *
   *   **命中测试逻辑标准**：你希望用户能够正常地点击到视觉上最上层的子组件。

      在你的代码中，`RenderCustomColumn` 的职责是模仿 `Column` 的布局逻辑。它在 `performLayout` 中计算好每个子元素的 `offset` 后，
      绘制（`paint`）和命中测试（`hitTestChildren`）都直接使用了这个 Mixin 提供的默认实现，这是一个非常典型的应用场景。
   */
  RenderCustomColumn({
    double spacing = 0.0,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  })  : _spacing = spacing,
        _mainAxisAlignment = mainAxisAlignment,
        _crossAxisAlignment = crossAxisAlignment;

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing != value) {
      _spacing = value;
      markNeedsLayout();
    }
  }

  MainAxisAlignment _mainAxisAlignment;
  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;
  set mainAxisAlignment(MainAxisAlignment value) {
    if (_mainAxisAlignment != value) {
      _mainAxisAlignment = value;
      markNeedsLayout();
    }
  }

  CrossAxisAlignment _crossAxisAlignment;
  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexParentData) {
      child.parentData = FlexParentData();
    }
  }

  @override
  void performLayout() {
    // 计算子节点数量
    int totalChildCount = 0;
    RenderBox? tempChild = firstChild;
    while (tempChild != null) {
      totalChildCount++;
      final FlexParentData tempChildParentData = tempChild.parentData as FlexParentData;
      tempChild = tempChildParentData.nextSibling;
    }

    // 如果没有子节点，设置最小尺寸
    if (totalChildCount == 0) {
      size = constraints.constrain(const Size(0, 0));
      return;
    }

    double maxWidth = 0;
    double totalHeight = 0;

    // Optimize: 第一遍遍历孩子，layout孩子获取所有子节点的size大小
    RenderBox? child = firstChild;
    while (child != null) {
      final FlexParentData childParentData = child.parentData as FlexParentData;

      // 让子节点自行决定大小，layout之后就能获取child.size
      child.layout(
        BoxConstraints(
          minWidth: 0,
          maxWidth: constraints.maxWidth,
          minHeight: 0,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );

      maxWidth = maxWidth > child.size.width ? maxWidth : child.size.width;
      totalHeight += child.size.height;

      child = childParentData.nextSibling;
    }

    // 计算总间距
    final double totalSpacing = _spacing * (totalChildCount - 1);
    totalHeight += totalSpacing;

    // 确定自身大小
    size = constraints.constrain(Size(
      _crossAxisAlignment == CrossAxisAlignment.stretch
          ? constraints.maxWidth
          : maxWidth,
      totalHeight,
    ));

    // Optimize: 第二遍遍历孩子，根据对齐方式定位子节点,把偏移数据存入child.parentData.offset中（方便paint时使用）
    double y = 0;

    // 计算主轴起始位置
    switch (_mainAxisAlignment) {
      case MainAxisAlignment.start:
        y = 0;
        break;
      case MainAxisAlignment.center:
        y = (size.height - totalHeight) / 2;
        break;
      case MainAxisAlignment.end:
        y = size.height - totalHeight;
        break;
      case MainAxisAlignment.spaceBetween:
        y = 0;
        break;
      case MainAxisAlignment.spaceAround:
        y = (size.height - totalHeight + totalSpacing) / (totalChildCount * 2);
        break;
      case MainAxisAlignment.spaceEvenly:
        y = (size.height - totalHeight + totalSpacing) / (totalChildCount + 1);
        break;
    }

    // 计算子节点之间的间距
    double betweenSpace = _spacing;
    if (_mainAxisAlignment == MainAxisAlignment.spaceBetween && totalChildCount > 1) {
      betweenSpace = (size.height - (totalHeight - totalSpacing)) / (totalChildCount - 1);
    } else if (_mainAxisAlignment == MainAxisAlignment.spaceAround) {
      betweenSpace = (size.height - (totalHeight - totalSpacing)) / totalChildCount;
    } else if (_mainAxisAlignment == MainAxisAlignment.spaceEvenly) {
      betweenSpace = (size.height - (totalHeight - totalSpacing)) / (totalChildCount + 1);
    }

    child = firstChild;
    while (child != null) {
      final FlexParentData childParentData = child.parentData as FlexParentData;

      // 计算交叉轴位置
      double x;
      switch (_crossAxisAlignment) {
        case CrossAxisAlignment.start:
          x = 0;
          break;
        case CrossAxisAlignment.center:
          x = (size.width - child.size.width) / 2;
          break;
        case CrossAxisAlignment.end:
          x = size.width - child.size.width;
          break;
        case CrossAxisAlignment.stretch:
          x = 0;
          // 重新布局子节点以拉伸宽度
          child.layout(
            BoxConstraints.tightFor(
              width: size.width,
              height: child.size.height,
            ),
            parentUsesSize: true,
          );
          break;
        default:
          x = 0;
      }

      childParentData.offset = Offset(x, y);

      y += child.size.height;

      // 根据对齐方式添加间距
      if (_mainAxisAlignment == MainAxisAlignment.spaceAround ||
          _mainAxisAlignment == MainAxisAlignment.spaceEvenly) {
        y += betweenSpace;
      } else if (childParentData.nextSibling != null) {
        y += betweenSpace;
      }

      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


///对应文章解析 https://juejin.cn/post/7116267156655833102
///简单处理处理 pageview 嵌套 listview 的斜滑问题
class VPListView extends StatefulWidget {
  const VPListView({super.key});

  @override
  State<VPListView> createState() => _VPListViewState();
}

class _VPListViewState extends State<VPListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VPListView"),
      ),
      ///默认情况下，extendBody 是 false，body 的内容区域不会与底部导航栏重叠。
      extendBody: true,
      body: MediaQuery(
        ///调高 touchSlop 到 50 ，这样 pageview 滑动可能有点点影响，
        ///但是大概率处理了斜着滑动触发的问题
        data: MediaQuery.of(context).copyWith(
            gestureSettings: const DeviceGestureSettings(
          touchSlop: 50,
        )),
        child: PageView(
          scrollDirection: Axis.horizontal,
          ///当 pageSnapping 为 true (默认值) 时: 用户滚动结束后，PageView 会自动吸附到最近的页面边界。
          pageSnapping: true,
          children: const [
            HandlerListView(),
            HandlerListView(),
          ],
        ),
      ),
    );
  }
}

class HandlerListView extends StatefulWidget {
  const HandlerListView({super.key});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<HandlerListView> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      ///这里 touchSlop  需要调回默认
      data: MediaQuery.of(context).copyWith(
          gestureSettings: const DeviceGestureSettings(
        touchSlop: kTouchSlop,
      )),
      child: ListView.separated(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 3,
          );
        },
      ),
    );
  }
}

///对应文章解析 https://juejin.cn/post/7116267156655833102
///垂直滑动的 ViewPage 里嵌套垂直滑动的 ListView
class VPNestListView extends StatefulWidget {
  const VPNestListView({super.key});

  @override
  _VPNestListViewState createState() => _VPNestListViewState();
}

class _VPNestListViewState extends State<VPNestListView> {
  PageController? _pageController;
  ScrollController? _listScrollController;
  ScrollController? _activeScrollController;
  Drag? _drag;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _listScrollController?.dispose();
    super.dispose();
  }

  /**
   * 好的，我们来详细分析一下这两行代码。

      ```dart
      if (_listScrollController?.hasClients == true &&
      _listScrollController?.position.context.storageContext != null) {
      ```

      这段代码是一个 `if` 条件判断，它包含两个通过逻辑与（`&&`）连接的子条件。只有当两个子条件都为 `true` 时，`if` 语句块内的代码才会被执行。这个判断的目的是在处理拖拽手势开始时，安全地检查 `ListView` 是否已经准备好并且可以进行交互。

      ---

      ### 第一个条件：`_listScrollController?.hasClients == true`

      1.  `_listScrollController`: 这是一个 `ScrollController` 类型的对象，它被关联到一个可滚动的组件（在这个例子中是 `ListView`）。
      2.  `?` (空安全操作符): 这是一个空意识成员访问操作符。如果 `_listScrollController` 本身是 `null`，整个表达式 `_listScrollController?.hasClients` 会直接返回 `null`，而不会尝试访问 `hasClients` 属性，从而避免了空指针异常。
      3.  `hasClients`: 这是 `ScrollController` 的一个属性。当一个 `ScrollController` 被至少一个可滚动组件（如 `ListView`）使用时，这个可滚动组件会为控制器创建一个 "client"（即一个 `ScrollPosition` 对象）。`hasClients` 属性返回 `true` 就表示该控制器当前正被一个或多个可滚动组件所关联和使用。
      4.  `== true`: 明确地检查 `hasClients` 的值是否为 `true`。

   **总结第一个条件**: 这部分代码检查 `_listScrollController` 是否已经被一个实际存在于组件树中的 `ListView` 所使用。在 `PageView` 中，如果 `ListView` 所在的页面还没有被加载或者已经被销毁（例如没有使用 `KeepAlive`），那么控制器就不会有 "client"，`hasClients` 就会是 `false`。所以，这是一个确保 `ListView` 处于活动状态的必要检查。

      ---

      ### 第二个条件：`_listScrollController?.position.context.storageContext != null`

      1.  `_listScrollController?.position`:
   *   `position`: `ScrollController` 的一个属性，它返回控制器所管理的 `ScrollPosition` 对象。`ScrollPosition` 存储了滚动的具体状态，比如当前的滚动偏移量（`pixels`）、最大滚动范围（`maxScrollExtent`）等。
   *   **注意**: 只有当控制器只被一个可滚动组件使用时（即只有一个 client），才能直接访问 `position` 属性。如果有多个 clients，访问它会抛出异常。在这个场景下，可以假定控制器只关联了一个 `ListView`。

      2.  `.context`: `ScrollPosition` 的一个属性，返回一个 `ScrollContext` 对象。这个 `context` 对象提供了 `ScrollPosition` 与其关联的 `Scrollable` 组件进行交互所需的环境信息。

      3.  `.storageContext`: `ScrollContext` 的一个属性，它返回一个 `BuildContext`。这个 `BuildContext` 通常就是 `Scrollable` 组件（这里是 `ListView`）自身的 `BuildContext`。它被用于 `PageStorage`，以便在页面切换或状态恢复时保存和恢复滚动位置。

      4.  `!= null`: 检查这个 `storageContext` 是否为空。

   **总结第二个条件**: 这部分代码进一步确认，不仅 `ListView` 处于活动状态，而且我们能够获取到它的 `BuildContext`。获取这个 `context` 至关重要，因为后续代码需要用它来调用 `findRenderObject()` 方法，从而得到 `ListView` 的渲染对象（`RenderBox`），进而判断触摸点是否在 `ListView` 的区域内。如果 `storageContext` 是 `null`，就无法安全地获取渲染对象。

      ---

      ### 整体含义

      综合来看，整个 `if` 语句是一个健壮性检查，用于确保在尝试处理与 `ListView` 相关的滚动逻辑之前，`ListView` 确实存在、可见、并且其渲染信息是可访问的。这在像 `PageView` 这样的复杂布局中尤其重要，因为子组件的生命周期可能不是持续的。
   */
  void _handleDragStart(DragStartDetails details) {
    ///先判断 Listview 是否可见或者可以调用
    ///一般不可见时 hasClients false ，因为 PageView 也没有 keepAlive
    ///storageContext其实是获取到 ListView 的 BuildContext（通过_listScrollController?.position.context.storageContext方式获取仅在只有一个client时才有效）
    if (_listScrollController?.hasClients == true &&
        _listScrollController?.position.context.storageContext != null) {
      ///获取 ListView 的  renderBox
      final RenderBox renderBox = _listScrollController
          ?.position.context.storageContext
          .findRenderObject() as RenderBox;

      ///判断触摸的位置是否在 ListView 内
      ///不在范围内一般是因为 ListView 已经滑动上去了，坐标位置和触摸位置不一致
      ///
      ///这行代码的作用是将 `renderBox` 的绘制边界（`paintBounds`）从其局部坐标系转换到全局（屏幕）坐标系。
      ///
      /// 详细分解如下：
      ///
      /// 1.  `renderBox.localToGlobal(Offset.zero)`:
      ///     *   `Offset.zero` 代表 `renderBox` 局部坐标系的原点 `(0, 0)`。
      ///     *   `localToGlobal` 方法将这个局部坐标原点转换为屏幕上的全局坐标。结果就是 `renderBox` 在屏幕上的左上角位置。
      ///
      /// 2.  `.shift(...)`:
      ///     *   `renderBox.paintBounds` 是 `renderBox` 在其局部坐标系中的绘制区域（一个 `Rect`）。
      ///     *   `shift()` 方法会根据传入的 `Offset`（也就是上一步计算出的全局左上角位置）来平移这个 `Rect`。
      ///
      /// **总结：** 整个操作 `renderBox.paintBounds.shift(renderBox.localToGlobal(Offset.zero))` 的结果是，得到了 `renderBox` 在屏幕上的实际位置和大小的矩形区域（`Rect`）。
      ///
      /// 这样做的目的是为了下一步可以调用 `.contains(details.globalPosition)`，来判断用户的触摸点（`details.globalPosition`，这是一个全局坐标）是否落在了这个 `renderBox`（即 `ListView`）的区域内。
      if (renderBox.paintBounds
              .shift(renderBox.localToGlobal(Offset.zero))
              .contains(details.globalPosition) ==
          true) {
        _activeScrollController = _listScrollController;
        _drag = _activeScrollController?.position.drag(details, _disposeDrag);
        return;
      }
    }

    ///这时候就可以认为是 PageView 需要滑动
    _activeScrollController = _pageController;
    _drag = _pageController?.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_activeScrollController == _listScrollController &&

        ///手指向上移动，也就是快要显示出底部 PageView
        details.primaryDelta! < 0 &&

        ///到了底部，切换到 PageView（刚好到底部时，切换一次，不会总是触发）
        _activeScrollController?.position.pixels ==
            _activeScrollController?.position.maxScrollExtent) {
      print('切换到 PageView222222222222222222222');

      ///切换相应的控制器
      _activeScrollController = _pageController;
      _drag?.cancel();

      ///参考  Scrollable 里的，
      ///因为是切换控制器，也就是要更新 Drag
      ///拖拽流程要切换到 PageView 里，所以需要  DragStartDetails
      ///所以需要把 DragUpdateDetails 变成 DragStartDetails
      ///提取出 PageView 里的 Drag 相应 details
      _drag = _pageController?.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  ///拖拽结束了，释放  _drag
  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VPNestListView"),
      ),
      extendBody: true,
      body: RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
              (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = _handleDragStart
              ..onUpdate = _handleDragUpdate
              ..onEnd = _handleDragEnd
              ..onCancel = _handleDragCancel;
          })
        },
        ///behavior: HitTestBehavior.opaque 确保 RawGestureDetector 在其边界内的任何位置都能响应触摸事件，
        ///即使其子组件是透明的或者没有子组件。
        behavior: HitTestBehavior.opaque,
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.vertical,

          ///去掉 Android 上默认的边缘拖拽效果
          scrollBehavior:
              ScrollConfiguration.of(context).copyWith(overscroll: false),

          ///屏蔽默认的滑动响应
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ScrollConfiguration(

                ///去掉 Android 上默认的边缘拖拽效果
                behavior:
                    ScrollConfiguration.of(context).copyWith(overscroll: false),
                child: KeepAliveListView(
                  listScrollController: _listScrollController,
                  itemCount: 30,
                )),
            Container(
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Page View',
                  style: TextStyle(fontSize: 50),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

///对 PageView 里的 ListView 做 KeepAlive 记住位置
class KeepAliveListView extends StatefulWidget {
  final ScrollController? listScrollController;
  final int itemCount;

  const KeepAliveListView({super.key, 
    required this.listScrollController,
    required this.itemCount,
  });

  @override
  KeepAliveListViewState createState() => KeepAliveListViewState();
}

class KeepAliveListViewState extends State<KeepAliveListView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      controller: widget.listScrollController,

      ///屏蔽默认的滑动响应
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(title: Text('List Item $index'));
      },
      itemCount: widget.itemCount,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

////////////////////////////////////////////////////////////////////////////////

///对应文章解析 https://juejin.cn/post/7116267156655833102
///listView 里嵌套 PageView
class ListViewNestVP extends StatefulWidget {
  const ListViewNestVP({super.key});

  @override
  _ListViewNestVPState createState() => _ListViewNestVPState();
}

class _ListViewNestVPState extends State<ListViewNestVP> {
  PageController _pageController = PageController();
  ScrollController _listScrollController = ScrollController();
  late ScrollController _activeScrollController;
  Drag? _drag;
  int itemCount = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    ///只要不是顶部，就不响应 PageView 的滑动
    ///所以这个判断只支持垂直 PageView 在  ListView 的顶部
    // print('_listScrollController.offset=${_listScrollController.offset}');
    ///当listview非顶部时（已经往上滚动出去一些后），滚动事件全部交给 listview 处理
    if (_listScrollController.offset > 0) {
      _activeScrollController = _listScrollController;
      _drag = _listScrollController.position.drag(details, _disposeDrag);
      return;
    }

    ///此时处于  ListView 的顶部
    if (_pageController.hasClients) {
      ///获取 PageView
      final RenderBox renderBox =
          _pageController.position.context.storageContext.findRenderObject()
              as RenderBox;

      ///判断触摸范围是不是在 PageView
      final isDragPageView = renderBox.paintBounds
          .shift(renderBox.localToGlobal(Offset.zero))
          .contains(details.globalPosition);

      ///如果在 PageView 里就切换到 PageView
      if (isDragPageView) {
        _activeScrollController = _pageController;
        _drag = _activeScrollController.position.drag(details, _disposeDrag);
        return;
      }
    }

    ///不在 PageView 里就继续响应 ListView
    _activeScrollController = _listScrollController;
    _drag = _listScrollController.position.drag(details, _disposeDrag);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    var scrollDirection = _activeScrollController.position.userScrollDirection;

    ///判断此时响应的如果还是 _pageController，是不是到了最后一页
    if (_activeScrollController == _pageController &&
        scrollDirection == ScrollDirection.reverse &&

        ///是不是到最后一页了，到最后一页就切换回 pageController
        (_pageController.page != null &&
            _pageController.page! >= (itemCount - 1))) {
      ///切换回 ListView
      _activeScrollController = _listScrollController;
      ///_drag?.cancel() 是在切换滚动控制器时，用来干净利落地结束前一个滚动组件的拖拽会话，
      ///确保控制权平滑、无冲突地交接给下一个滚动组件的关键步骤。
      _drag?.cancel();
      _drag = _listScrollController.position.drag(
          DragStartDetails(
              globalPosition: details.globalPosition,
              localPosition: details.localPosition),
          _disposeDrag);
    }
    _drag?.update(details);
  }

  void _handleDragEnd(DragEndDetails details) {
    // 总结对比
    // _drag?.end(details)
    // 用户正常完成拖拽（手指抬起）
    // 结束拖拽并根据速度启动惯性滚动
    // 触发自然的惯性滚动（Fling）
    // 需要 DragEndDetails 来获取速度
    //
    // _drag?.cancel()
    // 拖拽被意外中断，或代码逻辑需要强制切换控制器
    // 立即终止拖拽，不产生任何后续效果
    // 滚动立即停止（急刹车）
    // _drag?.end(details);

    _drag?.end(details);
  }

  void _handleDragCancel() {
    _drag?.cancel();
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ListViewNestVP"),
        ),
        body: RawGestureDetector(
          gestures: <Type, GestureRecognizerFactory>{
            VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                    VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                (VerticalDragGestureRecognizer instance) {
              instance
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel;
            })
          },
          /// 设置为 HitTestBehavior.opaque 的原因：
          /// 让 RawGestureDetector 在其边界内始终参与命中测试，即使子组件是透明、留白或未命中，也能收到拖拽事件。
          /// 本页通过手动驱动拖拽（NeverScrollableScrollPhysics + 自己的 drag 流程），需要保证任意位置的垂直拖拽都能触发，否则会在空白区域丢事件，导致无法在 ListView 与 PageView 间平滑切换。
          /// 同时阻止事件“穿透”到下层组件，降低手势竞争与冲突。
          behavior: HitTestBehavior.opaque,
          child: ScrollConfiguration(
            ///去掉 Android 上默认的边缘拖拽效果
            behavior:
                ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: ListView.builder(

                ///屏蔽默认的滑动响应，上面写了自己的拖拽逻辑（上面instance拖动回调屏蔽后，无法拖动）
                physics: const NeverScrollableScrollPhysics(),
                controller: _listScrollController,
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(
                      height: 300,
                      child: KeepAlivePageView(
                        pageController: _pageController,
                        itemCount: itemCount,
                      ),
                    );
                  }
                  return Container(
                      height: 300,
                      color: Colors.greenAccent,
                      child: Center(
                        child: Text(
                          "Item $index",
                          style: const TextStyle(fontSize: 40, color: Colors.blue),
                        ),
                      ));
                }),
          ),
        ));
  }
}

///对 ListView 里的 PageView 做 KeepAlive 记住位置
class KeepAlivePageView extends StatefulWidget {
  final PageController pageController;
  final int itemCount;

  const KeepAlivePageView({super.key, 
    required this.pageController,
    required this.itemCount,
  });

  @override
  KeepAlivePageViewState createState() => KeepAlivePageViewState();
}

/**
 * 好的，我们来详细解析一下 `AutomaticKeepAliveClientMixin` 的工作原理。

    简单来说，`AutomaticKeepAliveClientMixin` 是一个“契约”。通过在你 `State` 类中混入它，并遵循它的规则，你就能告诉 Flutter 的列表类组件（如 `ListView`、`PageView`）：“请不要销毁我，即使我滑出了屏幕。”

    ### 为什么需要它？

    在像 `ListView` 或 `PageView` 这样的可滚动组件中，为了优化性能和内存使用，Flutter 默认只渲染和保留当前视口（屏幕上可见区域）内的子组件。当一个子组件滑出视口时，框架会销毁它的状态（`State`）和渲染树，以便回收资源。当它再次滑入视口时，会重新创建一个全新的 `State` 对象并重新构建。

    这种机制在大多数情况下是高效的，但有时我们希望保留子组件的状态，比如：
 *   一个列表项中包含了用户输入的内容。
 *   一个列表项正在播放视频或执行动画。
 *   一个列表项加载了需要网络请求的数据，我们不希望每次滑入都重新请求。

    这时，`AutomaticKeepAliveClientMixin` 就派上用场了。

    ### 工作原理详解

    它的实现依赖于 `ListView`/`PageView`、`AutomaticKeepAliveClientMixin`、`AutomaticKeepAlive` 和 `KeepAliveNotification` 之间的协同工作。

    1.  **`ListView.builder` 的角色**：
    当你使用 `ListView.builder` 时，它在内部构建列表项时，并不会直接使用你提供的 `itemBuilder` 返回的 Widget。相反，它会用一个名为 `AutomaticKeepAlive` 的特殊 Widget 把你的 Widget 包裹起来。这个包裹行为是自动发生的，你不需要关心。

    2.  **`AutomaticKeepAliveClientMixin` 的角色 (你的 `State` 类)**：
    这个 Mixin 为你的 `State` 类提供了两个关键部分：
 *   **`wantKeepAlive` getter**：你必须重写这个 getter。返回 `true` 就表示你希望这个 Widget 实例被“保活”。返回 `false` 则使用默认的回收策略。
 *   **`build` 方法的增强**：Mixin 要求你在 `build` 方法的开头调用 `super.build(context)`。这个调用非常重要，它会确保你的 Widget 被一个 `KeepAlive` Widget 和一个 `NotificationListener` 包裹。这个 `NotificationListener` 用来监听来自子树的 `KeepAliveNotification`。

    3.  **`AutomaticKeepAlive` 的角色 (由 `ListView` 添加)**：
    这个 Widget 是连接你的 `State` 和 `ListView` 的桥梁。它会找到你的 `State` 对象（因为它知道自己包裹的子 Widget 对应的 `State` 混入了 `AutomaticKeepAliveClientMixin`），然后检查 `wantKeepAlive` 的值。

    4.  **`KeepAliveNotification` 的角色 (通知机制)**：
 *   当 `AutomaticKeepAlive` Widget 发现你的 `wantKeepAlive` 返回 `true` 时，它会创建一个 `KeepAliveNotification(keepAlive: true)` 并向上发送这个通知。
 *   这个通知会沿着 Widget 树向上传播。

    5.  **`Sliver` 的角色 (最终处理者)**：
    `ListView` 和 `PageView` 的底层渲染逻辑是由 `Sliver` 相关的对象处理的。这些 `Sliver` 会监听 `KeepAliveNotification`。
 *   当一个 `Sliver` 收到 `KeepAliveNotification(keepAlive: true)` 通知时，它就知道这个子组件不应该被销毁。
 *   它会将该子组件的渲染对象（RenderObject）和状态（State）标记为“kept-alive”，并将它们保存在一个缓存列表中，即使它们已经滚出视口范围。
 *   当这个子组件再次滚入视口时，`Sliver` 会从缓存中取出已经存在的实例来复用，而不是重新创建。

    ### 总结流程

    1.  你在 `KeepAlivePageViewState` 中混入 `AutomaticKeepAliveClientMixin`。
    2.  你重写 `wantKeepAlive` 并返回 `true`。
    3.  你在 `build` 方法中调用 `super.build(context)`。
    4.  `PageView.builder` 在构建你的页面时，会自动用 `AutomaticKeepAlive` Widget 将其包裹。
    5.  `AutomaticKeepAlive` Widget 检查到 `wantKeepAlive` 为 `true`，于是发送一个 `KeepAliveNotification`。
    6.  `PageView` 底层的 `Sliver` 捕获到这个通知，并将你的 `KeepAlivePageViewState` 实例及其渲染树缓存起来，避免在滑出屏幕时被销毁。

    通过这个精巧的“自动保活”机制，你只需简单地混入一个类并实现一个 `getter`，就能轻松实现复杂列表的页面状态保持功能。
 */
class KeepAlivePageViewState extends State<KeepAlivePageView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView.builder(
      controller: widget.pageController,
      scrollDirection: Axis.vertical,

      ///去掉 Android 上默认的边缘拖拽效果
      scrollBehavior:
          ScrollConfiguration.of(context).copyWith(overscroll: false),

      ///屏蔽默认的滑动响应，完全由自定义的RawGestureDetector来处理拖拽以及scrollController#startDray的Dray对象
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: 300,
          color: Colors.redAccent,
          child: Center(
            child: Text(
              "$index",
              style: const TextStyle(fontSize: 40, color: Colors.yellowAccent),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///listView 联动 listView
class ListViewLinkListView extends StatefulWidget {
  const ListViewLinkListView({super.key});

  @override
  _ListViewLinkListViewState createState() => _ListViewLinkListViewState();
}

class _ListViewLinkListViewState extends State<ListViewLinkListView> {
  final ScrollController _primaryScrollController = ScrollController();
  final ScrollController _subScrollController = ScrollController();

  Drag? _primaryDrag;
  Drag? _subDrag;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _primaryScrollController.dispose();
    _subScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _primaryDrag =
        _primaryScrollController.position.drag(details, _disposePrimaryDrag);
    _subDrag = _subScrollController.position.drag(details, _disposeSubDrag);
  }

  /// 好的，我们来详细解析 `_subDrag?.update()` 中 `DragUpdateDetails` 的这几个参数及其作用。
  ///
  /// 这行代码的核心作用是**创建一个新的、修改过的拖拽更新事件**，并用它来驱动第二个 `ListView`（`_subScrollController`）的滚动，从而实现与第一个 `ListView` 不同的滚动速度（差速滚动效果）。
  ///
  /// 原始的 `details` 对象包含了用户手指实际的拖拽信息。我们通过构造一个新的 `DragUpdateDetails` 对象，可以“欺骗”第二个 `ListView` 的滚动控制器，让它以为用户进行了一次不同的拖拽。
  ///
  /// 以下是每个参数的详细解释：
  ///
  /// 1.  **`sourceTimeStamp: details.sourceTimeStamp`**
  /// *   **含义**: 事件发生时的时间戳。
  /// *   **作用**: 这里直接使用了原始事件的时间戳。这对于滚动物理引擎计算速度和惯性非常重要，保持时间戳的一致性可以确保滚动动画的平滑和自然。
  ///
  /// 2.  **`delta: details.delta / 30`**
  /// *   **含义**: `delta` 是一个 `Offset` 对象，表示从上一次更新事件到本次更新事件，用户手指在**二维平面**上移动的距离（x 和 y 方向的位移）。
  /// *   **作用**: 这是实现差速滚动的**关键**。代码将用户实际的移动距离 `details.delta` 除以了 30。这意味着，我们告诉第二个 `ListView`，用户手指的移动距离只有实际的 1/30。因此，第二个 `ListView` 的滚动速度会比第一个慢得多。
  ///
  /// 3.  **`primaryDelta: (details.primaryDelta ?? 0) / 30`**
  /// *   **含义**: `primaryDelta` 是一个 `double` 值，表示在**主滚动方向**上（对于 `VerticalDragGestureRecognizer` 来说就是垂直方向）的移动距离。
  /// *   **作用**: 这与 `delta` 的作用类似，但更具体地针对主轴。`Scrollable` 组件主要使用 `primaryDelta` 来计算滚动位置的变化。同样地，将其除以 30，使得第二个 `ListView` 在垂直方向上的滚动距离也只有实际的 1/30。使用 `?? 0` 是为了处理 `primaryDelta` 可能为 `null` 的空安全情况。
  ///
  /// 4.  **`globalPosition: details.globalPosition`**
  /// *   **含义**: 用户手指当前在**屏幕全局坐标系**中的位置。
  /// *   **作用**: 这里直接传递了原始的全局位置。虽然在这个特定的差速滚动逻辑中，`delta` 是更关键的参数，但保持位置信息的准确性对于某些复杂的滚动物理或手势处理逻辑是良好的实践。
  ///
  /// 5.  **`localPosition: details.localPosition`**
  /// *   **含义**: 用户手指当前在**手势识别器所在组件的局部坐标系**中的位置。
  /// *   **作用**: 与 `globalPosition` 类似，这里也直接传递了原始的局部位置，以保持事件信息的完整性。
  ///
  /// ### 总结
  ///
  /// 通过构造一个新的 `DragUpdateDetails` 实例，并特意将 `delta` 和 `primaryDelta` 的值大幅缩小，这段代码成功地让第二个 `ListView` 以比第一个 `ListView` 慢30倍的速度进行滚动，从而在两个列表之间创造出一种视觉上的差速联动或视差效果。
  void _handleDragUpdate(DragUpdateDetails details) {
    _primaryDrag?.update(details);
    ///除以30实现差量效果
    _subDrag?.update(DragUpdateDetails(
        sourceTimeStamp: details.sourceTimeStamp,
        delta: details.delta / 30,
        primaryDelta: (details.primaryDelta ?? 0) / 30,
        globalPosition: details.globalPosition,
        localPosition: details.localPosition));
  }

 void _handleDragEnd(DragEndDetails details) {
   _primaryDrag?.end(details);
   ///也附带惯性，但是不能像上面/30那样处理，因为 velocity 是速度，不能太小，否则感觉像没有惯性一样
   _subDrag?.end(DragEndDetails(
       velocity: Velocity(pixelsPerSecond: details.velocity.pixelsPerSecond/2),
       primaryVelocity: details.primaryVelocity != null
           ? details.primaryVelocity! / 2
           : null));
 }

  void _handleDragCancel() {
    _primaryDrag?.cancel();
    _subDrag?.cancel();
  }

  void _disposePrimaryDrag() {
    _primaryDrag = null;
  }

  void _disposeSubDrag() {
    _subDrag = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("ListViewLinkListView"),
        ),
        body: RawGestureDetector(
          gestures: <Type, GestureRecognizerFactory>{
            VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                    VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                (VerticalDragGestureRecognizer instance) {
              instance
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel;
            })
          },
          behavior: HitTestBehavior.opaque,
          child: ScrollConfiguration(
            ///去掉 Android 上默认的边缘拖拽效果
            behavior:
                ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: Row(
              children: [
                Expanded(
                    child: ListView.builder(

                        ///屏蔽默认的滑动响应
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _primaryScrollController,
                        itemCount: 55,
                        itemBuilder: (context, index) {
                          return Container(
                              height: 300,
                              color: Colors.greenAccent,
                              child: Center(
                                child: Text(
                                  "Item $index",
                                  style: const TextStyle(
                                      fontSize: 40, color: Colors.blue),
                                ),
                              ));
                        })),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ListView.builder(

                      ///屏蔽默认的滑动响应
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _subScrollController,
                      itemCount: 55,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 300,
                          color: Colors.deepOrange,
                          child: Center(
                            child: Text(
                              "Item $index",
                              style:
                                  const TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

///左侧分类和右侧详情联动列表
///右侧滚动时自动更新左侧选中状态，并提供回调
class CategoryDetailListView extends StatefulWidget {
  ///当右侧滚动到某个分类时的回调
  final Function(int categoryIndex, String categoryName)? onCategoryChanged;

  const CategoryDetailListView({super.key, this.onCategoryChanged});

  @override
  _CategoryDetailListViewState createState() => _CategoryDetailListViewState();
}

class _CategoryDetailListViewState extends State<CategoryDetailListView> {
  ///左侧分类控制器
  final ScrollController _categoryScrollController = ScrollController();

  ///右侧详情控制器
  final ScrollController _detailScrollController = ScrollController();

  ///当前选中的分类索引
  int _selectedCategoryIndex = 0;

  ///是否是左侧点击触发的滚动（用于避免循环触发）
  bool _isClickScroll = false;

  ///模拟分类数据
  final List<CategoryData> _categories = [
    CategoryData(name: '热门推荐', items: List.generate(8, (i) => '热门商品 ${i + 1}')),
    CategoryData(name: '新品上市', items: List.generate(5, (i) => '新品 ${i + 1}')),
    CategoryData(name: '电子产品', items: List.generate(10, (i) => '电子产品 ${i + 1}')),
    CategoryData(name: '服装鞋包', items: List.generate(7, (i) => '服装 ${i + 1}')),
    CategoryData(name: '食品饮料', items: List.generate(6, (i) => '食品 ${i + 1}')),
    CategoryData(name: '美妆护肤', items: List.generate(9, (i) => '美妆 ${i + 1}')),
    CategoryData(name: '运动户外', items: List.generate(8, (i) => '运动 ${i + 1}')),
    CategoryData(name: '家居生活', items: List.generate(11, (i) => '家居 ${i + 1}')),
    CategoryData(name: '图书音像', items: List.generate(5, (i) => '图书 ${i + 1}')),
    CategoryData(name: '母婴玩具', items: List.generate(7, (i) => '母婴 ${i + 1}')),
  ];

  ///每个分类项的高度
  final double _categoryItemHeight = 120.0;

  ///分类标题的高度
  final double _categoryTitleHeight = 40.0;

  ///每个分类在右侧列表中的位置信息
  final List<double> _categoryPositions = [];

  @override
  void initState() {
    super.initState();
    _calculateCategoryPositions();
    _detailScrollController.addListener(_onDetailScroll);
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    _detailScrollController.dispose();
    super.dispose();
  }

  ///计算每个分类在右侧列表中的起始位置
  void _calculateCategoryPositions() {
    double position = 0;
    _categoryPositions.clear();
    for (var category in _categories) {
      _categoryPositions.add(position);
      ///分类标题高度 + 该分类下所有商品的高度
      position += _categoryTitleHeight + (category.items.length * _categoryItemHeight);
    }
  }

  ///监听右侧详情列表的滚动
  void _onDetailScroll() {
    ///如果是左侧点击触发的滚动，不处理
    if (_isClickScroll) return;

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
    final viewportHeight = _categoryScrollController.position.viewportDimension;
    print('targetOffset=$targetOffset, offset=${_categoryScrollController.offset}, viewportHeight=$viewportHeight');

    ///如果目标项不在可视区域内，滚动到中间位置
    if (targetOffset < _categoryScrollController.offset ||
        targetOffset > _categoryScrollController.offset + viewportHeight - categoryItemHeight) {
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
    setState(() {
      _selectedCategoryIndex = index;
    });

    ///标记为点击触发的滚动
    _isClickScroll = true;

    ///滚动到对应分类位置
    _detailScrollController
        .animateTo(
      _categoryPositions[index],
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      ///滚动完成后，恢复监听
      Future.delayed(const Duration(milliseconds: 100), () {
        _isClickScroll = false;
      });
    });

    ///触发回调
    widget.onCategoryChanged?.call(index, _categories[index].name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("分类详情联动"),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      alignment: Alignment.topCenter,
      height: 360,
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
                  ///选中指示条
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

                  ///分类文字
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _categories[index].name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  ///构建右侧详情列表
  Widget _buildDetailList() {
    return ListView.builder(
      controller: _detailScrollController,
      itemCount: _getTotalItemCount(),
      itemBuilder: (context, index) {
        ///根据索引找到对应的分类和商品
        final item = _getItemByIndex(index);

        if (item.isTitle) {
          ///分类标题
          return Container(
            height: _categoryTitleHeight,
            color: Colors.grey[200],
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.categoryName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          );
        } else {
          ///商品项
          return Container(
            height: _categoryItemHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
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

                ///商品信息
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.itemName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '¥${(item.index * 10 + 99).toStringAsFixed(2)}',
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
      },
    );
  }

  ///获取总的列表项数量（包括分类标题和商品项）
  int _getTotalItemCount() {
    int count = 0;
    for (var category in _categories) {
      count += 1; ///分类标题
      count += category.items.length; ///商品项
    }
    return count;
  }

  ///根据列表索引获取对应的项信息（标题也当作item算进item了）
  _ListItem _getItemByIndex(int index) {
    int currentIndex = 0;
    for (int i = 0; i < _categories.length; i++) {
      ///检查是否是分类标题
      if (currentIndex == index) {
        return _ListItem(
          isTitle: true,
          categoryIndex: i,
          categoryName: _categories[i].name,
          itemName: '',
          index: 0,
        );
      }
      ///不是标题后的总索引+1
      currentIndex++;

      ///检查是否是该分类下的商品项
      for (int j = 0; j < _categories[i].items.length; j++) {
        if (currentIndex == index) {
          return _ListItem(
            isTitle: false,
            categoryIndex: i,
            categoryName: _categories[i].name,
            itemName: _categories[i].items[j],
            index: j,
          );
        }
        currentIndex++;
      }
    }

    ///默认返回
    return _ListItem(
      isTitle: true,
      categoryIndex: 0,
      categoryName: '',
      itemName: '',
      index: 0,
    );
  }
}

///分类数据模型
class CategoryData {
  final String name;
  final List<String> items;

  CategoryData({required this.name, required this.items});
}

///列表项信息
class _ListItem {
  final bool isTitle;
  final int categoryIndex;
  final String categoryName;
  final String itemName;
  final int index;

  _ListItem({
    required this.isTitle,
    required this.categoryIndex,
    required this.categoryName,
    required this.itemName,
    required this.index,
  });
}

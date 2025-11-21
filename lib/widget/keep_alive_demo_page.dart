import 'package:flutter/material.dart';

/// AutomaticKeepAliveClientMixin 使用示例
///
/// 演示场景：
/// 1. TabBar + TabBarView 中保持每个Tab的状态
/// 2. PageView 中保持页面状态不被销毁
/// 3. ListView 中保持子项状态
class KeepAliveDemoPage extends StatelessWidget {
  const KeepAliveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AutomaticKeepAliveClientMixin 演示'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '计数器(保活)'),
              Tab(text: '输入框(保活)'),
              Tab(text: '列表(不保活)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 使用了 AutomaticKeepAliveClientMixin 的计数器页面
            KeepAliveCounterPage(),
            // 使用了 AutomaticKeepAliveClientMixin 的输入框页面
            KeepAliveInputPage(),
            // 未使用 AutomaticKeepAliveClientMixin 的列表页面
            NormalListPage(),
          ],
        ),
      ),
    );
  }
}

/// 使用 AutomaticKeepAliveClientMixin 的计数器页面
///
/// 关键点：
/// 1. 混入 AutomaticKeepAliveClientMixin
/// 2. 重写 wantKeepAlive 返回 true
/// 3. 在 build 方法开头调用 super.build(context)
class KeepAliveCounterPage extends StatefulWidget {
  const KeepAliveCounterPage({super.key});

  @override
  State<KeepAliveCounterPage> createState() => _KeepAliveCounterPageState();
}

class _KeepAliveCounterPageState extends State<KeepAliveCounterPage>
    with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  late DateTime _createTime;

  @override
  void initState() {
    super.initState();
    _createTime = DateTime.now();
    print('计数器页面初始化: $_createTime');
  }

  @override
  void dispose() {
    print('计数器页面销毁');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 必须调用 super.build(context) 来启用保活机制
    super.build(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '这个页面使用了 AutomaticKeepAliveClientMixin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            '切换到其他Tab再切回来，状态会保持',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Text(
            '页面创建时间:',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            '${_createTime.hour}:${_createTime.minute}:${_createTime.second}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          const Text(
            '计数器:',
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('增加计数'),
          ),
        ],
      ),
    );
  }

  /// 重写此方法，返回 true 表示需要保持状态
  /// 返回 false 则不保持状态，页面会被销毁
  @override
  bool get wantKeepAlive => true;
}

/// 使用 AutomaticKeepAliveClientMixin 的输入框页面
class KeepAliveInputPage extends StatefulWidget {
  const KeepAliveInputPage({super.key});

  @override
  State<KeepAliveInputPage> createState() => _KeepAliveInputPageState();
}

class _KeepAliveInputPageState extends State<KeepAliveInputPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _items = List.generate(50, (index) => '列表项 ${index + 1}');

  @override
  void initState() {
    super.initState();
    print('输入框页面初始化');
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    print('输入框页面销毁');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 必须调用 super.build
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '这个页面也使用了 AutomaticKeepAliveClientMixin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            '输入的内容和滚动位置都会保持',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: '输入一些文字',
              border: OutlineInputBorder(),
              hintText: '切换Tab后再回来，输入的内容不会丢失',
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_items[index]),
                    subtitle: Text('滚动位置也会被保存'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// 未使用 AutomaticKeepAliveClientMixin 的普通页面
/// 用于对比效果
class NormalListPage extends StatefulWidget {
  const NormalListPage({super.key});

  @override
  State<NormalListPage> createState() => _NormalListPageState();
}

class _NormalListPageState extends State<NormalListPage> {
  late DateTime _createTime;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _createTime = DateTime.now();
    print('普通列表页面初始化: $_createTime');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    print('普通列表页面销毁');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 注意：这里没有调用 super.build(context)
    // 也没有混入 AutomaticKeepAliveClientMixin

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[100],
            child: Column(
              children: [
                const Text(
                  '这个页面没有使用 AutomaticKeepAliveClientMixin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  '切换Tab后页面会被销毁，再次进入会重新创建',
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                Text(
                  '页面创建时间: ${_createTime.hour}:${_createTime.minute}:${_createTime.second}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 30,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.orange[50],
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber),
                    title: Text('未保活列表项 ${index + 1}'),
                    subtitle: const Text('滚动位置会丢失'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 额外示例：在 PageView 中使用 AutomaticKeepAliveClientMixin
class KeepAlivePageViewDemo extends StatelessWidget {
  const KeepAlivePageViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView 保活示例'),
      ),
      body: PageView(
        children: [
          KeepAlivePageItem(index: 0, color: Colors.red[100]!),
          KeepAlivePageItem(index: 1, color: Colors.green[100]!),
          KeepAlivePageItem(index: 2, color: Colors.blue[100]!),
        ],
      ),
    );
  }
}

class KeepAlivePageItem extends StatefulWidget {
  final int index;
  final Color color;

  const KeepAlivePageItem({
    super.key,
    required this.index,
    required this.color,
  });

  @override
  State<KeepAlivePageItem> createState() => _KeepAlivePageItemState();
}

class _KeepAlivePageItemState extends State<KeepAlivePageItem>
    with AutomaticKeepAliveClientMixin {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: widget.color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '页面 ${widget.index + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '计数: $_counter',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
              child: const Text('增加'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


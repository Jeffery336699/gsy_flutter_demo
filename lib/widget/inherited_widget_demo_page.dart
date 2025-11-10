import 'package:flutter/material.dart';
import 'package:gsy_flutter_demo/main.dart';
import 'package:logger/logger.dart';

/// InheritedWidget 数据共享原理与最佳实践示例
///
/// InheritedWidget 核心原理：
/// 1. Element 树中通过 _inheritedElements 存储 InheritedWidget 的引用
/// 2. dependOnInheritedWidgetOfExactType 会向上遍历 Element 树查找对应类型
/// 3. 当 InheritedWidget 更新时，会通知所有依赖它的 Element 重建
/// 4. 通过 updateShouldNotify 控制是否需要通知依赖者更新
class InheritedWidgetDemoPage extends StatelessWidget {
  const InheritedWidgetDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    print(
        '[$runtimeType] ${context.getElementForInheritedWidgetOfExactType<AppThemeProvider>()} InheritedWidgetDemoPage build called');
    return Scaffold(
      appBar: AppBar(
        title: const Text('InheritedWidget 数据共享原理'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. 基础用法 - 主题共享'),
          const ThemeDemo(),
          const SizedBox(height: 24),
          _buildSectionTitle('1.1 State实现跨帧绘制和详解setState'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const DemoApp()));
              },
              child: Text('跳转')),
          const SizedBox(height: 24),
          // _buildSectionTitle('2. 计数器示例 - 状态共享'),
          // const CounterDemo(),
          // const SizedBox(height: 24),
          // _buildSectionTitle('3. 用户信息共享 - 实际场景'),
          // const UserInfoDemo(),
          // const SizedBox(height: 24),
          // _buildSectionTitle('4. 购物车示例 - 复杂状态管理'),
          // const ShoppingCartDemo(),
          // const SizedBox(height: 24),
          _buildSectionTitle('5. 性能优化 - 精确依赖'),
          const PerformanceDemo(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

// ============ 1. 基础主题共享示例 ============

class AppTheme {
  final Color primaryColor;
  final Color textColor;
  final double fontSize;

  const AppTheme({
    required this.primaryColor,
    required this.textColor,
    required this.fontSize,
  });

  AppTheme copyWith({
    Color? primaryColor,
    Color? textColor,
    double? fontSize,
  }) {
    return AppTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

class AppThemeProvider extends InheritedWidget {
  final AppTheme theme;

  const AppThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  // 方便子组件访问主题数据
  static AppTheme? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) {
    print('AppThemeProvider updateShouldNotify called');
    // 只有主题真正改变时才通知
    return oldWidget.theme.primaryColor != theme.primaryColor ||
        oldWidget.theme.textColor != theme.textColor ||
        oldWidget.theme.fontSize != theme.fontSize;
  }
}

class ThemeDemo extends StatefulWidget {
  const ThemeDemo({super.key});

  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  AppTheme _theme = const AppTheme(
    primaryColor: Colors.blue,
    textColor: Colors.black87,
    fontSize: 16,
  );

  void _toggleTheme() {
    setState(() {
      _theme = _theme.primaryColor == Colors.blue
          ? const AppTheme(
              primaryColor: Colors.purple,
              textColor: Colors.white,
              fontSize: 18,
            )
          : const AppTheme(
              primaryColor: Colors.blue,
              textColor: Colors.black87,
              fontSize: 16,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        '[$runtimeType] ${context.getElementForInheritedWidgetOfExactType<AppThemeProvider>()} ThemeDemo build called');
    return AppThemeProvider(
      theme: _theme,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ThemedText('这是使用主题的文本'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _toggleTheme,
                child: const Text('切换主题'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ThemeDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('_ThemeDemoState didUpdateWidget called');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('_ThemeDemoState didChangeDependencies called');
  }
}

class ThemedText extends StatelessWidget {
  final String text;

  const ThemedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    print(
        '[$runtimeType] ${context.getElementForInheritedWidgetOfExactType<AppThemeProvider>()} ThemedText build called');
    final theme = AppThemeProvider.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme?.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: theme?.textColor,
          fontSize: theme?.fontSize,
        ),
      ),
    );
  }
}

// ============ 1.1 State是什么及setState源码分析示例 ============
class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  String data = "init";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: DemoPage("Test", "dddd", 30),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            data = "setState";
          });
        },
        child: const Icon(
          Icons.refresh,
          size: 30,
        ),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  final String title;
  final String data;
  final int count;

  DemoPage(this.title, this.data, this.count, {super.key});

  @override
  _DemoPageState createState() {
    print('[${runtimeType}] DemoPage createState called with data: $data');
    return _DemoPageState(data);
  }
}

class _DemoPageState extends State<DemoPage> {
  final String data;

  _DemoPageState(this.data);

  @override
  Widget build(BuildContext context) {
    // [DemoPage] DemoPage createState called with data: init
    // [207543791] _DemoPageState build called with data: init
    // didUpdateWidget called: old data=init, new data=setState
    // [207543791] _DemoPageState build called with data: init
    // didUpdateWidget called: old data=setState, new data=setState
    // [207543791] _DemoPageState build called with data: init
    // didUpdateWidget called: old data=setState, new data=setState
    // [207543791] _DemoPageState build called with data: init
    /// state最大的优势就是借助它与element保持一致，element没有变得情况下，state不会变【跨帧保持状态，数据复用】
    /// 外部的widget配置文件变化了，会存在state.widget上，通过widget属性访问最新的配置数据
    print('[$hashCode] _DemoPageState build called with data: $data');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: TextButton(onPressed: () {
              setState(() {
                print('内部setState调用，不会触发didUpdateWidget');});
            }, child: Text("点击"))),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                /// widget.data
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.pink[400]),
                  ),
                );
              },
              itemCount: widget.count,
            ),
          ),
          /// 这里设置为const就不会打印其State内部的didUpdateWidget日志了，因为在build过程中父类调用updateChild时，
          /// 第一个判断是否widget是同一个，同一个就是简单赋值，并不会调用子widget的didUpdateWidget方法
          const MyTestStatefulWidget(text: '最底层组件调用'),

          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                /// widget.data才能真正的更新数据
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.data,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.blue[400]),
                  ),
                );
              },
              itemCount: widget.count,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant DemoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    /// 关于didUpdateWidget方法：
    /// 1. 一般用来更新当前state类中的数据，因为state是跨帧存在的（在element复用情况下，该state也是复用的），
    ///   说人话就是state里面的数据仍然是旧的，所以一般是用widget中获取最新数据来更新（此时的widget中已是最新的数据）
    /// 2. 该方法调用后，必会调用build方法重新构建UI
    /// 3. 该方法只有在widget配置更新时才会调用（自身的setState调用不会触发该方法）
    /// 4. 该方法中调用setState方法并不会死循环，setState/与接下来会调用build目的一致，没必要多此一举
    /// 5. 该方法中可以访问oldWidget属性，获取旧的widget配置
    /// 6. 该方法中可以访问widget属性，获取最新的widget配置
    logger.e('didUpdateWidget called: old data=${oldWidget.data}, new data=${widget.data}');
    // setState(() {
    //   print('会loop??');
    // });
  }
}

class MyTestStatefulWidget extends StatefulWidget {
  final String text;
  const MyTestStatefulWidget({super.key, required this.text});

  @override
  State<MyTestStatefulWidget> createState() => _MyTestStatefulWidgetState();
}

class _MyTestStatefulWidgetState extends State<MyTestStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    logger.w('5555555555555最底层。。。。。。。。。组件');
    return ElevatedButton(
      onPressed: () { setState(() {
        print('MyTestStatefulWidget setState调用，不会触发didUpdateWidget');
      }); },
      child: Text(widget.text,style: TextStyle(fontSize: 20)),
    );
  }

  @override
  void didUpdateWidget(covariant MyTestStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger.w('222222222222  MyTestStatefulWidget didUpdateWidget called  3333333333333');
  }
}


// ============ 2. 计数器状态共享示例 ============

class CounterProvider extends InheritedWidget {
  final int count;
  final VoidCallback increment;

  const CounterProvider({
    super.key,
    required this.count,
    required this.increment,
    required super.child,
  });

  static CounterProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(CounterProvider oldWidget) {
    return oldWidget.count != count;
  }
}

class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});

  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterProvider(
      count: _count,
      increment: _increment,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CounterDisplay(),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CounterButton(),
                  CounterButton(),
                  CounterButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '计数: ${provider?.count ?? 0}',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  const CounterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = CounterProvider.of(context);
    return ElevatedButton(
      onPressed: provider?.increment,
      child: const Text('+1'),
    );
  }
}

// ============ 3. 用户信息共享示例 ============

class UserInfo {
  final String name;
  final String avatar;
  final int level;

  const UserInfo({
    required this.name,
    required this.avatar,
    required this.level,
  });
}

class UserInfoProvider extends InheritedWidget {
  final UserInfo? userInfo;
  final Function(UserInfo) updateUser;

  const UserInfoProvider({
    super.key,
    required this.userInfo,
    required this.updateUser,
    required super.child,
  });

  static UserInfoProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserInfoProvider>();
  }

  @override
  bool updateShouldNotify(UserInfoProvider oldWidget) {
    return oldWidget.userInfo != userInfo;
  }
}

class UserInfoDemo extends StatefulWidget {
  const UserInfoDemo({super.key});

  @override
  State<UserInfoDemo> createState() => _UserInfoDemoState();
}

class _UserInfoDemoState extends State<UserInfoDemo> {
  UserInfo? _userInfo;

  void _login() {
    setState(() {
      _userInfo = const UserInfo(
        name: 'Flutter Developer',
        avatar: '👨‍💻',
        level: 5,
      );
    });
  }

  void _logout() {
    setState(() {
      _userInfo = null;
    });
  }

  void _updateUser(UserInfo info) {
    setState(() {
      _userInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoProvider(
      userInfo: _userInfo,
      updateUser: _updateUser,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const UserProfile(),
              const SizedBox(height: 12),
              if (_userInfo == null)
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('登录'),
                )
              else
                ElevatedButton(
                  onPressed: _logout,
                  child: const Text('退出登录'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = UserInfoProvider.of(context);
    final user = provider?.userInfo;

    if (user == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('未登录'),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            user.avatar,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Level ${user.level}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
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

// ============ 4. 购物车示例 ============

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

class ShoppingCartProvider extends InheritedWidget {
  final List<CartItem> items;
  final Function(CartItem) addItem;
  final Function(String) removeItem;
  final double totalPrice;

  const ShoppingCartProvider({
    super.key,
    required this.items,
    required this.addItem,
    required this.removeItem,
    required this.totalPrice,
    required super.child,
  });

  static ShoppingCartProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShoppingCartProvider>();
  }

  @override
  bool updateShouldNotify(ShoppingCartProvider oldWidget) {
    return oldWidget.items.length != items.length ||
        oldWidget.totalPrice != totalPrice;
  }
}

class ShoppingCartDemo extends StatefulWidget {
  const ShoppingCartDemo({super.key});

  @override
  State<ShoppingCartDemo> createState() => _ShoppingCartDemoState();
}

class _ShoppingCartDemoState extends State<ShoppingCartDemo> {
  final List<CartItem> _items = [];

  void _addItem(CartItem item) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index >= 0) {
        _items[index].quantity++;
      } else {
        _items.add(item);
      }
    });
  }

  void _removeItem(String id) {
    setState(() {
      _items.removeWhere((item) => item.id == id);
    });
  }

  double get _totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return ShoppingCartProvider(
      items: _items,
      addItem: _addItem,
      removeItem: _removeItem,
      totalPrice: _totalPrice,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CartSummary(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _addItem(CartItem(
                      id: '1',
                      name: '商品A',
                      price: 99.0,
                    )),
                    child: const Text('添加商品A'),
                  ),
                  ElevatedButton(
                    onPressed: () => _addItem(CartItem(
                      id: '2',
                      name: '商品B',
                      price: 149.0,
                    )),
                    child: const Text('添加商品B'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const CartItemsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = ShoppingCartProvider.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '商品数量: ${provider?.items.length ?? 0}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '总价: ¥${provider?.totalPrice.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = ShoppingCartProvider.of(context);
    final items = provider?.items ?? [];

    if (items.isEmpty) {
      return const Text('购物车为空');
    }

    return Column(
      children: items.map((item) {
        return ListTile(
          title: Text(item.name),
          subtitle: Text('¥${item.price} × ${item.quantity}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => provider?.removeItem(item.id),
          ),
        );
      }).toList(),
    );
  }
}

// ============ 5. 性能优化示例 ============

class PerformanceDemo extends StatefulWidget {
  const PerformanceDemo({super.key});

  @override
  State<PerformanceDemo> createState() => _PerformanceDemoState();
}

class _PerformanceDemoState extends State<PerformanceDemo> {
  int _counter1 = 0;
  int _counter2 = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '性能优化要点：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• 使用 updateShouldNotify 控制更新'),
            const Text('• 将 InheritedWidget 放在尽可能低的位置'),
            const Text('• 避免不必要的依赖'),
            const Text('• 考虑使用 InheritedModel 实现精确订阅'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('计数器1: $_counter1'),
                    ElevatedButton(
                      onPressed: () => setState(() => _counter1++),
                      child: const Text('+1'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('计数器2: $_counter2'),
                    ElevatedButton(
                      onPressed: () => setState(() => _counter2++),
                      child: const Text('+1'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 最佳实践建议：',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 4),
                  Text('1. 配合 StatefulWidget 使用'),
                  Text('2. 提供静态 of 方法便于访问'),
                  Text('3. 合理使用 updateShouldNotify'),
                  Text('4. 复杂场景考虑 Provider 等状态管理库'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

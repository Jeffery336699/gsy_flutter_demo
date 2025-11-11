import 'package:flutter/material.dart';
import 'package:gsy_flutter_demo/main.dart';
import 'package:scoped_model/scoped_model.dart';

/// Scoped Model 使用示例与最佳实践
///
/// Scoped Model 是一个轻量级的状态管理库，基于 InheritedWidget 实现
/// 核心优势：
/// 1. 简单易用，API 清晰
/// 2. 性能优良，只有订阅的 Widget 才会重建
/// 3. 支持嵌套模型和模型组合
/// 4. 适合中小型项目的状态管理
///
/// Scoped Model 核心要点：
/// 基于 InheritedWidget - 轻量级状态管理方案
/// notifyListeners() - 通知所有监听者更新
/// ScopedModelDescendant - 自动重建订阅的组件
/// ScopedModel.of() - 直接获取 model（需要正确的 context）
/// 性能优化 - 使用 rebuildOnChange: false 避免不必要的重建

class ScopedModelDemoPage extends StatelessWidget {
  const ScopedModelDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    logger.e('最外层。。。 build');
    // 使用 ScopedModel 包裹整个页面，提供状态给子树
    return ScopedModel<AppStateModel>(
      model: AppStateModel(),
      child: Builder(
        builder: (context) {
        logger.i('ScopedModelDemoPage rebuilt');
        return Scaffold(
            appBar: AppBar(
              title: const Text('Scoped Model 使用示例'),
              actions: [
                // 示例1：使用 ScopedModelDescendant 监听状态,内部用到didChangeDependencies监听上层的model变化
                ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    logger.w('AppBar IconButton rebuilt');
                    return IconButton(
                      icon: Icon(
                        model.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      ),
                      onPressed: (){
                        // logger.i('[${context.hashCode},${context.runtimeType}] onPressed 点击');
                        model.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
            body: Center(child: Text('文本',textScaleFactor: 5,))/*const SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('示例1：计数器 - 基础用法'),
                  _CounterExample(),
                  Divider(height: 40),
                  _SectionTitle('示例2：购物车 - 列表状态管理'),
                  _ShoppingCartExample(),
                  Divider(height: 40),
                  _SectionTitle('示例3：用户信息 - 复杂对象状态'),
                  _UserProfileExample(),
                  Divider(height: 40),
                  _SectionTitle('示例4：主题切换 - 全局状态'),
                  _ThemeToggleExample(),
                  Divider(height: 40),
                  _SectionTitle('示例5：性能优化 - rebuildOnChange'),
                  _PerformanceExample(),
                ],
              ),
            )*/,
          );
        }
      ),
    );
  }
}

/// 标题组件
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
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

// ==================== 示例1：计数器 ====================

/// 计数器模型 - 展示最基础的用法
class CounterModel extends Model {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    // 通知所有监听者更新
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    notifyListeners();
  }
}

class _CounterExample extends StatelessWidget {
  const _CounterExample();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CounterModel>(
      model: CounterModel(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 方式1：使用 ScopedModelDescendant
              ScopedModelDescendant<CounterModel>(
                builder: (context, child, model) {
                  return Text(
                    '计数: ${model.counter}',
                    style: const TextStyle(fontSize: 24),
                  );
                },
              ),
              const SizedBox(height: 16),
              // 使用 Builder 获取正确的 context
              Builder(
                builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 方式2：使用 ScopedModel.of 直接获取 model
                          ScopedModel.of<CounterModel>(context).decrement();
                        },
                        child: const Icon(Icons.remove),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScopedModel.of<CounterModel>(context).reset();
                        },
                        child: const Text('重置'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScopedModel.of<CounterModel>(context).increment();
                        },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 示例2：购物车 ====================

/// 商品类
class Product {
  final String id;
  final String name;
  final double price;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 0,
  });

  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// 购物车模型 - 展示列表状态管理
class ShoppingCartModel extends Model {
  final List<Product> _products = [
    Product(id: '1', name: 'iPhone 15', price: 5999),
    Product(id: '2', name: 'iPad Pro', price: 6799),
    Product(id: '3', name: 'MacBook Air', price: 7999),
  ];

  List<Product> get products => _products;

  List<Product> get cartItems =>
      _products.where((p) => p.quantity > 0).toList();

  double get totalPrice =>
      _products.fold(0, (sum, p) => sum + (p.price * p.quantity));

  int get totalItems => _products.fold(0, (sum, p) => sum + p.quantity);

  void addToCart(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    product.quantity++;
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final product = _products.firstWhere((p) => p.id == productId);
    if (product.quantity > 0) {
      product.quantity--;
      notifyListeners();
    }
  }

  void clearCart() {
    for (var product in _products) {
      product.quantity = 0;
    }
    notifyListeners();
  }
}

class _ShoppingCartExample extends StatelessWidget {
  const _ShoppingCartExample();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ShoppingCartModel>(
      model: ShoppingCartModel(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 商品列表
              ScopedModelDescendant<ShoppingCartModel>(
                builder: (context, child, model) {
                  return Column(
                    children: model.products.map((product) {
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text('¥${product.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: product.quantity > 0
                                  ? () => model.removeFromCart(product.id)
                                  : null,
                            ),
                            Text(
                              '${product.quantity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => model.addToCart(product.id),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const Divider(),
              // 购物车统计
              ScopedModelDescendant<ShoppingCartModel>(
                builder: (context, child, model) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '总计: ¥${model.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '共 ${model.totalItems} 件',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),
              ScopedModelDescendant<ShoppingCartModel>(
                builder: (context, child, model) {
                  return ElevatedButton(
                    onPressed:
                        model.totalItems > 0 ? () => model.clearCart() : null,
                    child: const Text('清空购物车'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 示例3：用户信息 ====================

/// 用户信息类
class UserInfo {
  final String name;
  final String email;
  final String avatar;
  final int age;

  UserInfo({
    required this.name,
    required this.email,
    required this.avatar,
    required this.age,
  });

  UserInfo copyWith({String? name, String? email, String? avatar, int? age}) {
    return UserInfo(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      age: age ?? this.age,
    );
  }
}

/// 用户模型 - 展示复杂对象状态管理
class UserModel extends Model {
  UserInfo _userInfo = UserInfo(
    name: '张三',
    email: 'zhangsan@example.com',
    avatar: '😊',
    age: 25,
  );

  bool _isLoading = false;

  UserInfo get userInfo => _userInfo;
  bool get isLoading => _isLoading;

  Future<void> updateProfile({
    String? name,
    String? email,
    String? avatar,
    int? age,
  }) async {
    _isLoading = true;
    notifyListeners();

    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 1));

    _userInfo = _userInfo.copyWith(
      name: name,
      email: email,
      avatar: avatar,
      age: age,
    );
    _isLoading = false;
    notifyListeners();
  }
}

class _UserProfileExample extends StatelessWidget {
  const _UserProfileExample();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  Text(
                    model.userInfo.avatar,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    model.userInfo.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(model.userInfo.email),
                  Text('年龄: ${model.userInfo.age}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await model.updateProfile(
                        name: '李四',
                        email: 'lisi@example.com',
                        avatar: '🎉',
                        age: 30,
                      );
                    },
                    child: const Text('更新资料'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==================== 示例4：主题切换 ====================

/// 应用状态模型 - 展示全局状态管理
class AppStateModel extends Model {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class _ThemeToggleExample extends StatelessWidget {
  const _ThemeToggleExample();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (context, child, model) {
        return Card(
          color: model.isDarkMode ? Colors.grey[800] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '当前主题: ${model.isDarkMode ? "深色" : "浅色"}',
                  style: TextStyle(
                    fontSize: 18,
                    color: model.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(
                    '深色模式',
                    style: TextStyle(
                      color: model.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  value: model.isDarkMode,
                  onChanged: (value) => model.toggleTheme(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==================== 示例5：性能优化 ====================

/// 性能测试模型
class PerformanceModel extends Model {
  int _counter1 = 0;
  int _counter2 = 0;

  int get counter1 => _counter1;
  int get counter2 => _counter2;

  void incrementCounter1() {
    _counter1++;
    notifyListeners();
  }

  void incrementCounter2() {
    _counter2++;
    notifyListeners();
  }
}

class _PerformanceExample extends StatelessWidget {
  const _PerformanceExample();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<PerformanceModel>(
      model: PerformanceModel(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '性能优化技巧：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('1. 使用 rebuildOnChange: false 避免不必要的重建'),
              const Text('2. 只在需要更新的组件上使用 ScopedModelDescendant'),
              const Text('3. 将静态内容放在 ScopedModelDescendant 外部'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('计数器 1'),
                        // 只监听 counter1
                        ScopedModelDescendant<PerformanceModel>(
                          rebuildOnChange: true,
                          builder: (context, child, model) {
                            debugPrint('重建 Counter1 显示');
                            return Text(
                              '${model.counter1}',
                              style: const TextStyle(fontSize: 24),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: () {
                                ScopedModel.of<PerformanceModel>(context)
                                    .incrementCounter1();
                              },
                              child: const Text('+1'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('计数器 2'),
                        // 只监听 counter2
                        ScopedModelDescendant<PerformanceModel>(
                          rebuildOnChange: true,
                          builder: (context, child, model) {
                            debugPrint('重建 Counter2 显示');
                            return Text(
                              '${model.counter2}',
                              style: const TextStyle(fontSize: 24),
                            );
                          },
                        ),
                        Builder(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: () {
                                ScopedModel.of<PerformanceModel>(context)
                                    .incrementCounter2();
                              },
                              child: const Text('+1'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '提示：点击按钮查看控制台日志，观察重建行为',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


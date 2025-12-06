# Shelf 本地服务器 - 完整搭建指南

## 📖 项目概述

基于 Dart 官方的 **Shelf** HTTP 服务器框架，搭建了一套功能完整的本地 Mock 服务器，包含多种常见的 RESTful API 示例。

## 🏗️ 架构设计

### 核心组件

1. **Shelf** - HTTP 服务器核心框架
2. **Shelf Router** - 路由管理
3. **Pipeline** - 中间件管道
4. **Handlers** - 请求处理器

### 项目结构

```
lib/server_mock/
├── main.dart          # 服务器主文件
├── README.md          # API 使用文档
└── test_api.ps1       # API 测试脚本
```

## 🎯 实现的功能

### 1. 路由系统

#### 路径参数
```dart
..get('/hello/<name>', _helloHandler)
..get('/api/products/<id>', _productDetailHandler)
```

#### 查询参数
```dart
..get('/user', _userHandler)
// 访问: /user?name=xxx&age=xx
```

#### HTTP 方法支持
- ✅ GET - 查询数据
- ✅ POST - 创建数据
- ✅ PUT - 更新数据
- ✅ DELETE - 删除数据

### 2. 中间件系统

```dart
final handler = Pipeline()
    .addMiddleware(logRequests())      // 日志记录
    .addMiddleware(_corsHeaders())     // CORS 支持
    .addMiddleware(_errorHandler())    // 错误处理
    .addHandler(app);
```

#### 内置中间件

**日志中间件** (`logRequests()`)
- 自动记录每个请求的方法、路径和响应时间
- Shelf 官方提供

**CORS 中间件** (`_corsHeaders()`)
- 支持跨域请求
- 配置了 Access-Control-Allow-* 响应头
- 处理 OPTIONS 预检请求

**错误处理中间件** (`_errorHandler()`)
- 捕获所有未处理的异常
- 返回统一的错误响应格式
- 记录错误日志和堆栈跟踪

### 3. 请求处理

#### 解析查询参数
```dart
Response _userHandler(Request request) {
  final params = request.url.queryParameters;
  final name = params['name'] ?? 'Guest';
  final age = params['age'] ?? 'unknown';
  // ...
}
```

#### 解析 JSON 请求体
```dart
Future<Response> _loginHandler(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload) as Map<String, dynamic>;
  
  final username = data['username'] as String?;
  final password = data['password'] as String?;
  // ...
}
```

#### 解析路径参数
```dart
Response _productDetailHandler(Request request, String id) {
  final productId = int.tryParse(id);
  // ...
}
```

### 4. 响应处理

#### 纯文本响应
```dart
return Response.ok(
  'Hello, $name! 欢迎使用 Shelf 服务器 🎉',
  headers: {'Content-Type': 'text/plain; charset=utf-8'},
);
```

#### JSON 响应
```dart
return Response.ok(
  jsonEncode(response),
  headers: {'Content-Type': 'application/json; charset=utf-8'},
);
```

#### 自定义状态码
```dart
return Response(400,
  body: jsonEncode({'error': 'Invalid product ID'}),
  headers: {'Content-Type': 'application/json; charset=utf-8'},
);
```

#### 快捷方法
```dart
Response.ok(...)                    // 200 OK
Response.notFound(...)              // 404 Not Found
Response.internalServerError(...)   // 500 Internal Server Error
```

## 📋 API 示例详解

### 1. 简单文本响应
```dart
Response _helloHandler(Request request, String name) {
  return Response.ok(
    'Hello, $name! 欢迎使用 Shelf 服务器 🎉',
    headers: {'Content-Type': 'text/plain; charset=utf-8'},
  );
}
```

### 2. 查询参数处理
```dart
Response _userHandler(Request request) {
  final params = request.url.queryParameters;
  final name = params['name'] ?? 'Guest';
  final age = params['age'] ?? 'unknown';
  
  final response = {
    'message': 'User Info',
    'data': {
      'name': name,
      'age': age,
      'timestamp': DateTime.now().toIso8601String(),
    }
  };
  
  return Response.ok(
    jsonEncode(response),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );
}
```

### 3. POST 请求处理
```dart
Future<Response> _loginHandler(Request request) async {
  try {
    // 1. 读取请求体
    final payload = await request.readAsString();
    final data = jsonDecode(payload) as Map<String, dynamic>;
    
    // 2. 验证参数
    final username = data['username'] as String?;
    final password = data['password'] as String?;
    
    if (username == null || password == null) {
      return Response(400, ...); // 参数错误
    }
    
    // 3. 业务逻辑
    if (username == 'admin' && password == '123456') {
      // 登录成功
      final response = {
        'success': true,
        'message': '登录成功',
        'data': { ... }
      };
      return Response.ok(jsonEncode(response), ...);
    } else {
      // 登录失败
      return Response(401, ...);
    }
  } catch (e) {
    // 异常处理
    return Response.internalServerError(...);
  }
}
```

### 4. 分页查询
```dart
Response _productsHandler(Request request) {
  // 1. 获取分页参数
  final params = request.url.queryParameters;
  final page = int.tryParse(params['page'] ?? '1') ?? 1;
  final pageSize = int.tryParse(params['pageSize'] ?? '10') ?? 10;
  
  // 2. 模拟数据源
  final products = List.generate(30, (index) => { ... });
  
  // 3. 计算分页
  final start = (page - 1) * pageSize;
  final end = start + pageSize;
  final paginatedProducts = products.sublist(
    start.clamp(0, products.length),
    end.clamp(0, products.length),
  );
  
  // 4. 返回分页数据
  final response = {
    'success': true,
    'data': paginatedProducts,
    'pagination': {
      'page': page,
      'pageSize': pageSize,
      'total': products.length,
      'totalPages': (products.length / pageSize).ceil(),
    }
  };
  
  return Response.ok(jsonEncode(response), ...);
}
```

## 🔧 使用方法

### 启动服务器

```bash
# 方式 1: 直接运行
dart lib/server_mock/main.dart

# 方式 2: 使用 dart run
dart run lib/server_mock/main.dart
```

### 测试 API

```bash
# 方式 1: 使用测试脚本
powershell -ExecutionPolicy Bypass -File lib/server_mock/test_api.ps1

# 方式 2: 手动测试
curl http://localhost:3456/hello/world
curl http://localhost:3456/api/products?page=1&pageSize=5

# 方式 3: 使用 Postman 或其他 API 测试工具
```

### 停止服务器

按 `Ctrl+C` 终止服务器进程

## 📦 依赖配置

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  shelf: ^1.4.0
  shelf_router: ^1.1.0
```

然后运行：
```bash
flutter pub get
```

## 🎨 最佳实践

### 1. 统一响应格式

成功响应：
```json
{
  "success": true,
  "data": { ... },
  "message": "操作成功"
}
```

错误响应：
```json
{
  "error": "错误类型",
  "message": "详细错误信息"
}
```

### 2. 错误处理

- 400 - 请求参数错误
- 401 - 未授权（登录失败）
- 404 - 资源不存在
- 500 - 服务器内部错误

### 3. UTF-8 编码

所有响应都应该设置正确的编码：
```dart
headers: {'Content-Type': 'application/json; charset=utf-8'}
```

### 4. 中间件顺序

```dart
Pipeline()
  .addMiddleware(logRequests())    // 1. 先记录日志
  .addMiddleware(_corsHeaders())   // 2. 再处理 CORS
  .addMiddleware(_errorHandler())  // 3. 最后捕获错误
  .addHandler(app);
```

## 🚀 扩展建议

### 1. 添加文件服务
```dart
import 'package:shelf_static/shelf_static.dart';

..mount('/static/', createStaticHandler('public'))
```

### 2. 添加 WebSocket 支持
```dart
import 'package:shelf_web_socket/shelf_web_socket.dart';
```

### 3. 添加身份验证中间件
```dart
Middleware _authMiddleware() {
  return (innerHandler) {
    return (request) async {
      final token = request.headers['Authorization'];
      if (token == null) {
        return Response.forbidden('Unauthorized');
      }
      return await innerHandler(request);
    };
  };
}
```

### 4. 数据库集成
可以集成 `sqflite`、`hive` 等数据库来持久化数据。

## 📚 学习要点

1. **Router** - 如何定义路由和路径参数
2. **Middleware** - 中间件的概念和使用
3. **Request** - 如何解析请求参数和请求体
4. **Response** - 如何构造不同类型的响应
5. **异步处理** - `async/await` 在服务器端的应用
6. **错误处理** - try-catch 和统一错误处理

## 🎯 实际应用场景

1. **Flutter 开发** - 作为 Mock 服务器进行前端开发
2. **API 设计** - 快速验证 API 接口设计
3. **原型开发** - 快速搭建原型系统
4. **学习教学** - 学习 RESTful API 和 HTTP 协议
5. **测试环境** - 提供稳定的测试数据接口

## ✅ 测试结果

所有 API 端点已通过测试：

- ✅ GET /hello/<name> - 文本响应
- ✅ GET /user - 查询参数
- ✅ POST /login - JSON 请求体
- ✅ GET /api/products - 分页查询
- ✅ GET /api/products/<id> - 路径参数
- ✅ PUT /api/products/<id> - 更新数据
- ✅ DELETE /api/products/<id> - 删除数据
- ✅ 404 处理 - 错误处理

## 🔍 调试技巧

1. **查看日志** - `logRequests()` 中间件会自动打印请求日志
2. **使用 curl** - 命令行快速测试
3. **使用 Postman** - 图形化测试工具
4. **浏览器开发者工具** - 查看网络请求详情

## 📖 参考资源

- [Shelf 官方文档](https://pub.dev/packages/shelf)
- [Shelf Router 文档](https://pub.dev/packages/shelf_router)
- [Dart HTTP 服务器指南](https://dart.dev/tutorials/server/httpserver)

---

**服务器地址:** http://localhost:3456

**默认端口:** 3456

**支持的 HTTP 方法:** GET, POST, PUT, DELETE, OPTIONS


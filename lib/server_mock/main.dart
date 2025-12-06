import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  // 创建主路由
  final app = Router()
    // GET 请求示例 - 简单文本响应
    ..get('/hello/<name>', _helloHandler)

    // GET 请求示例 - 查询参数
    ..get('/user', _userHandler)

    // POST 请求示例 - 接收 JSON 数据
    ..post('/login', _loginHandler)

    // GET 请求示例 - 返回 JSON 数据
    ..get('/api/products', _productsHandler)

    // GET 请求示例 - 带路径参数和查询参数
    ..get('/api/products/<id>', _productDetailHandler)

    // PUT 请求示例 - 更新数据
    ..put('/api/products/<id>', _updateProductHandler)

    // DELETE 请求示例
    ..delete('/api/products/<id>', _deleteProductHandler)

    // 文件上传示例
    ..post('/upload', _uploadHandler)

    // 404 处理
    ..all('/<ignored|.*>', _notFoundHandler);

  // 创建中间件管道
  final handler = Pipeline()
      .addMiddleware(logRequests()) // 请求日志
      .addMiddleware(_corsHeaders()) // CORS 支持
      .addMiddleware(_errorHandler()) // 错误处理
      .addHandler(app);

  // 启动服务器
  final server = await io.serve(handler, InternetAddress.anyIPv4, 3456);
  print('🚀 服务器启动成功!');
  print('📍 地址: http://${server.address.host}:${server.port}');
  print('\n📚 可用的 API 端点:');
  print('  GET  /hello/<name>          - 问候接口');
  print('  GET  /user?name=xxx&age=xx  - 用户查询');
  print('  POST /login                 - 登录接口 (JSON body)');
  print('  GET  /api/products          - 获取产品列表');
  print('  GET  /api/products/<id>     - 获取产品详情');
  print('  PUT  /api/products/<id>     - 更新产品');
  print('  DELETE /api/products/<id>   - 删除产品');
  print('  POST /upload                - 文件上传');
  print('\n按 Ctrl+C 停止服务器');
}

// ========== 路由处理器 ==========

/// 简单的问候接口
Response _helloHandler(Request request, String name) {
  return Response.ok(
    'Hello, $name! 欢迎使用 Shelf 服务器 🎉',
    headers: {'Content-Type': 'text/plain; charset=utf-8'},
  );
}

/// 处理查询参数示例
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

/// POST 登录接口示例
Future<Response> _loginHandler(Request request) async {
  try {
    // 读取请求体
    final payload = await request.readAsString();
    final data = jsonDecode(payload) as Map<String, dynamic>;
    print('📥 登录请求数据: $data');

    final username = data['username'] as String?;
    final password = data['password'] as String?;

    if (username == null || password == null) {
      return Response(400,
        body: jsonEncode({'error': '用户名和密码不能为空'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }

    // 模拟登录逻辑
    if (username == 'admin' && password == '123456') {
      final response = {
        'success': true,
        'message': '登录成功',
        'data': {
          'token': 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'id': 1,
            'username': username,
            'role': 'admin',
          }
        }
      };
      return Response.ok(
        jsonEncode(response),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    } else {
      return Response(401,
        body: jsonEncode({'error': '用户名或密码错误'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': '服务器错误: $e'}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  }
}

/// 获取产品列表
Response _productsHandler(Request request) {
  final params = request.url.queryParameters;
  final page = int.tryParse(params['page'] ?? '1') ?? 1;
  final pageSize = int.tryParse(params['pageSize'] ?? '10') ?? 10;

  // 模拟产品数据
  final products = List.generate(30, (index) => {
    'id': index + 1,
    'name': 'Product ${index + 1}',
    'price': (index + 1) * 10.99,
    'description': 'This is product ${index + 1}',
    'stock': (index + 1) * 5,
  });

  final start = (page - 1) * pageSize;
  final end = start + pageSize;
  final paginatedProducts = products.sublist(
    start.clamp(0, products.length),
    end.clamp(0, products.length),
  );

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

  return Response.ok(
    jsonEncode(response),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );
}

/// 获取产品详情
Response _productDetailHandler(Request request, String id) {
  final productId = int.tryParse(id);

  if (productId == null) {
    return Response(400,
      body: jsonEncode({'error': 'Invalid product ID'}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  }

  // 模拟查询产品
  final product = {
    'id': productId,
    'name': 'Product $productId',
    'price': productId * 10.99,
    'description': 'Detailed description for product $productId',
    'stock': productId * 5,
    'category': 'Electronics',
    'tags': ['new', 'popular', 'sale'],
    'images': [
      'https://picsum.photos/200/200?random=$productId',
      'https://picsum.photos/200/200?random=${productId + 1000}',
    ]
  };

  final response = {
    'success': true,
    'data': product,
  };

  return Response.ok(
    jsonEncode(response),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );
}

/// 更新产品
Future<Response> _updateProductHandler(Request request, String id) async {
  try {
    final productId = int.tryParse(id);
    if (productId == null) {
      return Response(400,
        body: jsonEncode({'error': 'Invalid product ID'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }

    final payload = await request.readAsString();
    final data = jsonDecode(payload) as Map<String, dynamic>;

    final response = {
      'success': true,
      'message': '产品更新成功',
      'data': {
        'id': productId,
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      }
    };

    return Response.ok(
      jsonEncode(response),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': '更新失败: $e'}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  }
}

/// 删除产品
Response _deleteProductHandler(Request request, String id) {
  final productId = int.tryParse(id);

  if (productId == null) {
    return Response(400,
      body: jsonEncode({'error': 'Invalid product ID'}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  }

  final response = {
    'success': true,
    'message': '产品删除成功',
    'data': {'id': productId}
  };

  return Response.ok(
    jsonEncode(response),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );
}

/// 文件上传示例
Future<Response> _uploadHandler(Request request) async {
  try {
    final contentType = request.headers['content-type'];

    if (contentType?.contains('multipart/form-data') ?? false) {
      // 这里简化处理，实际需要 shelf_multipart 包来处理文件上传
      return Response.ok(
        jsonEncode({
          'success': true,
          'message': '文件上传成功（模拟）',
          'data': {
            'filename': 'uploaded_file.txt',
            'size': 1024,
            'uploadedAt': DateTime.now().toIso8601String(),
          }
        }),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    } else {
      return Response(400,
        body: jsonEncode({'error': 'Content-Type must be multipart/form-data'}),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
    }
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': '上传失败: $e'}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
  }
}

/// 404 处理
Response _notFoundHandler(Request request) {
  return Response.notFound(
    jsonEncode({
      'error': 'Not Found',
      'message': 'The requested resource was not found',
      'path': request.url.path,
    }),
    headers: {'Content-Type': 'application/json; charset=utf-8'},
  );
}

// ========== 中间件 ==========

/// CORS 中间件
Middleware _corsHeaders() {
  return (innerHandler) {
    return (request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeadersMap);
      }

      final response = await innerHandler(request);
      return response.change(headers: _corsHeadersMap);
    };
  };
}

final _corsHeadersMap = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};

/// 错误处理中间件
Middleware _errorHandler() {
  return (innerHandler) {
    return (request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        print('❌ 错误: $error');
        print('Stack trace: $stackTrace');
        return Response.internalServerError(
          body: jsonEncode({
            'error': 'Internal Server Error',
            'message': error.toString(),
          }),
          headers: {'Content-Type': 'application/json; charset=utf-8'},
        );
      }
    };
  };
}

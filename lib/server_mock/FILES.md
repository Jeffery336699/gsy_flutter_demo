# Shelf 本地服务器 - 文件清单

## 📂 项目结构

```
lib/server_mock/
├── main.dart              # 服务器主程序（核心文件）
├── README.md              # API 使用文档
├── GUIDE.md               # 完整搭建指南
├── start_server.bat       # Windows CMD 启动脚本
├── start_server.ps1       # Windows PowerShell 启动脚本
├── test_api.ps1           # API 测试脚本
└── FILES.md               # 本文件清单
```

## 📄 文件说明

### 1. main.dart
**作用：** 服务器核心代码
**内容：**
- 路由定义（8+ 个示例路由）
- 请求处理器（Handlers）
- 中间件配置（日志、CORS、错误处理）
- 服务器启动配置

**关键功能：**
- GET 请求处理（文本、JSON、分页）
- POST 请求处理（登录、JSON 解析）
- PUT 请求处理（更新数据）
- DELETE 请求处理（删除数据）
- 路径参数解析
- 查询参数解析
- 统一错误处理
- CORS 支持

### 2. README.md
**作用：** API 使用文档
**内容：**
- 快速启动指南
- 所有 API 端点的详细说明
- 请求示例（curl 命令）
- 响应示例（JSON）
- 技术特性说明
- 测试建议

**适合：** 需要快速查看 API 接口的开发者

### 3. GUIDE.md
**作用：** 完整搭建指南
**内容：**
- 架构设计说明
- 详细代码解析
- 每个功能的实现细节
- 最佳实践
- 扩展建议
- 学习要点
- 参考资源

**适合：** 需要深入理解 Shelf 框架的学习者

### 4. start_server.bat
**作用：** Windows CMD 启动脚本
**功能：**
- 自动切换到项目根目录
- 检查并安装依赖
- 启动服务器
- 显示服务器信息

**使用：**
```cmd
lib\server_mock\start_server.bat
```

### 5. start_server.ps1
**作用：** Windows PowerShell 启动脚本
**功能：**
- 自动切换到项目根目录
- 检查并安装依赖
- 启动服务器
- 彩色输出（更友好的界面）

**使用：**
```powershell
.\lib\server_mock\start_server.ps1
```

### 6. test_api.ps1
**作用：** 自动化 API 测试脚本
**功能：**
- 测试所有 9 个 API 端点
- 自动发送请求
- 格式化显示响应
- 彩色输出（成功/失败/警告）
- 包含正常和异常场景测试

**使用：**
```powershell
powershell -ExecutionPolicy Bypass -File lib\server_mock\test_api.ps1
```

**测试的接口：**
1. ✅ Hello 接口（GET）
2. ✅ 用户查询接口（GET + 查询参数）
3. ✅ 登录接口 - 成功（POST + JSON）
4. ✅ 登录接口 - 失败（POST + JSON）
5. ✅ 产品列表（GET + 分页）
6. ✅ 产品详情（GET + 路径参数）
7. ✅ 更新产品（PUT + JSON）
8. ✅ 删除产品（DELETE）
9. ✅ 404 错误处理

### 7. FILES.md
**作用：** 本文件清单
**内容：**
- 项目文件结构
- 每个文件的作用和说明
- 使用指南

## 🚀 快速开始

### 第一次使用

1. **安装依赖**
   ```bash
   flutter pub get
   ```

2. **启动服务器**
   ```bash
   # 使用启动脚本（推荐）
   .\lib\server_mock\start_server.ps1
   
   # 或直接运行
   dart lib/server_mock/main.dart
   ```

3. **测试 API**
   ```powershell
   # 运行测试脚本
   powershell -ExecutionPolicy Bypass -File lib\server_mock\test_api.ps1
   
   # 或手动测试
   curl http://localhost:3456/hello/world
   ```

### 日常使用

1. **启动服务器**
   ```powershell
   .\lib\server_mock\start_server.ps1
   ```

2. **在 Flutter 应用中使用**
   ```dart
   import 'package:http/http.dart' as http;
   
   // 调用 API
   final response = await http.get(
     Uri.parse('http://localhost:3456/api/products?page=1&pageSize=10')
   );
   ```

3. **停止服务器**
   按 `Ctrl+C`

## 📋 依赖要求

### Dart SDK
- 版本: >=3.0.0 <4.0.0

### 依赖包
```yaml
dependencies:
  shelf: ^1.4.0
  shelf_router: ^1.1.0
```

## 🔧 配置说明

### 服务器端口
默认端口：`3456`

修改端口：编辑 `main.dart` 第 45 行
```dart
final server = await io.serve(handler, InternetAddress.anyIPv4, 3456);
//                                                                  ^^^^
//                                                                  修改这里
```

### CORS 配置
在 `main.dart` 的 `_corsHeadersMap` 中配置：
```dart
final _corsHeadersMap = {
  'Access-Control-Allow-Origin': '*',  // 允许所有来源
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
};
```

## 🎯 使用场景

1. **Flutter 应用开发**
   - 作为 Mock 服务器
   - 前端开发时不依赖后端
   - 快速验证业务逻辑

2. **API 设计验证**
   - 快速搭建原型接口
   - 验证 API 设计合理性
   - 与前端团队对接

3. **学习和教学**
   - 学习 RESTful API
   - 学习 HTTP 协议
   - 学习 Dart 服务端开发

4. **测试环境**
   - 提供稳定的测试数据
   - 模拟各种响应场景
   - 集成测试

## ⚠️ 注意事项

1. **端口占用**
   - 如果端口 3456 被占用，服务器会启动失败
   - 可以修改端口号或关闭占用端口的程序

2. **仅供开发使用**
   - 这是一个开发/测试服务器
   - 不适合生产环境
   - 没有实现身份验证、数据持久化等生产级功能

3. **数据持久化**
   - 当前所有数据都是临时的
   - 服务器重启后数据会重置
   - 如需持久化，请集成数据库

4. **并发处理**
   - Shelf 支持并发请求
   - 但当前实现是单线程的
   - 复杂业务建议使用 Isolate

## 📚 扩展阅读

### 学习资源
- [Shelf 官方文档](https://pub.dev/packages/shelf)
- [Shelf Router 文档](https://pub.dev/packages/shelf_router)
- [Dart HTTP 服务器教程](https://dart.dev/tutorials/server/httpserver)

### 相关包
- `shelf_static` - 静态文件服务
- `shelf_web_socket` - WebSocket 支持
- `shelf_multipart` - 文件上传支持
- `shelf_proxy` - 代理支持

## 🎉 测试结果

所有 API 已通过测试，测试时间：2025-12-06

测试工具：PowerShell + Invoke-RestMethod

测试结果：✅ 100% 通过

---

**项目版本：** 1.0.0  
**创建日期：** 2025-12-06  
**Dart SDK：** >=3.0.0 <4.0.0  
**服务器地址：** http://localhost:3456


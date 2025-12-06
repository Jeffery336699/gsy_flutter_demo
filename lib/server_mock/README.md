# Shelf 本地服务器使用指南

基于 Dart 官方 Shelf 框架搭建的本地 HTTP 服务器，包含多个 RESTful API 示例。

## 🚀 启动服务器

### 方式 1: 使用启动脚本（推荐）

**Windows (CMD):**
```bash
lib\server_mock\start_server.bat
```

**Windows (PowerShell):**
```powershell
.\lib\server_mock\start_server.ps1
```

### 方式 2: 直接运行

```bash
dart lib/server_mock/main.dart
```

服务器将在 `http://localhost:3456` 启动

## 📚 API 端点列表

### 1. 简单问候接口
**GET** `/hello/<name>`

返回简单的问候文本。

**示例：**
```bash
curl http://localhost:3456/hello/world
# 返回: Hello, world! 欢迎使用 Shelf 服务器 🎉
```

---

### 2. 用户查询接口（查询参数）
**GET** `/user?name=xxx&age=xx`

演示如何处理查询参数。

**示例：**
```bash
curl "http://localhost:3456/user?name=张三&age=25"
# 返回 JSON:
# {
#   "message": "User Info",
#   "data": {
#     "name": "张三",
#     "age": "25",
#     "timestamp": "2025-12-06T15:30:18.519862"
#   }
# }
```

---

### 3. 登录接口（POST + JSON Body）
**POST** `/login`

演示如何接收和处理 JSON 请求体。

**示例：**
```bash
curl -X POST http://localhost:3456/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"123456"}'

# 成功返回:
# {
#   "success": true,
#   "message": "登录成功",
#   "data": {
#     "token": "mock_token_1234567890",
#     "user": {
#       "id": 1,
#       "username": "admin",
#       "role": "admin"
#     }
#   }
# }

# 失败返回:
# {"error": "用户名或密码错误"}
```

---

### 4. 获取产品列表（分页）
**GET** `/api/products?page=1&pageSize=10`

演示分页查询功能。

**示例：**
```bash
curl "http://localhost:3456/api/products?page=1&pageSize=5"

# 返回:
# {
#   "success": true,
#   "data": [
#     {
#       "id": 1,
#       "name": "Product 1",
#       "price": 10.99,
#       "description": "This is product 1",
#       "stock": 5
#     },
#     ...
#   ],
#   "pagination": {
#     "page": 1,
#     "pageSize": 5,
#     "total": 30,
#     "totalPages": 6
#   }
# }
```

---

### 5. 获取产品详情（路径参数）
**GET** `/api/products/<id>`

演示如何处理路径参数。

**示例：**
```bash
curl http://localhost:3456/api/products/10

# 返回:
# {
#   "success": true,
#   "data": {
#     "id": 10,
#     "name": "Product 10",
#     "price": 109.9,
#     "description": "Detailed description for product 10",
#     "stock": 50,
#     "category": "Electronics",
#     "tags": ["new", "popular", "sale"],
#     "images": [
#       "https://picsum.photos/200/200?random=10",
#       "https://picsum.photos/200/200?random=1010"
#     ]
#   }
# }
```

---

### 6. 更新产品（PUT）
**PUT** `/api/products/<id>`

演示如何处理 PUT 请求更新资源。

**示例：**
```bash
curl -X PUT http://localhost:3456/api/products/10 \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated Product","price":99.99}'

# 返回:
# {
#   "success": true,
#   "message": "产品更新成功",
#   "data": {
#     "id": 10,
#     "name": "Updated Product",
#     "price": 99.99,
#     "updatedAt": "2025-12-06T15:35:20.123456"
#   }
# }
```

---

### 7. 删除产品（DELETE）
**DELETE** `/api/products/<id>`

演示如何处理 DELETE 请求。

**示例：**
```bash
curl -X DELETE http://localhost:3456/api/products/10

# 返回:
# {
#   "success": true,
#   "message": "产品删除成功",
#   "data": {"id": 10}
# }
```

---

### 8. 文件上传（模拟）
**POST** `/upload`

演示文件上传接口（简化版）。

**示例：**
```bash
curl -X POST http://localhost:3456/upload \
  -H "Content-Type: multipart/form-data"

# 返回:
# {
#   "success": true,
#   "message": "文件上传成功（模拟）",
#   "data": {
#     "filename": "uploaded_file.txt",
#     "size": 1024,
#     "uploadedAt": "2025-12-06T15:40:00.000000"
#   }
# }
```

---

## 🛠️ 技术特性

### 中间件
1. **日志中间件** (`logRequests()`) - 自动记录所有请求
2. **CORS 中间件** - 支持跨域请求
3. **错误处理中间件** - 统一处理异常

### 路由功能
- ✅ 路径参数：`/api/products/<id>`
- ✅ 查询参数：`/user?name=xxx&age=xx`
- ✅ JSON 请求体解析
- ✅ 多种 HTTP 方法：GET, POST, PUT, DELETE
- ✅ 404 处理

### 响应类型
- 纯文本响应
- JSON 响应
- 自定义状态码（200, 400, 401, 404, 500）

## 📦 依赖包

```yaml
dependencies:
  shelf: ^1.4.0           # HTTP 服务器框架
  shelf_router: ^1.1.0    # 路由支持
```

## 🔍 测试建议

1. **使用 curl 测试**（命令行）
2. **使用 Postman**（图形化界面）
3. **使用浏览器**（仅 GET 请求）
4. **使用 VS Code REST Client 扩展**

## 📝 注意事项

1. 服务器默认端口：`3456`
2. 如果端口被占用，会启动失败
3. 按 `Ctrl+C` 停止服务器
4. 所有响应都支持 UTF-8 编码
5. CORS 已启用，支持跨域请求

## 🎯 实际应用场景

- Flutter 应用开发时的 Mock 服务器
- 快速原型开发
- API 接口设计验证
- 前后端联调
- 学习 RESTful API 设计


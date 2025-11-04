# 本地缓存图片组件设计说明

## 概述
本组件参考 Flutter 系统的 `NetworkImage` 设计思想，实现了具备本地文件缓存功能的图片加载组件。

## 核心设计

### 1. CachedImageProvider (图片提供者)
继承自 `ImageProvider<CachedImageProvider>`，负责图片的加载和解码：

- **obtainKey**: 返回用于标识图片的唯一键
- **loadImage**: 返回 `ImageStreamCompleter`，处理异步加载流程
- **_loadAsync**: 核心加载逻辑
  1. 先检查本地缓存
  2. 如果缓存存在，直接从缓存读取
  3. 如果缓存不存在，通过 HTTP 下载
  4. 下载成功后保存到本地缓存
  5. 解码图片返回 Codec

### 2. CachedImageManager (缓存管理器)
单例模式，负责文件缓存的管理：

- **cachePath**: 获取缓存目录（使用 `path_provider` 的临时目录）
- **getCachedFile**: 根据 URL 获取缓存文件
- **cacheImage**: 保存图片到本地缓存
- **isCached**: 检查图片是否已缓存
- **clearCache**: 清除所有缓存
- **getCacheSize**: 获取缓存总大小

**缓存文件命名**: 使用 URL 的 MD5 哈希值作为文件名，避免特殊字符问题

### 3. CachedImage (UI 组件)
封装后的使用组件，提供友好的 API：

```dart
CachedImage(
  url: 'https://example.com/image.jpg',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
  placeholder: Widget,  // 加载中占位符
  errorWidget: Widget,  // 错误时显示的组件
)
```

## 与 NetworkImage 的对比

| 特性 | NetworkImage | CachedImageProvider |
|------|-------------|---------------------|
| 网络加载 | ✓ | ✓ |
| 内存缓存 | ✓ | ✓ |
| 磁盘缓存 | ✗ | ✓ |
| 缓存管理 | ✗ | ✓ |
| 离线访问 | ✗ | ✓ |

## 技术要点

### 1. ImageProvider 生命周期
```
resolveStreamForKey → obtainKey → loadImage → ImageStreamCompleter → Codec
```

### 2. 异步加载流程
使用 `MultiFrameImageStreamCompleter` 包装异步 Codec Future，支持动图（GIF）。

### 3. 图片解码
使用 `ui.ImmutableBuffer` 和 `ImageDecoderCallback` 进行高效解码。

### 4. 缓存策略
- **位置**: 使用临时目录（可在应用设置中清除）
- **命名**: MD5(URL) 确保唯一性
- **持久化**: 文件级别的持久化缓存

## 使用示例

```dart
// 基础使用
CachedImage(
  url: 'https://picsum.photos/300/200',
  width: 300,
  height: 200,
  fit: BoxFit.cover,
)

// 检查缓存状态
final isCached = await CachedImageManager.instance.isCached(url);

// 清除缓存
await CachedImageManager.instance.clearCache();

// 获取缓存大小
final size = await CachedImageManager.instance.getCacheSize();
```

## 优化建议

1. **缓存过期策略**: 添加时间戳，自动清理过期缓存
2. **缓存大小限制**: 实现 LRU 算法，限制总缓存大小
3. **并发控制**: 限制同时下载的图片数量
4. **预加载**: 支持预加载多张图片
5. **压缩策略**: 根据显示尺寸自动压缩图片

## 依赖

- `path_provider: ^2.1.0` - 获取缓存目录
- `crypto: ^3.0.3` - MD5 哈希计算

## 优势

1. **离线可用**: 已加载的图片可离线访问
2. **减少流量**: 避免重复下载
3. **加载速度**: 本地读取比网络加载快得多
4. **用户体验**: 减少等待时间，提升流畅度
5. **可控性**: 提供完整的缓存管理 API


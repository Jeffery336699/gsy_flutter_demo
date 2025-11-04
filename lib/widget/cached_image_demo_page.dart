import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// 自定义缓存图片组件演示页面
/// 参考 NetworkImage 的设计思想，实现本地缓存功能
class CachedImageDemoPage extends StatefulWidget {
  const CachedImageDemoPage({super.key});

  @override
  State<CachedImageDemoPage> createState() => _CachedImageDemoPageState();
}

class _CachedImageDemoPageState extends State<CachedImageDemoPage> {
  final List<String> imageUrls = [
    'https://picsum.photos/300/200?random=1',
    'https://picsum.photos/300/200?random=2',
    'https://picsum.photos/300/200?random=3',
    'https://picsum.photos/300/200?random=4',
    'https://picsum.photos/300/200?random=5',
    'https://picsum.photos/300/200?random=6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本地缓存图片组件'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await CachedImageManager.instance.clearCache();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('缓存已清除')),
                );
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '图片 ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedImage(
                    url: imageUrls[index],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder<bool>(
                  future: CachedImageManager.instance.isCached(imageUrls[index]),
                  builder: (context, snapshot) {
                    final isCached = snapshot.data ?? false;
                    return Text(
                      isCached ? '✓ 已缓存' : '○ 未缓存',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCached ? Colors.green : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

/// 自定义缓存图片组件
class CachedImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Image(
        image: CachedImageProvider(widget.url),
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          /// 这里直接命中系统imageCache单例中的内存缓存，所以说本地缓存写完之后自带内存缓存功能！！！
          if (wasSynchronouslyLoaded) {
            // wasSynchronouslyLoaded:true，url:https://picsum.photos/300/200?random=3，true
            print('wasSynchronouslyLoaded:$wasSynchronouslyLoaded，url:${widget.url}，'
                '${PaintingBinding.instance.imageCache.containsKey(CachedImageProvider(widget.url))}');
            return child;
          }
          return frame != null
              ? child
              : widget.placeholder ??
                  Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  );
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ??
              Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              );
        },
      ),
    );
  }
}

/// 自定义图片提供者，参考 NetworkImage 实现
class CachedImageProvider extends ImageProvider<CachedImageProvider> {
  /// 内部仅根据url做key，重写了==和hashCode
  final String url;

  const CachedImageProvider(this.url);

  @override
  Future<CachedImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CachedImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(CachedImageProvider key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      debugLabel: url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<CachedImageProvider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    CachedImageProvider key,
    ImageDecoderCallback decode,
  ) async {
    assert(key == this);

    try {
      // 1. 先检查缓存
      final cachedFile = await CachedImageManager.instance.getCachedFile(url);

      if (cachedFile != null && await cachedFile.exists()) {
        // 从缓存加载
        final bytes = await cachedFile.readAsBytes();
        final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
        return decode(buffer);
      }

      // 2. 下载图片
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw Exception('HTTP request failed, statusCode: ${response.statusCode}');
      }

      // 3. 读取数据
      final bytes = await consolidateHttpClientResponseBytes(response);

      // 4. 保存到缓存
      await CachedImageManager.instance.cacheImage(url, bytes);

      // 5. 解码图片
      final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      return decode(buffer);
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is CachedImageProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '${objectRuntimeType(this, 'CachedImageProvider')}("$url")';
}

/// 缓存管理器
class CachedImageManager {
  static final CachedImageManager instance = CachedImageManager._();

  CachedImageManager._();

  String? _cachePath;

  /// 获取缓存目录
  Future<String> get cachePath async {
    if (_cachePath != null) return _cachePath!;

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/image_cache';
    final dir = Directory(path);

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    _cachePath = path;
    return path;
  }

  /// 获取 URL 对应的缓存文件名（使用 MD5）
  String _getCacheFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// 获取缓存文件
  Future<File?> getCachedFile(String url) async {
    try {
      final path = await cachePath;
      final fileName = _getCacheFileName(url);
      final file = File('$path/$fileName');

      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('获取缓存文件失败: $e');
      }
      return null;
    }
  }

  /// 缓存图片
  Future<void> cacheImage(String url, Uint8List bytes) async {
    try {
      final path = await cachePath;
      final fileName = _getCacheFileName(url);
      final file = File('$path/$fileName');
      await file.writeAsBytes(bytes);

      if (kDebugMode) {
        print('图片已缓存: $fileName');
      }
    } catch (e) {
      if (kDebugMode) {
        print('缓存图片失败: $e');
      }
    }
  }

  /// 检查是否已缓存
  Future<bool> isCached(String url) async {
    final file = await getCachedFile(url);
    return file != null && await file.exists();
  }

  /// 清除所有缓存
  Future<void> clearCache() async {
    try {
      final path = await cachePath;
      final dir = Directory(path);

      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create();
        _cachePath = null;

        if (kDebugMode) {
          print('缓存已清除');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('清除缓存失败: $e');
      }
    }
  }

  /// 获取缓存大小
  Future<int> getCacheSize() async {
    try {
      final path = await cachePath;
      final dir = Directory(path);

      if (!await dir.exists()) return 0;

      int totalSize = 0;
      await for (var entity in dir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      if (kDebugMode) {
        print('获取缓存大小失败: $e');
      }
      return 0;
    }
  }
}


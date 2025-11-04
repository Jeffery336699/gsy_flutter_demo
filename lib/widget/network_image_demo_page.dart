import 'package:flutter/material.dart';

import 'multi_step_form.dart';

/// 网络图片加载演示页面
/// 演示不同的网络图片加载方式和状态处理
class NetworkImageDemoPage extends StatefulWidget {
  const NetworkImageDemoPage({super.key});

  @override
  State<NetworkImageDemoPage> createState() => _NetworkImageDemoPageState();
}

class _NetworkImageDemoPageState extends State<NetworkImageDemoPage> {
  final String imageUrl1 = 'https://picsum.photos/400/300';
  final String imageUrl2 = 'https://picsum.photos/400/400';
  final String imageUrl3 = 'https://picsum.photos/500/300';
  final String errorUrl = 'https://invalid-url-for-demo.com/image.jpg';
  GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // 没法正确获取，图片还在加载中
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final RenderBox? renderBox =
    //       imageKey.currentContext?.findRenderObject() as RenderBox?;
    //   if (renderBox != null) {
    //     final size = renderBox.size;
    //     final position = renderBox.localToGlobal(Offset.zero);
    //     debugPrint('Image position: $position, size: $size');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络图片加载演示'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            '1. 基础 Image.network',
            _buildBasicNetworkImage(),
          ),
          const SizedBox(height: 20),
          // _buildSection(
          //   '2. 带加载进度的图片',
          //   _buildImageWithProgress(),
          // ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MultiStepForm()));
            },
            child: ListTile(
              title: Text('表单多步骤切换'),
              subtitle: Text(
                '保持所有步骤的状态,避免重新构建导致用户输入丢失',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreloadedContentPage()));
            },
            child: ListTile(
              title: Text('预加载和缓存复杂组件'),
              subtitle: Text('提前构建但隐藏,需要时立即显示'),
            ),
          ),
          // _buildSection(
          //   '3. 带占位符和错误处理',
          //   _buildImageWithPlaceholder(),
          // ),
          // const SizedBox(height: 20),
          // _buildSection(
          //   '4. 圆形头像加载',
          //   _buildCircleAvatar(),
          // ),
          // const SizedBox(height: 20),
          // _buildSection(
          //   '5. 多张图片网格加载',
          //   _buildImageGrid(),
          // ),
          // const SizedBox(height: 20),
          // _buildSection(
          //   '6. 自定义加载状态',
          //   _buildCustomLoadingImage(),
          // ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ],
    );
  }

  /// 基础网络图片加载
  Widget _buildBasicNetworkImage() {
    return Image.network(
      key: imageKey,
      imageUrl1,
      height: 200,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child; // 如果是同步加载（比如已经在内存cache中），直接显示图片
        }
        var animatedOpacity = AnimatedOpacity(
          opacity: frame == null ? 0 : 1, // 帧为空时透明，否则不透明
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: child,
        );
        if (frame != null) {
          /// 图片加载完成后，在下一帧获取其尺寸和位置(正确！)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final RenderBox? renderBox =
                imageKey.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox != null && renderBox.hasSize) {
              final size = renderBox.size;
              final position = renderBox.localToGlobal(Offset.zero);
              debugPrint('Image position 22: $position, size: $size');
            }
          });
        }
        return animatedOpacity;
      },
    );
  }

  /// 带加载进度的图片
  Widget _buildImageWithProgress() {
    return Image.network(
      imageUrl2,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  /// 带占位符和错误处理的图片
  Widget _buildImageWithPlaceholder() {
    return Image.network(
      errorUrl,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          height: 200,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('加载中...'),
            ],
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 200,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 50, color: Colors.grey),
              SizedBox(height: 10),
              Text('图片加载失败'),
            ],
          ),
        );
      },
    );
  }

  /// 圆形头像加载
  Widget _buildCircleAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAvatar(imageUrl1, 60),
        _buildAvatar(imageUrl2, 80),
        _buildAvatar(imageUrl3, 60),
      ],
    );
  }

  Widget _buildAvatar(String url, double size) {
    return ClipOval(
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade300,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade400,
            child: const Icon(Icons.person, color: Colors.white),
          );
        },
      ),
    );
  }

  /// 多张图片网格加载
  Widget _buildImageGrid() {
    final List<String> urls = [
      'https://picsum.photos/200/200?random=1',
      'https://picsum.photos/200/200?random=2',
      'https://picsum.photos/200/200?random=3',
      'https://picsum.photos/200/200?random=4',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: urls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            urls[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 自定义加载状态的图片
  Widget _buildCustomLoadingImage() {
    return Image.network(
      'https://picsum.photos/400/250',
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        final percent = loadingProgress.expectedTotalBytes != null
            ? (loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes! *
                    100)
                .toInt()
            : 0;

        return Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade300],
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              if (loadingProgress.expectedTotalBytes != null)
                Text(
                  '$percent%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 200,
          color: Colors.red.shade100,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 50, color: Colors.red),
              SizedBox(height: 10),
              Text('加载失败，请检查网络连接'),
            ],
          ),
        );
      },
    );
  }
}

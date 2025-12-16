import 'package:flutter/material.dart';

/// 主页面 - 进销存系统
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '进销存系统',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 使用 Material 3 规范
        useMaterial3: true,
        // 设置主色调
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F5FD), // 浅蓝灰色背景初步设定
      ),
      home: const InventoryHomePage(),
    );
  }
}

class InventoryHomePage extends StatelessWidget {
  const InventoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取屏幕尺寸，用于适配
    final size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'PingFang SC',
        ),
      ),
      child: Scaffold(
        // 使用 Container + Gradient 模拟全屏的微光渐变背景
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFCBDDFC), // 顶部接近白色
                Color(0xFFFFFFFF).withOpacity(0.4), // 底部淡蓝色
                Color(0xFFF2F2FF), // 顶部接近白色
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 78),
                  // 1. 头部标题 (带渐变色)
                  const _GradientHeaderTitle(),

                  const SizedBox(height: 17),

                  // 2. 主功能卡片 (扫码出库)
                  const _MainActionCard(),

                  const SizedBox(height: 8),

                  // 3. 次要菜单 (查看领料单)
                  const _SecondaryMenuItem(),

                  // 使用 Spacer 撑开中间空间，将底部内容推到底部
                  const Spacer(),

                  // 4. 底部退出与版权区
                  const _FooterSection(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 组件封装区域 ---

/// 1. 头部渐变标题
/// 使用 ShaderMask 实现文字渐变效果
class _GradientHeaderTitle extends StatelessWidget {
  const _GradientHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF3168D5),
          Color(0xFFBF34FF),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: const Text(
        '襄阳再生金属公司进销存系统',
        style: TextStyle(
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w700,
          color: Colors.white, // 底色必须是白色
        ),
      ),
    );
  }
}

/// 2. 主功能卡片 (蓝色背景)
class _MainActionCard extends StatelessWidget {
  const _MainActionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B68FF).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF5B94E6), // 左上角亮蓝
            Color(0xFF3168D5),
            Color(0xFF3F3DDA), // 右下角深蓝
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 21),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '扫码出库',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '对生产计划中的物料进行扫码出库',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                // 右侧扫码图标区域
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                    //todo 边框样式
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded, // 如果需要更像图中的，可能需要用 CustomPaint 或 SVG
                    color: Colors.white,
                    size: 42,
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

/// 3. 次要菜单项 (白色背景)
class _SecondaryMenuItem extends StatelessWidget {
  const _SecondaryMenuItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 20,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: 处理点击事件
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.format_list_bulleted_rounded,
                  color: const Color(0xFF264DF3),
                  size: 20,
                ),
                const SizedBox(width: 6),
                const Text(
                  '查看领料单',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF264DF3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 4. 底部退出按钮与 Label
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 退出登录按钮
        SizedBox(
          width: 108,
          height: 38,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side:  BorderSide(color: Color(0xFF666666).withOpacity(0.2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent,
              // overlayColor: Colors.grey.withOpacity(0.1),
            ),
            child: const Text(
              '退出登录',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
                fontFamily: 'Noto Sans SC'
              ),
            ),
          ),
        ),

        const SizedBox(height: 36),

        // 底部文字带分割线
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: Divider(
                color: Color(0xFFE2E2E2),
              ),
            ),
            const Text(
              '进销存手持终端',
              style: TextStyle(
                color: Color(0xFFBBBBBB),
                fontSize: 14,
                height: 1.7,
                fontFamily: 'Noto Sans SC'
              ),
            ),
            SizedBox(
              width: 80,
              child: Divider(
                color: Color(0xFFE2E2E2),
              ),
            )
          ],
        ),
      ],
    );
  }
}



import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('GSY Flutter Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildMasonryLayout(),
        ),
      ),
    );
  }

  Widget _buildMasonryLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildMIUICard(),
                  const SizedBox(height: 8),
                  _buildTagCard(),
                  const SizedBox(height: 8),
                  _buildTextCard('共享元素 例子'),
                  const SizedBox(height: 8),
                  _buildTextCard('试定错误 例子'),
                  const SizedBox(height: 8),
                  _buildTextCard('键盘组 例子'),
                  const SizedBox(height: 8),
                  _buildTextCard('动画 例子'),
                  const SizedBox(height: 8),
                  _buildRichTextCard(),
                  const SizedBox(height: 8),
                  _buildTextLineHeightCard(),
                  const SizedBox(height: 8),
                  _buildBookPageCard(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  _buildDemoCard(),
                  const SizedBox(height: 8),
                  _buildFoodCard(),
                  const SizedBox(height: 8),
                  _buildFlutterDescCard(),
                  const SizedBox(height: 8),
                  _buildSliverListCard(),
                  const SizedBox(height: 8),
                  _buildClipDemoCard(),
                  const SizedBox(height: 8),
                  _buildBoxDecorationCard(),
                  const SizedBox(height: 8),
                  _buildGeometricShapesCard(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  _buildGuideWindowCard(),
                  const SizedBox(height: 8),
                  _buildRulerCard(),
                  const SizedBox(height: 8),
                  _build3DRulerCard(),
                  const SizedBox(height: 8),
                  _buildCatCard(),
                  const SizedBox(height: 8),
                  _buildCustomMultiRenderCard(),
                  const SizedBox(height: 8),
                  _buildBirdCard(),
                  const SizedBox(height: 8),
                  _buildTagDemoCard(),
                  const SizedBox(height: 8),
                  _buildViewPagerCard(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMIUICard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF87CEEB), Color(0xFF90EE90)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '13',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'MIUI 13',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '暂不支持访问',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tag 例子',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildRichTextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: Colors.black87),
              children: [
                TextSpan(text: 'A Text Link '),
                TextSpan(
                  text: '🥐🥐',
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(text: ' '),
                TextSpan(text: '@Somebody'),
                TextSpan(text: ' #RealRichText# showing a bigger image '),
                TextSpan(
                  text: '🍞',
                  style: TextStyle(fontSize: 16),
                ),
                TextSpan(
                  text: ' and seems working perfect.....',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLineHeightCard() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 12,
            left: 12,
            child: Text(
              '11:12',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const Positioned(
            top: 36,
            left: 12,
            child: Text(
              'TextLineHeightDemoPage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Item 0',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 16),
                  const Text('Item 1', style: TextStyle(fontSize: 12)),
                  const Divider(height: 16),
                  const Text('Item 2', style: TextStyle(fontSize: 12)),
                  const Divider(height: 16),
                  const Text('Item 3', style: TextStyle(fontSize: 12)),
                  const Divider(height: 16),
                  const Text('Item 4', style: TextStyle(fontSize: 12)),
                  const Divider(height: 16),
                  const Text('Item 5', style: TextStyle(fontSize: 12)),
                  const Divider(height: 16),
                  const Text('Item 6', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookPageCard() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00CED1), Color(0xFF32CD32)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '11:12',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          const Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Text(
              'BookPage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                height: 240,
                color: Colors.yellow.withOpacity(0.8),
                child: CustomPaint(
                  painter: _YellowDiagonalPainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              '按钮',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey[800]!, Colors.grey[600]!],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 60,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '食谱图片示例',
                      style: TextStyle(fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlutterDescCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.account_circle, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 8),
              const Text(
                '4:17',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Flutter is Google's portable UI toolkit for crafting beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSliverListCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 16,
            left: 16,
            child: Text(
              '5:42',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'SliverListDemoPage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 85,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              color: Colors.orange[300],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('按钮1', style: TextStyle(fontSize: 12)),
                  Text('按钮2', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClipDemoCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 3),
            ),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(12),
              ),
              transform: Matrix4.rotationZ(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxDecorationCard() {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BoxDecoration 图层示例 child',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('static/gsy_cat.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'ClipRRect 图层示例 child',
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildGeometricShapesCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShapeBox(Colors.blue[700]!),
                    const SizedBox(width: 8),
                    _buildShapeBox(Colors.blue[700]!),
                  ],
                ),
                const SizedBox(height: 8),
                _buildShapeBox(Colors.blue[500]!),
              ],
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Item 8',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShapeBox(Color color) {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildGuideWindowCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Icon(Icons.star, color: Colors.red, size: 24),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              '4:52',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Positioned(
            top: 36,
            left: 16,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'GuideWindowDemoPage',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulerCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.brown[400]!, Colors.brown[700]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background text cloud
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 2,
                children: [
                  _buildCloudText('CloudGSY', 10, Colors.orange[200]!),
                  _buildCloudText('CloudGSY11', 8, Colors.orange[300]!),
                  _buildCloudText('CloudGSY111', 9, Colors.orange[200]!),
                  _buildCloudText('CloudGSY1111', 7, Colors.orange[400]!),
                  _buildCloudText('CloudGSY11111', 11, Colors.orange[200]!),
                  _buildCloudText('CloudGSY111111', 8, Colors.orange[300]!),
                  _buildCloudText('CloudGSY1111111', 9, Colors.orange[200]!),
                  _buildCloudText('CloudGSY11111111', 7, Colors.orange[400]!),
                  _buildCloudText('CloudGSY88888888', 6, Colors.red[300]!),
                  _buildCloudText('CloudGSY99', 8, Colors.orange[200]!),
                  _buildCloudText('CloudGSY722', 7, Colors.orange[300]!),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 85,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'CloudGSY55',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloudText(String text, double size, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _build3DRulerCard() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF90EE90), Color(0xFFFFEB3B)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.3)
                ..rotateY(-0.4),
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CustomPaint(
                  painter: _RulerPainter(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('static/gsy_cat.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'GSY22222',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomMultiRenderCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(Icons.star, color: Colors.red, size: 20),
          ),
          const Positioned(
            top: 12,
            left: 12,
            child: Text(
              '4:06',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const Positioned(
            top: 32,
            left: 12,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'CustomMultiRenderDemoPage',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberCircle('0', Colors.blue[400]!),
                        _buildNumberCircle('4', Colors.blue[600]!),
                        _buildNumberCircle('1', Colors.blue[400]!),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberCircle('3', Colors.blue[400]!),
                        _buildNumberCircle('2', Colors.blue[600]!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberCircle(String number, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBirdCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF87CEEB), Color(0xFF4682B4)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF87CEEB),
                shape: BoxShape.circle,
              ),
              child: const Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 20,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, color: Colors.black, size: 12),
                        SizedBox(width: 8),
                        Icon(Icons.circle, color: Colors.black, size: 12),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    child: Icon(Icons.arrow_drop_down, color: Colors.orange, size: 20),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'GSY Flutter Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagDemoCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(Icons.star, color: Colors.red, size: 20),
          ),
          const Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'TagDemoPage',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notification_important, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'Test1',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewPagerCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(Icons.star, color: Colors.red, size: 20),
          ),
          const Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                Icon(Icons.arrow_back, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'ViewPagerDemoPage',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 170,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              color: Colors.blue[700],
              child: const Center(
                child: Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YellowDiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Add some text lines
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '暂不支持的功能',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(20, size.height - 100));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;

    // Draw ruler marks
    for (int i = 0; i < 10; i++) {
      final x = (i + 1) * size.width / 11;
      final y1 = size.height * 0.3;
      final y2 = i % 2 == 0 ? size.height * 0.5 : size.height * 0.4;
      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }

    // Draw dots
    for (int i = 0; i < 8; i++) {
      final x = (i + 1.5) * size.width / 10;
      final y = size.height * 0.7;
      canvas.drawCircle(Offset(x, y), 2, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

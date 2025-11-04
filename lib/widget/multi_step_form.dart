import 'package:flutter/material.dart';
import 'package:gsy_flutter_demo/widget/exts/ext.dart';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;

  // 保存各步骤的状态
  final _step1Controller = TextEditingController();
  final _step2Controller = TextEditingController();
  final _step3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: PaintListener(onPaint: () {
        // print('AppBar标题被绘制了');
      },
      child: const Text('多步骤表单'))),
      body: Column(
        children: [
          // 步骤指示器
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.all(4),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentStep >= index ? Colors.blue : Colors.grey,
                ),
                child: Center(child: Text('${index + 1}')),
              );
            }),
          ),

          Expanded(
            child: Stack(
              children: [
                // 步骤1 - 个人信息
                Offstage(
                  offstage: _currentStep != 0,
                  child: _buildStep1(),
                ),
                // 步骤2 - 联系方式
                Offstage(
                  offstage: _currentStep != 1,
                  child: _buildStep2(),
                ),
                // 步骤3 - 确认信息
                Offstage(
                  offstage: _currentStep != 2,
                  child: _buildStep3(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Offstage(
                offstage: _currentStep != index,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentStep >= index ? Colors.blue : Colors.grey,
                  ),
                  child: Center(child: Text('${index + 1}')),
                )
              );
            }),
          ).withBorder(),
          // 导航按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentStep > 0
                      ? () => setState(() => _currentStep--)
                      : null,
                  child: const Text('上一步'),
                ),
                ElevatedButton(
                  onPressed: _currentStep < 2
                      ? () => setState(() => _currentStep++)
                      : _submitForm,
                  child: Text(_currentStep < 2 ? '下一步' : '提交'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    ///外层包裹一层LayoutBuilder
     return LayoutBuilder(
      builder: (context, constraints) {
      print('Step 1 LayoutBuilder constraints: $constraints');
      return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('步骤1: 个人信息', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              TextField(
                controller: _step1Controller,
                decoration: const InputDecoration(
                  labelText: '姓名',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildStep2() {
    return LayoutBuilder(
      builder: (context, constraints) {
        print('Step 2 LayoutBuilder constraints: $constraints');
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('步骤2: 联系方式', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              TextField(
                controller: _step2Controller,
                decoration: const InputDecoration(
                  labelText: '电话',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildStep3() {
   return LayoutBuilder(
     builder: (context, constraints) {
       // Step 3 LayoutBuilder constraints: BoxConstraints(0.0<=w<=450.0, 0.0<=h<=592.0)
       // 有参与布局计算，但是并不会显示出来
       print('Step 3 LayoutBuilder constraints: $constraints');
       return PaintListener(
          onPaint: () {
            print('Step 3 被绘制了');
          },
         child: Padding(
           padding: const EdgeInsets.all(16),
           child: Column(
             children: [
               const Text('步骤3: 确认信息', style: TextStyle(fontSize: 20)),
               const SizedBox(height: 20),
               Text('姓名: ${_step1Controller.text}'),
               Text('电话: ${_step2Controller.text}'),
             ],
           ),
         ),
       );
     }
   );
  }

  void _submitForm() {
    // 提交表单逻辑
    print('提交表单: ${_step1Controller.text}, ${_step2Controller.text}');
  }

  @override
  void dispose() {
    _step1Controller.dispose();
    _step2Controller.dispose();
    _step3Controller.dispose();
    super.dispose();
  }
}

class PreloadedContentPage extends StatefulWidget {
  const PreloadedContentPage({super.key});

  @override
  State<PreloadedContentPage> createState() => _PreloadedContentPageState();
}

class _PreloadedContentPageState extends State<PreloadedContentPage> {
  bool _showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('预加载内容')),
      body: Stack(
        children: [
          // 主内容
          Center(
            child: ElevatedButton(
              onPressed: () => setState(() => _showDetail = true),
              child: const Text('显示详情'),
            ),
          ),

          // 预加载的复杂详情页面(已构建但隐藏)
          Offstage(
            offstage: !_showDetail,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _showDetail = false),
                    ),
                    title: const Text('详情'),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        print('构建详情项 $index');
                        return ListTile(
                          title: Text('详情项 $index'),
                          subtitle: Text('这是一个预加载的复杂列表 $index'),
                        );
                      },
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
}

class PaintListener extends StatelessWidget {
  final VoidCallback onPaint;
  final Widget child;

  const PaintListener({
    required this.onPaint,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _PaintCallbackPainter(onPaint),
      child: child,
    );
  }
}

class _PaintCallbackPainter extends CustomPainter {
  final VoidCallback onPaint;

  _PaintCallbackPainter(this.onPaint);

  @override
  void paint(Canvas canvas, Size size) {
    // 在绘制阶段触发回调
    onPaint();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}



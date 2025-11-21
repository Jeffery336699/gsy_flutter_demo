import 'dart:io';

import 'package:flutter/material.dart';

/// Slider 使用示例
///
/// 演示内容：
/// 1. 基础 Slider 用法
/// 2. 带标签的 Slider
/// 3. 离散值 Slider（divisions）
/// 4. RangeSlider 双滑块
/// 5. 自定义样式的 Slider
/// 6. 垂直方向的 Slider
class SliderDemoPage extends StatefulWidget {
  const SliderDemoPage({super.key});

  @override
  State<SliderDemoPage> createState() => _SliderDemoPageState();
}

class _SliderDemoPageState extends State<SliderDemoPage> {
  // 基础 Slider 值
  double _basicValue = 50.0;

  // 带标签的 Slider 值
  double _labelValue = 30.0;

  // 离散值 Slider
  double _discreteValue = 5.0;

  // RangeSlider 值
  RangeValues _rangeValues = const RangeValues(20, 80);

  // 自定义样式 Slider
  double _customValue = 60.0;

  // 垂直 Slider
  double _verticalValue = 40.0;

  // 音量控制示例
  double _volume = 50.0;

  // 亮度控制示例
  double _brightness = 75.0;

  @override
  void initState() {
    super.initState();
    // 转储整个 Layer 树
    debugDumpLayerTree();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(platform: TargetPlatform.iOS),
        child: Container(
          alignment: Alignment.topLeft,
          color: Colors.white,
          child: _buildBasicSlider(),
          // appBar: AppBar(
          //   title: const Text('Slider 使用示例'),
          //   backgroundColor: Colors.blue,
          // ),
          // body: ListView(
          //   padding: const EdgeInsets.all(16),
          //   children: [
          //     _buildBasicSlider(),
          //     // const Divider(height: 40),
          //     //
          //     // _buildLabelSlider(),
          //     // const Divider(height: 40),
          //
          //     // _buildDiscreteSlider(),
          //     // const Divider(height: 40),
          //     //
          //     // _buildRangeSlider(),
          //     // const Divider(height: 40),
          //     //
          //     // _buildCustomSlider(),
          //     // const Divider(height: 40),
          //     //
          //     // _buildVolumeControl(),
          //     // const Divider(height: 40),
          //     //
          //     // _buildBrightnessControl(),
          //     // const Divider(height: 40),
          //     //
          //     // _buildVerticalSlider(),
          //     // const SizedBox(height: 20),
          //   ],
          // ),
        ));
  }

  /// 1. 基础 Slider
  Widget _buildBasicSlider() {
    return Material(
      type: MaterialType.canvas,
      child: Slider.adaptive(
        value: _basicValue,
        min: 0,
        max: 100,
        onChanged: (value) {
          setState(() {
            _basicValue = value;
          });
        },
      ),
    );Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Slider.adaptive(
          value: _basicValue,
          min: 0,
          max: 100,
          onChanged: (value) {
            setState(() {
              _basicValue = value;
            });
          },
        ),
      ),
    );
  }

  /// 2. 带标签的 Slider
  Widget _buildLabelSlider() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '2. 带标签的 Slider',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '拖动时显示当前值的标签',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Slider.adaptive(
              value: _labelValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _labelValue.toStringAsFixed(0),
              onChanged: (value) {
                setState(() {
                  _labelValue = value;
                });
              },
            ),
            Text(
              '当前值: ${_labelValue.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3. 离散值 Slider（divisions）
  Widget _buildDiscreteSlider() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3. 离散值 Slider',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用 divisions 属性，滑块只能停在特定位置',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _discreteValue,
              min: 0,
              max: 10,
              divisions: 10,
              label: '★' * _discreteValue.toInt(),
              onChanged: (value) {
                setState(() {
                  _discreteValue = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '评分: ${_discreteValue.toInt()} 星',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '★' * _discreteValue.toInt(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 4. RangeSlider 双滑块
  Widget _buildRangeSlider() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '4. RangeSlider 双滑块',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '选择一个范围，有两个滑块控制起始和结束值',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            RangeSlider(
              values: _rangeValues,
              min: 0,
              max: 100,
              divisions: 100,
              labels: RangeLabels(
                _rangeValues.start.toStringAsFixed(0),
                _rangeValues.end.toStringAsFixed(0),
              ),
              onChanged: (values) {
                setState(() {
                  _rangeValues = values;
                });
              },
            ),
            Text(
              '价格范围: ¥${_rangeValues.start.toStringAsFixed(0)} - ¥${_rangeValues.end.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 5. 自定义样式的 Slider
  Widget _buildCustomSlider() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '5. 自定义样式 Slider',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用 SliderTheme 自定义颜色和样式',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.purple,
                inactiveTrackColor: Colors.purple.withOpacity(0.3),
                thumbColor: Colors.purple,
                overlayColor: Colors.purple.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                trackHeight: 6,
                valueIndicatorColor: Colors.purple,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              child: Slider(
                value: _customValue,
                min: 0,
                max: 100,
                divisions: 20,
                label: '${_customValue.toStringAsFixed(0)}%',
                onChanged: (value) {
                  setState(() {
                    _customValue = value;
                  });
                },
              ),
            ),
            Text(
              '进度: ${_customValue.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 6. 音量控制示例
  Widget _buildVolumeControl() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '6. 实战示例 - 音量控制',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _volume == 0 ? Icons.volume_off : Icons.volume_up,
                  color: Colors.blue,
                  size: 30,
                ),
                Expanded(
                  child: Slider(
                    value: _volume,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: _volume.toStringAsFixed(0),
                    onChanged: (value) {
                      setState(() {
                        _volume = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    '${_volume.toInt()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: _volume / 100,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  /// 7. 亮度控制示例
  Widget _buildBrightnessControl() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '7. 实战示例 - 亮度控制',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_brightness / 100),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.wb_sunny,
                  size: 50,
                  color: Colors.amber.withOpacity(_brightness / 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.brightness_low),
                Expanded(
                  child: Slider(
                    value: _brightness,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '${_brightness.toInt()}%',
                    activeColor: Colors.amber,
                    onChanged: (value) {
                      setState(() {
                        _brightness = value;
                      });
                    },
                  ),
                ),
                const Icon(Icons.brightness_high),
              ],
            ),
            Text(
              '亮度: ${_brightness.toInt()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 8. 垂直方向 Slider
  Widget _buildVerticalSlider() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '8. 垂直方向 Slider',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '使用 RotatedBox 实现垂直滑块',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                            value: _verticalValue,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            label: _verticalValue.toStringAsFixed(0),
                            onChanged: (value) {
                              setState(() {
                                _verticalValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_verticalValue.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // 温度计效果
                  _buildThermometer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 温度计效果
  Widget _buildThermometer() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 30,
                height: 200 * (_verticalValue / 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_verticalValue.toInt()}°C',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


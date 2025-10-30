import 'package:flutter/material.dart';

/// 自定义主题扩展 - 定义应用的自定义颜色
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.cardGradientStart,
    required this.cardGradientEnd,
  });

  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color cardGradientStart;
  final Color cardGradientEnd;

  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? cardGradientStart,
    Color? cardGradientEnd,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      cardGradientStart: cardGradientStart ?? this.cardGradientStart,
      cardGradientEnd: cardGradientEnd ?? this.cardGradientEnd,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardGradientStart: Color.lerp(cardGradientStart, other.cardGradientStart, t)!,
      cardGradientEnd: Color.lerp(cardGradientEnd, other.cardGradientEnd, t)!,
    );
  }

  /// 亮色主题
  static const light = CustomColors(
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
    danger: Color(0xFFF44336),
    info: Color(0xFF2196F3),
    cardGradientStart: Color(0xFFE3F2FD),
    cardGradientEnd: Color(0xFFBBDEFB),
  );

  /// 暗色主题
  static const dark = CustomColors(
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFD54F),
    danger: Color(0xFFEF5350),
    info: Color(0xFF42A5F5),
    cardGradientStart: Color(0xFF1565C0),
    cardGradientEnd: Color(0xFF0D47A1),
  );
}

/// 自定义文字样式扩展
@immutable
class CustomTextStyles extends ThemeExtension<CustomTextStyles> {
  const CustomTextStyles({
    required this.titleLarge,
    required this.titleMedium,
    required this.bodyEmphasis,
    required this.caption,
  });

  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle bodyEmphasis;
  final TextStyle caption;

  @override
  CustomTextStyles copyWith({
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? bodyEmphasis,
    TextStyle? caption,
  }) {
    return CustomTextStyles(
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      bodyEmphasis: bodyEmphasis ?? this.bodyEmphasis,
      caption: caption ?? this.caption,
    );
  }

  @override
  CustomTextStyles lerp(ThemeExtension<CustomTextStyles>? other, double t) {
    if (other is! CustomTextStyles) {
      return this;
    }
    return CustomTextStyles(
      titleLarge: TextStyle.lerp(titleLarge, other.titleLarge, t)!,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t)!,
      bodyEmphasis: TextStyle.lerp(bodyEmphasis, other.bodyEmphasis, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }

  static const light = CustomTextStyles(
    titleLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF212121),
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF424242),
    ),
    bodyEmphasis: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF616161),
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Color(0xFF9E9E9E),
    ),
  );

  static const dark = CustomTextStyles(
    titleLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFFFFFFFF),
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFFEEEEEE),
    ),
    bodyEmphasis: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFFBDBDBD),
    ),
    caption: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Color(0xFF757575),
    ),
  );
}

/// ThemeExtensions 使用技巧演示页面
class ThemeExtensionsDemoPage extends StatefulWidget {
  const ThemeExtensionsDemoPage({super.key});

  @override
  State<ThemeExtensionsDemoPage> createState() => _ThemeExtensionsDemoPageState();
}

class _ThemeExtensionsDemoPageState extends State<ThemeExtensionsDemoPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? _buildDarkTheme() : _buildLightTheme(),
      child: Builder(
        builder: (context) {
          // 获取自定义主题扩展
          final customColors = Theme.of(context).extension<CustomColors>()!;
          final customTextStyles = Theme.of(context).extension<CustomTextStyles>()!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('ThemeExtensions 使用技巧'),
              actions: [
                IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    // 这里触发的是整个页面的主题切换,也就是最外层的 Theme 切换；如果Build改为StableBuilder就会失效
                    setState(() {
                      _isDarkMode = !_isDarkMode;
                    });
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ThemeExtensions 介绍',
                    style: customTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ThemeExtensions 允许我们扩展 ThemeData，添加自定义的主题属性，实现更灵活的主题管理。',
                    style: customTextStyles.bodyEmphasis,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    '1. 自定义颜色扩展',
                    style: customTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildColorCard('Success', customColors.success, Icons.check_circle),
                  const SizedBox(height: 8),
                  _buildColorCard('Warning', customColors.warning, Icons.warning),
                  const SizedBox(height: 8),
                  _buildColorCard('Danger', customColors.danger, Icons.error),
                  const SizedBox(height: 8),
                  _buildColorCard('Info', customColors.info, Icons.info),
                  const SizedBox(height: 24),

                  Text(
                    '2. 渐变色卡片',
                    style: customTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          customColors.cardGradientStart,
                          customColors.cardGradientEnd,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: customColors.cardGradientEnd.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '渐变卡片示例',
                          style: customTextStyles.titleMedium.copyWith(
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '使用自定义主题扩展中的渐变色',
                          style: customTextStyles.bodyEmphasis.copyWith(
                            color: _isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    '3. 自定义文本样式',
                    style: customTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title Large 样式', style: customTextStyles.titleLarge),
                          const SizedBox(height: 8),
                          Text('Title Medium 样式', style: customTextStyles.titleMedium),
                          const SizedBox(height: 8),
                          Text('Body Emphasis 样式', style: customTextStyles.bodyEmphasis),
                          const SizedBox(height: 8),
                          Text('Caption 样式', style: customTextStyles.caption),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    '4. 状态提示按钮',
                    style: customTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusButton(
                          '成功',
                          customColors.success,
                          Icons.check,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusButton(
                          '警告',
                          customColors.warning,
                          Icons.warning_amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusButton(
                          '危险',
                          customColors.danger,
                          Icons.error_outline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusButton(
                          '信息',
                          customColors.info,
                          Icons.info_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    '5. 实际应用场景',
                    style: customTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildScenarioCard(
                    context,
                    '订单成功',
                    '您的订单已成功提交',
                    customColors.success,
                    Icons.shopping_bag,
                  ),
                  const SizedBox(height: 8),
                  _buildScenarioCard(
                    context,
                    '待支付',
                    '请在15分钟内完成支付',
                    customColors.warning,
                    Icons.payment,
                  ),
                  const SizedBox(height: 8),
                  _buildScenarioCard(
                    context,
                    '订单取消',
                    '订单已被取消',
                    customColors.danger,
                    Icons.cancel,
                  ),
                  const SizedBox(height: 8),
                  _buildScenarioCard(
                    context,
                    '物流信息',
                    '您的包裹正在配送中',
                    customColors.info,
                    Icons.local_shipping,
                  ),
                  const SizedBox(height: 24),

                  Card(
                    color: customColors.info.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb, color: customColors.info),
                              const SizedBox(width: 8),
                              Text(
                                '使用技巧',
                                style: customTextStyles.titleMedium.copyWith(
                                  color: customColors.info,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '1. 使用 ThemeExtension 定义自定义主题属性\n'
                            '2. 实现 copyWith 和 lerp 方法支持主题切换动画\n'
                            '3. 通过 Theme.of(context).extension<T>() 获取扩展\n'
                            '4. 为亮色和暗色主题分别定义不同的值\n'
                            '5. 可以定义颜色、文本样式、间距等任意类型',
                            style: customTextStyles.bodyEmphasis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorCard(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  color.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String label, Color color, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('点击了 $label 按钮'),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }

  Widget _buildScenarioCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    IconData icon,
  ) {
    final customTextStyles = Theme.of(context).extension<CustomTextStyles>()!;

    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: customTextStyles.bodyEmphasis.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: customTextStyles.caption,
        ),
        trailing: Icon(Icons.chevron_right, color: color),
        onTap: () {},
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      ///注入了亮色模式下的主题扩展
      extensions: const <ThemeExtension<dynamic>>[
        CustomColors.light,
        CustomTextStyles.light,
      ],
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        CustomColors.dark,
        CustomTextStyles.dark,
      ],
    );
  }
}


import 'package:flutter/material.dart';

/// ButtonStyle 和 MaterialStateProperty 技巧演示页面
class ButtonStyleDemoPage extends StatefulWidget {
  const ButtonStyleDemoPage({super.key});

  @override
  State<ButtonStyleDemoPage> createState() => _ButtonStyleDemoPageState();
}

class _ButtonStyleDemoPageState extends State<ButtonStyleDemoPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ButtonStyle 和 MaterialStateProperty 技巧'),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            // 去掉水波纹效果
            splashFactory: NoSplash.splashFactory,
            // 设置全局前景色
            foregroundColor: MaterialStateProperty.all(Colors.purple.shade300),
            // 设置悬停效果
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.red.withOpacity(0.5);
              }
              return Colors.greenAccent[100];
            }),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.purple;
              }),
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1. 使用 styleFrom 快速配置',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.grey[100],
                ),
                onPressed: () {},
                child: Text("简单按钮"),
              ),
              const SizedBox(height: 24),
              const Text(
                '2. 使用 resolveWith 处理多状态',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.green;
                    }
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue;
                    }
                    return Colors.grey[300];
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.black;
                  }),
                ),
                onPressed: () {}, //禁用通过这里设置null
                child: Text("多状态按钮"),
              ),
              const SizedBox(height: 24),
              const Text(
                '3. 自定义 MaterialStateProperty 类',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: CustomButtonColor(
                    primaryColor: Colors.blue,
                    hoverColor: Colors.blue[700]!,
                    pressedColor: Colors.blue[900]!,
                  ),
                ),
                onPressed: () {},
                child: Text("自定义状态按钮"),
              ),
              const SizedBox(height: 24),
              const Text(
                '4. 全局主题配置示例，在 ThemeData 中配置全局按钮样式',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text("全局主题按钮"),
              ),
              const SizedBox(height: 24),
              const Text(
                '5. 实践：登录按钮，展示加载状态',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              LoginButton(
                isLoading: _isLoading,
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  // 模拟登录过程
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      _isLoading = false;
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButtonColor extends MaterialStateProperty<Color?> {
  final Color primaryColor;
  final Color hoverColor;
  final Color pressedColor;

  CustomButtonColor({
    required this.primaryColor,
    required this.hoverColor,
    required this.pressedColor,
  });

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return primaryColor.withOpacity(0.38);
    }
    if (states.contains(MaterialState.hovered)) {
      return hoverColor;
    }
    if (states.contains(MaterialState.pressed)) {
      return pressedColor;
    }
    return primaryColor;
  }
}

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoginButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        ///内部使用 MaterialStateProperty.resolveWith 来处理不同状态下的样式变化，会覆盖外部的Theme配置
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          // 处理禁用状态
          if (states.contains(MaterialState.disabled) || isLoading) {
            return Colors.grey[400];
          }
          // 处理悬停状态
          if (states.contains(MaterialState.hovered)) {
            return Colors.blue[700];
          }
          // 处理按下状态
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue[900];
          }
          return Colors.blue;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled) || isLoading) {
            return Colors.white70;
          }
          return Colors.white;
        }),
        minimumSize: MaterialStateProperty.all(Size(200, 48)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
      ),
      onPressed: (isLoading || onPressed == null) ? null : onPressed,
      child: isLoading
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ),
          SizedBox(width: 8),
          Text("登录中..."),
        ],
      )
          : Text("登录"),
    );
  }
}


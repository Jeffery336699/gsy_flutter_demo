import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

/// 定义颜色常量，方便后期统一修改主题
class AppColors {
  static const Color primaryBlue = Color(0xFF4C6EF5); // 主色调
  static const Color primaryBlueDark = Color(0xFF3B5BDB); // 深色主色调（用于渐变）
  static const Color backgroundLight = Color(0xFFF5F5F5); // 页面底色
  static const Color textDark = Color(0xFF333333); // 深色文字
  static const Color textGrey = Color(0xFF999999); // 浅色文字/Hint
  static const Color inputFill = Color(0xFFF8F9FA); // 输入框背景色
  static const Color error = Color(0xFFE03131); // 错误红
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  // 状态变量
  String? _userNameError;
  String? _pwdError;
  bool _obscurePassword = true;
  bool _isButtonEnabled = false;

  // 模拟登录逻辑，演示不同状态
  void _handleLogin() {
    setState(() {
      // 重置错误
      _userNameError = null;
      _pwdError = null;

      final user = _userController.text;
      final pwd = _pwdController.text;

      // 场景演示：对应图片中的几种状态
      if (user.isEmpty||pwd.isEmpty) {
        _pwdError = "请输入用户名和密码";
      }else if (user == "123" && pwd == "123") {
        // 场景：异常提示-3 (特定错误文案)
        _pwdError = "用户名和密码错误，请重新输入";
      } else {
        // 登录成功逻辑
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('登录中...')),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // 3. 新增：添加监听器，当输入框内容变化时触发检查
    _userController.addListener(_checkInputValidity);
    _pwdController.addListener(_checkInputValidity);
  }

  @override
  void dispose() {
    // 记得销毁监听器，防止内存泄漏
    _userController.removeListener(_checkInputValidity);
    _pwdController.removeListener(_checkInputValidity);
    _userController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _checkInputValidity() {
    final bool forbidLogin = _userController.text.isEmpty && _pwdController.text.isEmpty;
    // 只有当状态真正改变时才 setState，避免不必要的重绘
    if (forbidLogin == _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = !forbidLogin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕高度，用于计算白色卡片的位置
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        // 使用 SingleChildScrollView 确保键盘弹出时页面可滚动
        child: Stack(
          children: [
            // 1. 顶部蓝色背景区域
            const _LoginHeader(),

            // 2. 底部内容区域
            // 修改为 Stack 布局，通过 margin-top 控制位置，实现重叠且不留白
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 260), // Header高度(300) - 重叠部分(40)
              constraints: BoxConstraints(
                minHeight: size.height - 260,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 用户名输入
                  _LoginInput(
                    label: "用户名",
                    hint: "请输入用户名",
                    icon: Icons.person_outline,
                    controller: _userController,
                    errorText: _userNameError,
                  ),
                  const SizedBox(height: 24),

                  // 密码输入
                  _LoginInput(
                    label: "密码",
                    hint: "请输入密码",
                    icon: Icons.lock_outline,
                    controller: _pwdController,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    errorText: _pwdError,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 40),

                  // 登录按钮
                  _LoginButton(onTap: _handleLogin, isEnabled: _isButtonEnabled),

                  const SizedBox(height: 75),

                  // 底部 Footer
                  const _FooterDivider(),
                  const SizedBox(height: 20), // 底部安全距离
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 顶部蓝色背景组件
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // 背景高度
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, top: 80, right: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5C7CF7),
            AppColors.primaryBlue,
            Color(0xFF3B5BDB)
          ],
        ),
        // 如果有背景波浪图，可以在这里使用 image: DecorationImage(...)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "你好!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Text(
            "欢迎登陆中再生出库系统",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "PDA手持终端",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// 核心封装：通用输入框组件
/// 负责处理圆角、背景、图标、错误状态红框显示
class _LoginInput extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final String? errorText;

  const _LoginInput({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textGrey),
            filled: true,
            fillColor: AppColors.inputFill,
            prefixIcon: Icon(icon, color: AppColors.textGrey),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textGrey,
              ),
              onPressed: onToggleVisibility,
            )
                : null,
            // 错误文本显示在输入框下方
            errorText: errorText,
            errorStyle: const TextStyle(color: AppColors.error),
            errorMaxLines: 2,

            // 默认边框（无边框或极细边框）
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            // 聚焦时边框
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
            // 错误时边框（红色）
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

/// 登录按钮组件
class _LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;
  const _LoginButton({required this.onTap,this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isEnabled
            ? const LinearGradient(colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],)
            : LinearGradient(
                colors: [AppColors.primaryBlue.withOpacity(0.5), AppColors.primaryBlueDark.withOpacity(0.5)],
              ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: const Center(
            child: Text(
              "登录",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 底部文字分割线
class _FooterDivider extends StatelessWidget {
  const _FooterDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: Color(0xFFEEEEEE))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "中再生出库系统",
            style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: Color(0xFFEEEEEE))),
      ],
    );
  }
}

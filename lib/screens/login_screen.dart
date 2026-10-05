import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const green = Color(0xFF0B9B67);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    final compactLayout = screenHeight < 760;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F7),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: compactLayout ? 18 : 28,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (compactLayout ? 36 : 56),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(compactLayout),

                        SizedBox(height: compactLayout ? 28 : 40),

                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'Sign in to continue managing your finances.',
                          style: TextStyle(color: Color(0xFF718078)),
                        ),

                        SizedBox(height: compactLayout ? 20 : 28),

                        const Text(
                          'Email Address',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            hint: 'Enter your email',
                            icon: Icons.email_outlined,
                          ),
                        ),

                        SizedBox(height: compactLayout ? 15 : 20),

                        const Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: passwordController,
                          obscureText: hidePassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => signIn(),
                          decoration: _inputDecoration(
                            hint: 'Enter your password',
                            icon: Icons.lock_outline_rounded,

                            // Correct password visibility button.
                            suffix: IconButton(
                              tooltip: hidePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: compactLayout ? 2 : 8),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: signIn,
                            style: FilledButton.styleFrom(
                              backgroundColor: green,
                              padding: EdgeInsets.symmetric(
                                vertical: compactLayout ? 15 : 17,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: compactLayout ? 18 : 24),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withValues(alpha: 0.25),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Color(0xFF8A948F),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withValues(alpha: 0.25),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: compactLayout ? 15 : 20),

                        Row(
                          children: [
                            Expanded(
                              child: _socialButton(
                                Icons.g_mobiledata_rounded,
                                'Google',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _socialButton(Icons.apple, 'Apple'),
                            ),
                          ],
                        ),

                        SizedBox(height: compactLayout ? 20 : 28),

                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Color(0xFF718078)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Create new account',
                                  style: TextStyle(
                                    color: green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool compactLayout) {
    return Center(
      child: Column(
        children: [
          Container(
            width: compactLayout ? 64 : 76,
            height: compactLayout ? 64 : 76,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(compactLayout ? 19 : 22),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: green,
              size: compactLayout ? 34 : 40,
            ),
          ),

          SizedBox(height: compactLayout ? 12 : 16),

          const Text(
            'Expense Manager',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          const Text(
            'Track • Save • Grow',
            style: TextStyle(color: Color(0xFF718078), fontSize: 13),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: green, width: 1.5),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Color(0xFFE0E8E4)),
    );
  }

  Widget _socialButton(IconData icon, String title) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: const Color(0xFF29332F)),
      label: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF29332F),
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Color(0xFFE0E8E4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../utils/theme_provider.dart';

class RegisterScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const RegisterScreen({Key? key, required this.themeProvider})
    : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isRegistering = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isRegistering = true;
      });

      final userController = Provider.of<UserController>(
        context,
        listen: false,
      );
      final success = await userController.addUser(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isRegistering = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Color.fromARGB(255, 243, 109, 201),
          ),
        );
        Navigator.pushReplacementNamed(context, '/users');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userController.errorMessage ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (!_agreeToTerms && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Conditions'),
          backgroundColor: Color.fromARGB(255, 243, 109, 201),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeProvider.isDarkMode;
    final textColor =
        isDark ? Colors.white : const Color.fromARGB(255, 37, 38, 66);
    final subtitleColor =
        isDark
            ? Colors.white.withOpacity(0.7)
            : const Color.fromARGB(255, 100, 100, 120);
    final inputBgColor =
        isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.7);
    final borderColor =
        isDark
            ? Colors.white.withOpacity(0.3)
            : const Color.fromARGB(255, 200, 200, 220);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: widget.themeProvider.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Bar with Back Button and Theme Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: textColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              widget.themeProvider.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              color: textColor,
                            ),
                            onPressed: () {
                              widget.themeProvider.toggleTheme();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Logo and App Name
                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isDark
                                      ? Colors.black.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.7),
                              border: Border.all(
                                color: const Color.fromARGB(
                                  255,
                                  243,
                                  109,
                                  201,
                                ).withOpacity(0.5),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(
                                    255,
                                    243,
                                    109,
                                    201,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.music_note,
                              color: Color.fromARGB(255, 243, 109, 201),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Create Account",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              shadows: [
                                Shadow(
                                  color: const Color.fromARGB(
                                    255,
                                    243,
                                    109,
                                    201,
                                  ).withAlpha(178),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Join JukeVibe and start your musical journey",
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Registration Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Username Field
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(color: subtitleColor),
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: subtitleColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 243, 109, 201),
                                  ),
                                ),
                                filled: true,
                                fillColor: inputBgColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (value.length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: subtitleColor),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: subtitleColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 243, 109, 201),
                                  ),
                                ),
                                filled: true,
                                fillColor: inputBgColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: subtitleColor),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: subtitleColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: subtitleColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 243, 109, 201),
                                  ),
                                ),
                                filled: true,
                                fillColor: inputBgColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password Field
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: TextStyle(color: textColor),
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(color: subtitleColor),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: subtitleColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: subtitleColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: borderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 243, 109, 201),
                                  ),
                                ),
                                filled: true,
                                fillColor: inputBgColor,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            // Terms and Conditions Checkbox
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: _agreeToTerms,
                                      onChanged: (value) {
                                        setState(() {
                                          _agreeToTerms = value ?? false;
                                        });
                                      },
                                      fillColor:
                                          MaterialStateProperty.resolveWith<
                                            Color
                                          >((Set<MaterialState> states) {
                                            if (states.contains(
                                              MaterialState.selected,
                                            )) {
                                              return const Color.fromARGB(
                                                255,
                                                243,
                                                109,
                                                201,
                                              );
                                            }
                                            return isDark
                                                ? Colors.white.withOpacity(0.3)
                                                : Colors.grey.withOpacity(0.3);
                                          }),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'I agree to the ',
                                        style: TextStyle(
                                          color: subtitleColor,
                                          fontSize: 14,
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Terms of Service',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                243,
                                                109,
                                                201,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                243,
                                                109,
                                                201,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isRegistering ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    243,
                                    109,
                                    201,
                                  ),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 5,
                                  shadowColor: const Color.fromARGB(
                                    255,
                                    243,
                                    109,
                                    201,
                                  ).withOpacity(0.5),
                                ),
                                child:
                                    _isRegistering
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          'SIGN UP',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Login Link
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 243, 109, 201),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

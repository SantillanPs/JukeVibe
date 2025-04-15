import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../utils/theme_provider.dart';

class UserEditScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final String userId;

  const UserEditScreen({
    Key? key,
    required this.themeProvider,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userController = Provider.of<UserController>(context, listen: false);
    final user = userController.getUserById(widget.userId);
    if (user != null) {
      _user = user;
      _usernameController.text = user.username;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final updatedUser = _user.copyWith(
        username: _usernameController.text,
        email: _emailController.text,
      );

      final userController = Provider.of<UserController>(
        context,
        listen: false,
      );
      final success = await userController.updateUser(updatedUser);

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User updated successfully'),
            backgroundColor: Color.fromARGB(255, 243, 109, 201),
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userController.errorMessage ?? 'Failed to update user',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      appBar: AppBar(
        title: Text('Edit User', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: widget.themeProvider.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit User Information',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

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
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
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
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'SAVE CHANGES',
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
          ),
        ),
      ),
    );
  }
}

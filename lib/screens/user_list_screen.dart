import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../utils/theme_provider.dart';
import 'user_edit_screen.dart';

class UserListScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const UserListScreen({Key? key, required this.themeProvider})
    : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Load users when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserController>(context, listen: false).loadUsers();
    });
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
    final cardBgColor =
        isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.7);
    final borderColor =
        isDark
            ? const Color.fromARGB(255, 243, 109, 201).withOpacity(0.2)
            : const Color.fromARGB(255, 243, 109, 201).withOpacity(0.3);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Management', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            color: textColor,
            onPressed: () {
              Navigator.pushNamed(context, '/data-export');
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: widget.themeProvider.backgroundGradient,
          ),
        ),
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            if (userController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 243, 109, 201),
                ),
              );
            }

            if (userController.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off, size: 80, color: subtitleColor),
                    const SizedBox(height: 16),
                    Text(
                      'No users found',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Register a new user to get started',
                      style: TextStyle(color: subtitleColor, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add User'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          243,
                          109,
                          201,
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userController.users.length,
              itemBuilder: (context, index) {
                final user = userController.users[index];
                return _buildUserCard(
                  user,
                  userController,
                  textColor,
                  subtitleColor,
                  cardBgColor,
                  borderColor,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        backgroundColor: const Color.fromARGB(255, 243, 109, 201),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserCard(
    User user,
    UserController userController,
    Color textColor,
    Color subtitleColor,
    Color cardBgColor,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 243, 109, 201).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(color: subtitleColor, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Created: ${_formatDate(user.createdAt)}',
                        style: TextStyle(color: subtitleColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 243, 109, 201),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => UserEditScreen(
                                  themeProvider: widget.themeProvider,
                                  userId: user.id,
                                ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmation(context, user, userController);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    User user,
    UserController userController,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete User'),
            content: Text('Are you sure you want to delete ${user.username}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await userController.deleteUser(user.id);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User deleted successfully'),
                        backgroundColor: Color.fromARGB(255, 243, 109, 201),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

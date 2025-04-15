import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class UserController extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Uuid _uuid = const Uuid();

  // Getters
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize controller and load data
  Future<void> init() async {
    await loadUsers();
  }

  // Load users from JSON file
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final file = await _getFile();
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        if (jsonString.isNotEmpty) {
          final jsonData = json.decode(jsonString);
          _users =
              (jsonData as List).map((item) => User.fromJson(item)).toList();
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load users: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save users to JSON file
  Future<void> saveUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final file = await _getFile();
      final jsonData = _users.map((user) => user.toJson()).toList();
      await file.writeAsString(json.encode(jsonData));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save users: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new user
  Future<bool> addUser(String username, String email, String password) async {
    try {
      final newUser = User(
        id: _uuid.v4(),
        username: username,
        email: email,
        password: password,
      );

      _users.add(newUser);
      await saveUsers();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add user: $e';
      notifyListeners();
      return false;
    }
  }

  // Update an existing user
  Future<bool> updateUser(User updatedUser) async {
    try {
      final index = _users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        _users[index] = updatedUser;
        await saveUsers();
        return true;
      }
      _errorMessage = 'User not found';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update user: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete a user
  Future<bool> deleteUser(String id) async {
    try {
      _users.removeWhere((user) => user.id == id);
      await saveUsers();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete user: $e';
      notifyListeners();
      return false;
    }
  }

  // Get user by ID
  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get file reference
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }
}

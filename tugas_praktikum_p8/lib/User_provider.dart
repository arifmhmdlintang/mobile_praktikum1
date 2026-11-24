import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const String _usernameKey = 'username';
  String _username = '';

  String get username => _username;

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString(_usernameKey) ?? '';
    notifyListeners();
  }

  Future<void> saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, name);
    _username = name;
    notifyListeners();
  }
}

import 'package:admin_dating/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutNotifier extends StateNotifier<void> {
  LogoutNotifier() : super(null);

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    print("Before logout: ${prefs.getKeys()}");
    await prefs.clear();
    print("After logout: ${prefs.getKeys()}");
    
    // Use root navigator to clear stack from the very top
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }
}

final logoutProvider = StateNotifierProvider<LogoutNotifier, void>(
  (ref) => LogoutNotifier(),
);
import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http_parser/http_parser.dart';

class LoginNotifier extends StateNotifier<UserModel> {
  final Ref ref;
  LoginNotifier(this.ref) : super(UserModel.initial());

  Future<bool> tryAutoLogin() async {
  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('userData')) {
    print('No user data found.');
    return false;
  }

  try {
    final extractedData = json.decode(prefs.getString('userData')!);
    final loginModel = UserModel.fromJson(extractedData);

    if (loginModel.data == null || loginModel.data![0].accessToken== null || loginModel.data![0].user == null) {
      print('Invalid user data structure.');
      return false;
    }

    // Update your provider state here (if applicable)
    state = loginModel;

    print('Auto-login successful. User ID: ${loginModel.data![0].user!.id}');
    return true;
  } catch (e, stackTrace) {
    print('Error during auto-login: $e');
    print(stackTrace);
    return false;
  }
}

Future<UserModel> login({
  required String email,
  required String password,
}) async {
  const String apiUrl = Dgapi.login;
  final prefs = await SharedPreferences.getInstance();
   print ("api function email:$email, password:$password" );

  try {

    print("this inside try block for login api func");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    final decoded = json.decode(response.body);
     
    if (response.statusCode == 200 || response.statusCode == 201) {

  
      final loginModel = UserModel.fromJson(decoded);
     
      await prefs.setString('userData', json.encode(loginModel.toJson()));
      state = loginModel;

      return loginModel;
    } else {
      return UserModel(
        success: false,
        messages: [decoded['message'] ?? 'Login failed.'],
      );
    }
  } catch (e) {
    return UserModel(success: false, messages: ["Server error occurred."]);
  }
}


}

final loginProvider = StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  return LoginNotifier(ref);
});

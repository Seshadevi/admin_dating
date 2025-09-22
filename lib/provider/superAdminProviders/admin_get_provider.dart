import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/dating_colors.dart';
import '../../models/superAdminModels/admin_get_model.dart';
import '../loader.dart';

class AdminGetsProvider extends StateNotifier<List<Admin>> {
  final Ref ref;
  AdminGetsProvider(this.ref) : super([]);

  // Helper to get bearer token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      return userData['accessToken'] ??
          (userData['data'] != null && (userData['data'] as List).isNotEmpty
              ? userData['data'][0]['access_token']
              : null);
    }
    return null;
  }

  // Fetch admins
  Future<void> getAdmins() async {
    try {
      final token = await _getToken();
      final uri = Uri.parse('http://97.74.93.26:6100/admin/page-access');

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        // Adjust based on your backend response structure
        final adminsData = AdminGetModel.fromJson(res);
        state = adminsData.data;
      } else {
        print("Failed to fetch admins: ${response.body}");
      }
    } catch (e) {
      print("Exception while fetching admins: $e");
    }
  }

  // Create admin with multipart
  Future<bool> createAdmin({
    required File image,
    required String username,
    required String email,
    required String password,
    required String roleId,
    Set<int>? pageIds,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;
      final token = await _getToken();
      final uri = Uri.parse('http://97.74.93.26:6100/superAdmin/createAdmin');

      final request = http.MultipartRequest('POST', uri);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add fields
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['roleId'] = roleId;
      if (pageIds != null && pageIds.isNotEmpty) {
        request.fields['pagesIds'] = pageIds.join(',');
      }

      // Attach image
      if (image.path.isNotEmpty) {
        final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
        request.files.add(await http.MultipartFile.fromPath(
          'profilePic',
          image.path,
          contentType: MediaType.parse(mimeType),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Create response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getAdmins();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error creating admin: $e");
      return false;
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  // Update admin with multipart
  Future<bool> updateAdmin({
    required int id,
    File? image,
    required String username,
    required String email,
    required String password,
    required String roleId,
    Set<int>? pageIds,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;
      final token = await _getToken();
      final uri = Uri.parse("http://97.74.93.26:6100/superAdmin/updateAdmin/$id");

      final request = http.MultipartRequest('PUT', uri);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add fields
      request.fields['username'] = username;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['roleId'] = roleId;
      if (pageIds != null && pageIds.isNotEmpty) {
        request.fields['pagesIds'] = pageIds.join(',');
      }

      // Attach new image if provided
      if (image != null && image.path.isNotEmpty) {
        final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
        request.files.add(await http.MultipartFile.fromPath(
          'profilePic',
          image.path,
          contentType: MediaType.parse(mimeType),
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Update response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getAdmins();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error updating admin: $e");
      return false;
    } finally {
      ref.read(loadingProvider.notifier).state = false;
    }
  }

  // Delete admin
  Future<void> deleteAdmin(int id, {BuildContext? context}) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse("http://97.74.93.26:6100/superAdmin/deleteAdmin/$id");
      final response = await http.delete(uri, headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        await getAdmins();
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Admin deleted successfully"),
              backgroundColor: DatingColors.darkGreen,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to delete admin: ${response.body}"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print("Exception deleting admin: $e");
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// Provider registration
final adminGetsProvider = StateNotifierProvider<AdminGetsProvider, List<Admin>>(
      (ref) => AdminGetsProvider(ref),
);

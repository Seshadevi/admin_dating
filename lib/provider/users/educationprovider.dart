import 'dart:convert';
import 'package:admin_dating/models/users/educationmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EducationProvider extends StateNotifier<Educationmodel> {
  final Ref ref;
  EducationProvider(this.ref) : super(Educationmodel.initial());

  Future<void> geteducation() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    try {
      loadingState.state = true;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken; // ✅ Update token for next use
            req.headers['Authorization'] = 'Bearer $newAccessToken';

            print("New Token: $newAccessToken");
          }
        },
      );

      print('get education');

      final response = await client.get(
        Uri.parse(Dgapi.educationGet),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseBody = response.body;
      print('Get education Status Code: ${response.statusCode}');
      print('Get education Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Educationmodel.fromJson(res);
          state = usersData;
          print('get education successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing education");
        }
      } else {
        print("Error fetching education${response.body}");
        throw Exception("Error fetching education: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch education: $e");
    } finally {
      loadingState.state = false;
    }
  }

  Future<bool> addEducation(
      {required String institution, required int? gradYear}) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        print("User token is missing.");
        return false;
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        print("User token is invalid.");
        return false;
      }

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken ?? '');
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      final apiUrl = Uri.parse(Dgapi.eudctionAdd);
      final response = await client.post(
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'institution': institution,
          'gradYear': gradYear,
        }),
      );

      print("Education API Status: ${response.statusCode}");
      print("Education API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Education added successfully!");
        geteducation();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        print("Error adding education: $errorMessage");
        return false;
      }
    } catch (e) {
      print("Exception during education add: $e");
      return false;
    } finally {
      loadingState.state = false;
    }
  }

  Future<void> updateSelectededucation(
      int educationId, String? institute, String? year) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    print('data education $educationId,$institute,$year');

    try {
      loadingState.state = true;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }
       final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken ?? '');
            token = newAccessToken;
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      // You'll need to add this API endpoint to your Dgapi class
      final apiUrl = Uri.parse("${Dgapi.educationUpdate}/$educationId");
 // Add this to your API constants
      final request = await client.put(
        // or patch, depending on your API
        apiUrl,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'institution': institute,
          'gradYear': year,
        }),
      );

      print('Update selected education Status Code: ${request.statusCode}');
      print('Update selected education Response Body: ${request.body}');

      if (request.statusCode == 200 || request.statusCode == 201) {
        print("Selected education updated successfully!");
        // Optionally refresh the work list to get updated data
        await geteducation();
      } else {
        final errorBody =
            request.body.isNotEmpty ? jsonDecode(request.body) : {};
        final errorMessage =
            errorBody['message'] ?? 'Failed to update selected education.';
        throw Exception("Error updating selected education: $errorMessage");
      }
    } catch (e) {
      print("Failed to update selected education: $e");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  // Future<int> deleteeducation(int? educationId) async {
  //   final loadingState = ref.read(loadingProvider.notifier);
  //   loadingState.state = true;
  //   final prefs = await SharedPreferences.getInstance();

  //   try {
  //     final String deleteUrl = "${Dgapi.educationdelete}/$educationId";
  //     // loadingState.state = true;

  //     String? userDataString = prefs.getString('userData');
  //     if (userDataString == null || userDataString.isEmpty) {
  //       throw Exception("User token is missing. Please log in again.");
  //     }

  //     final Map<String, dynamic> userData = jsonDecode(userDataString);

  //     String? token = userData['accessToken'] ??
  //         (userData['data'] != null &&
  //                 (userData['data'] as List).isNotEmpty &&
  //                 userData['data'][0]['access_token'] != null
  //             ? userData['data'][0]['access_token']
  //             : null);

  //     if (token == null || token.isEmpty) {
  //       throw Exception("User token is invalid. Please log in again.");
  //     }

  //      final client = RetryClient(
  //       http.Client(),
  //       retries: 3,
  //       when: (response) =>
  //           response.statusCode == 401 || response.statusCode == 400,
  //       onRetry: (req, res, retryCount) async {
  //         if (retryCount == 0 &&
  //             (res?.statusCode == 401 || res?.statusCode == 400)) {
  //           print("Token expired, refreshing...");
  //           String? newAccessToken =
  //               await ref.read(loginProvider.notifier).restoreAccessToken();

  //           await prefs.setString('accessToken', newAccessToken ?? '');
  //           token = newAccessToken;
  //           req.headers['Authorization'] = 'Bearer $newAccessToken';
  //         }
  //       },
  //     );


  //     final response = await client.delete(
  //       Uri.parse(deleteUrl),
  //       headers: {
  //         'Accept': 'application/json',
  //       },
  //     );

  //     print("🗑️ Delete response: ${response.body}");

  //     if (response.statusCode == 200 || response.statusCode == 204) {
  //       print("✅ Deleted successfully");
  //       await geteducation();
  //       return response.statusCode;
  //     } else {
  //       throw Exception("Delete failed: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❗ Delete error: $e");
  //     throw Exception("Delete error: $e");
  //   } finally {
  //     loadingState.state = false;
  //   }
  // }
}

final educationProvider =
    StateNotifierProvider<EducationProvider, Educationmodel>((ref) {
  return EducationProvider(ref);
});

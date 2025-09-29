import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/models/signupprocessmodels/modeModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ModeNotifier extends StateNotifier<ModeModel> {
  final Ref ref;
  ModeNotifier(this.ref) : super(ModeModel.initial());
  
  Future<void> getModes() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get modes');

      final response = await http.get(
        Uri.parse(Dgapi.modes));
      final responseBody = response.body;
      print('Get modes Status Code: ${response.statusCode}');
      print('Get modes Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = ModeModel.fromJson(res);
          state = usersData;
          print("modes fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing modes.");
        }
      } else {
        print("Error fetching modes: ${response.body}");
        throw Exception("Error fetching modes: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch modes: $e");
    }
  }
  Future<bool> addMode({required String modes}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;

    final apiUrl = Uri.parse(Dgapi.modeAdd);
    final request = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
       
      },
      body: jsonEncode({
        'valuesss':modes,
      }),
    );

    print('Add Status Code: ${request.statusCode}');
    print('Add Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("modes added successfully!");
      await getModes(); // Refresh after add
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding modes: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add modes: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}
Future<int> updatemode(int? modeId, String? modeName) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    loadingState.state = true;

    try {
      final userId = state.data?[0].id;
      if (userId == null) throw Exception("User ID is missing");

     final String apiUrl = "${Dgapi.modeupdate}/$modeId";


      // Headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Request body (adjust key names to match your backend)
      final body = jsonEncode({
        // "user_id": userId,
        "value": modeName, // List of IDs
      });

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      print("📨 Response Status: ${response.statusCode}");
      print("📨 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        await getModes();

        // ✅ OPTIONAL: Only if API returns updated user object
        if (responseData is Map && responseData.containsKey("user")) {
          try {
            final updatedUser = UserModel.fromJson(responseData["user"]);
            await prefs.setString('userData', jsonEncode(updatedUser.toJson()));
            // state = state.copyWith(user: updatedUser); // Update Riverpod state if needed
          } catch (e) {
            print("⚠️ Failed to parse updated user: $e");
          }
        }

        return response.statusCode;
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw Exception("Update failed: $errorMessage");
      }
    } catch (e) {
      print("❗ Exception during update: $e");
      throw Exception("Update failed: $e");
    } finally {
      loadingState.state = false;
    }
  }

Future<int> deleteMode(int? modeId) async {
  final loadingState = ref.read(loadingProvider.notifier);
  loadingState.state = true;

  try {
    final String deleteUrl = "${Dgapi.modedelete}/$modeId";

    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        'Accept': 'application/json',
      },
    );

    print("🗑️ Delete response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Deleted successfully");
      await getModes();
      return response.statusCode;
    } else {
      throw Exception("Delete failed: ${response.statusCode}");
    }
  } catch (e) {
    print("❗ Delete error: $e");
    throw Exception("Delete error: $e");
  } finally {
    loadingState.state = false;
  }
}





}

final modesProvider = StateNotifierProvider<ModeNotifier, ModeModel>((ref) {
  return ModeNotifier(ref);
});

import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/models/signupprocessmodels/defaultMessagesModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DefaultNotifier extends StateNotifier<DefaultModel> {
  final Ref ref;
  DefaultNotifier(this.ref) : super(DefaultModel.initial());
  
  Future<void> getdefaultmessages() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
   
      print('get default messages');

    
      final response = await http.get(
        Uri.parse(Dgapi.defaultMessages)       
      );
      final responseBody = response.body;
      print('Get default Status Code: ${response.statusCode}');
      print('Get default Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = DefaultModel.fromJson(res);
          state = usersData;
          print("default fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing default.");
        }
      } else {
        print("Error fetching defaultmessages: ${response.body}");
        throw Exception("Error fetching defaultmessages: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch defaultmessages: $e");
    }
  }
  Future<bool> adddefaultMessages({required String defaultMessages}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;

    final apiUrl = Uri.parse(Dgapi.defaultMessagesAdd);
    final request = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
       
      },
      body: jsonEncode({
        'message':defaultMessages,
      }),
    );

    print('Add Status Code: ${request.statusCode}');
    print('Add Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("defaultMessages added successfully!");
      await getdefaultmessages(); // Refresh after add
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding defaultMessages: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add defaultMessages: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}
 Future<int> updatemessages(int? messagesId, String? messagesName) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    loadingState.state = true;

    try {
      final userId = state.data?[0].id;
      if (userId == null) throw Exception("User ID is missing");

     final String apiUrl = "${Dgapi.updatedmessages}/$messagesId";


      // Headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Request body (adjust key names to match your backend)
      final body = jsonEncode({
        // "user_id": userId,
        "message": messagesName, // List of IDs
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
        await getdefaultmessages();

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

Future<int> deletemessages(int? messageIdId) async {
  final loadingState = ref.read(loadingProvider.notifier);
  loadingState.state = true;

  try {
    final String deleteUrl = "${Dgapi.deletemessages}/$messageIdId";

    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        'Accept': 'application/json',
      },
    );

    print("🗑️ Delete response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Deleted successfully");
      await getdefaultmessages();
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

final defaultmessagesProvider = StateNotifierProvider<DefaultNotifier, DefaultModel>((ref) {
  return DefaultNotifier(ref);
});
import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/models/more%20section/experiencemodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class experienceProvider extends StateNotifier<ExperienceModel> {
  final Ref ref;
  experienceProvider(this.ref) : super(ExperienceModel.initial());
  
  Future<void> getExperience() async {
    
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get experience');

      final response = await http.get(
        Uri.parse(Dgapi.experienceget));
      final responseBody = response.body;
      print('Get experience Status Code: ${response.statusCode}');
      print('Get experience Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = ExperienceModel.fromJson(res);
          state = usersData;
          print("experience fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing experience.");
        }
      } else {
        print("Error fetching experience: ${response.body}");
        throw Exception("Error fetching experience: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch experience $e");
    }
  }
  Future<bool> addExperience({required String experience}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;
    

    final apiUrl = Uri.parse(Dgapi.experiencepost);
    final request = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
       
      },
      body: jsonEncode({
        'experience':experience,
      }),
    );

    print('Add Status Code: ${request.statusCode}');
    print('Add Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("experience added successfully!");
      await getExperience(); // Refresh after add
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding experience: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add experience: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}
Future<int> updateexperience(int? experienceId,String? experienceName) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    loadingState.state = true;

    try {
      final userId = state.data?[0].id;
      if (userId == null) throw Exception("User ID is missing");

     final String apiUrl = "${Dgapi.experienceupdate}/$experienceId";


      // Headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Request body (adjust key names to match your backend)
      final body = jsonEncode({
        
        "experience": experienceName, // List of IDs
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
        await getExperience();

        // ✅ OPTIONAL: Only if API returns updated user object
        if (responseData is Map && responseData.containsKey("user")) {
          try {
            final updatedUser = UserModel.fromJson(responseData["user"]);
            await prefs.setString('userData', jsonEncode(updatedUser.toJson()));
            
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

Future<int> deleteexperience(int? experienceId) async {
  final loadingState = ref.read(loadingProvider.notifier);
  loadingState.state = true;

  try {
    final String deleteUrl = "${Dgapi.experiencedelete}/$experienceId";

    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        'Accept': 'application/json',
      },
    );

    print("🗑️ Delete response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Deleted successfully");
      await getExperience();
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

final experiencProvider = StateNotifierProvider<experienceProvider, ExperienceModel>((ref) {
  return experienceProvider(ref);
});
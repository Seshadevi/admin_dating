

import 'package:admin_dating/models/loginmodel.dart';

import 'package:admin_dating/models/more%20section/starsign.dart';
import 'package:admin_dating/models/signupprocessmodels/sportsmodel.dart';

import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Sportsprovider extends StateNotifier<Sportsmodel> {
  final Ref ref;
  Sportsprovider(this.ref) : super(Sportsmodel.initial());
  
  Future<void> getSports() async {
    
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get sports called');

      final response = await http.get(
        Uri.parse(Dgapi.sportsGet));
      final responseBody = response.body;
      print('Get sports Status Code: ${response.statusCode}');
      print('Get sports Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = Sportsmodel.fromJson(res);
          state = usersData;
          print("sports fetched successfully: ${state.data?.length} items");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing sports.");
        }
      } else {
        print("Error fetching sports: ${response.body}");
        throw Exception("Error fetching sports: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch sports $e");
    }
  }
  Future<bool> addsports({required String sports}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;
    

    final apiUrl = Uri.parse(Dgapi.sportPost);
    final request = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
       
      },
      body: jsonEncode({
        'sports_title':sports,
      }),
    );

    print('Add Status Code: ${request.statusCode}');
    print('Add Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("sports added successfully!");
      await getSports(); // Refresh after add
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding sports: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add sports: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}
Future<int> updatesports(int? sportsId,String? sportsName) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    loadingState.state = true;

    try {
      final userId = state.data?[0].id;
      if (userId == null) throw Exception("User ID is missing");

     final String apiUrl = "${Dgapi.sportsUpdate}/$sportsId";


      // Headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Request body (adjust key names to match your backend)
      final body = jsonEncode({
        
        "sports_title": sportsName, // List of IDs
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
        await getSports();

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

Future<int> deletesports(int? sportsId) async {
  final loadingState = ref.read(loadingProvider.notifier);
  loadingState.state = true;

  try {
    final String deleteUrl = "${Dgapi.sportsDelete}/$sportsId";

    final response = await http.delete(
      Uri.parse(deleteUrl),
      headers: {
        'Accept': 'application/json',
      },
    );

    print("🗑️ Delete response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Deleted successfully");
      await getSports();
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

final sportsprovider = StateNotifierProvider<Sportsprovider, Sportsmodel>((ref) {
  return Sportsprovider(ref);
});
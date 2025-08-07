

import 'package:admin_dating/models/signupprocessmodels/religionModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReligionNotifier extends StateNotifier<ReligionModel> {
  final Ref ref;
  ReligionNotifier(this.ref) : super(ReligionModel.initial());
  
  Future<void> getReligions() async {
    
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get religions');

      final response = await http.get(
        Uri.parse(Dgapi.religion));
      final responseBody = response.body;
      print('Get religions Status Code: ${response.statusCode}');
      print('Get religions Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = ReligionModel.fromJson(res);
          state = usersData;
          print("religions fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing religions.");
        }
      } else {
        print("Error fetching religions: ${response.body}");
        throw Exception("Error fetching religions: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch religions $e");
    }
  }
  Future<bool> addreligion({required String religions}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;

    final apiUrl = Uri.parse(Dgapi.religionAdd);
    final request = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
       
      },
      body: jsonEncode({
        'religion':religions,
      }),
    );

    print('Add Status Code: ${request.statusCode}');
    print('Add Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("Religions added successfully!");
      await getReligions(); // Refresh after add
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding Religions: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add Religions: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}
// Future<int> updateProfile() async {
//   final loadingState = ref.read(loadingProvider.notifier);
//   final prefs = await SharedPreferences.getInstance();

//   loadingState.state = true;

//   try {
//     final userId = state.data?[0].id;
//     if (userId == null) throw Exception("User ID is missing");

//     final String apiUrl = Dgapi.;

//     // Prepare headers
//     final headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };

//     // Request body (change keys/values as per your API)
//     final body = jsonEncode({
      
//     });

//     // Send PUT request
//     final response = await http.put(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: body,
//     );

//     print("📨 Response Status: ${response.statusCode}");
//     print("📨 Response Body: ${response.body}");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final responseData = jsonDecode(response.body);

//       try {
//         final user = UserModel.fromJson(responseData);
//         // Save or update state
//         await prefs.setString('userData', jsonEncode(user.toJson()));
//         // state = yourState.copyWith(user: user); // if applicable
//       } catch (e) {
//         print("⚠️ Error parsing user: $e");
//         throw Exception("Failed to parse updated Lookingfor");
//       }

//       return response.statusCode;
//     } else {
//       final errorMessage = jsonDecode(response.body)['message'] ?? 'Unknown error';
//       throw Exception("Update failed: $errorMessage");
//     }
//   } catch (e) {
//     print("❗ Exception during update: $e");
//     throw Exception("Update failed: $e");
//   } finally {
//     loadingState.state = false;
//   }
// }
// Future<int> deleteLookingFor(int lookingId) async {
//   final loadingState = ref.read(loadingProvider.notifier);
//   loadingState.state = true;

//   try {
//     final String deleteUrl = "${Dgapi.}/$lookingId";

//     final response = await http.delete(
//       Uri.parse(deleteUrl),
//       headers: {
//         'Accept': 'application/json',
//       },
//     );

//     print("🗑️ Delete response: ${response.body}");

//     if (response.statusCode == 200 || response.statusCode == 204) {
//       print("✅ Deleted successfully");
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

final religionProvider = StateNotifierProvider<ReligionNotifier, ReligionModel>((ref) {
  return ReligionNotifier(ref);
});
// import 'package:admin_dating/models/loginmodel.dart';
// import 'package:admin_dating/models/signupprocessmodels/Interests.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/utils/dgapi.dart';

// import 'package:http/http.dart' as http;
// import 'package:http/retry.dart';
// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class INterstsNotifier extends StateNotifier<Interests> {
//   final Ref ref;
//   INterstsNotifier(this.ref) : super(Interests.initial());

//   Future<void> getintersts() async {
//     final loadingState = ref.read(loadingProvider.notifier);
//     try {
//       loadingState.state = true;

//       print('get intersts');

//       final response = await http.get(Uri.parse(Dgapi.interests));
//       final responseBody = response.body;
//       print('Get intersts Status Code: ${response.statusCode}');
//       print('Get intersts Response Body: $responseBody');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           final res = jsonDecode(responseBody);
//           final usersData = Interests.fromJson(res);
//           state = usersData;
//           print("intersts fetched successfully: ${usersData.message}");
//         } catch (e) {
//           print("Invalid response format: $e");
//           throw Exception("Error parsing intersts.");
//         }
//       } else {
//         print("Error fetching intersts: ${response.body}");
//         throw Exception("Error fetching intersts: ${response.body}");
//       }
//     } catch (e) {
//       print("Failed to fetch intersts: $e");
//     } finally {
//       loadingState.state = false;
//     }
//   }

// //   Future<bool> addcausesAndCommunities(
// //       {required String causesAndCommunities}) async {
// //     final loadingState = ref.read(loadingProvider.notifier);
// //     final prefs = await SharedPreferences.getInstance();

// //     try {
// //       loadingState.state = true;

// //       final apiUrl = Uri.parse(Dgapi.causesAdd);
// //       final request = await http.post(
// //         apiUrl,
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //         body: jsonEncode({
// //           'causesAndCommunities': causesAndCommunities,
// //         }),
// //       );

// //       print('Add Status Code: ${request.statusCode}');
// //       print('Add Response Body: ${request.body}');

// //       if (request.statusCode == 201 || request.statusCode == 200) {
// //         print("Causes added successfully!");
// //         await getCauses(); // Refresh after add
// //         return true;
// //       } else {
// //         final errorBody = jsonDecode(request.body);
// //         final errorMessage =
// //             errorBody['message'] ?? 'Unexpected error occurred.';
// //         print("Error adding Causes: $errorMessage");
// //         return false;
// //       }
// //     } catch (e) {
// //       print("Failed to add Causes: $e");
// //       return false;
// //     } finally {
// //       loadingState.state = false;
// //     }
// //   }

// //   Future<int> updateCauses(int? causeId, String? causesName) async {
// //     final loadingState = ref.read(loadingProvider.notifier);
// //     final prefs = await SharedPreferences.getInstance();

// //     loadingState.state = true;

// //     try {
// //       final userId = state.data?[0].id;
// //       if (userId == null) throw Exception("User ID is missing");

// //      final String apiUrl = "${Dgapi.updatecauses}/$causeId";


// //       // Headers
// //       final headers = {
// //         'Content-Type': 'application/json',
// //         'Accept': 'application/json',
// //       };

// //       // Request body (adjust key names to match your backend)
// //       final body = jsonEncode({
// //         // "user_id": userId,
// //         "causesAndCommunities": causesName, // List of IDs
// //       });

// //       final response = await http.put(
// //         Uri.parse(apiUrl),
// //         headers: headers,
// //         body: body,
// //       );

// //       print("📨 Response Status: ${response.statusCode}");
// //       print("📨 Response Body: ${response.body}");

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final responseData = jsonDecode(response.body);
// //         await getCauses();

// //         // ✅ OPTIONAL: Only if API returns updated user object
// //         if (responseData is Map && responseData.containsKey("user")) {
// //           try {
// //             final updatedUser = UserModel.fromJson(responseData["user"]);
// //             await prefs.setString('userData', jsonEncode(updatedUser.toJson()));
// //             // state = state.copyWith(user: updatedUser); // Update Riverpod state if needed
// //           } catch (e) {
// //             print("⚠️ Failed to parse updated user: $e");
// //           }
// //         }

// //         return response.statusCode;
// //       } else {
// //         final errorMessage =
// //             jsonDecode(response.body)['message'] ?? 'Unknown error';
// //         throw Exception("Update failed: $errorMessage");
// //       }
// //     } catch (e) {
// //       print("❗ Exception during update: $e");
// //       throw Exception("Update failed: $e");
// //     } finally {
// //       loadingState.state = false;
// //     }
// //   }

// // Future<int> deleteCauses(int? causesId) async {
// //   final loadingState = ref.read(loadingProvider.notifier);
// //   loadingState.state = true;

// //   try {
// //     final String deleteUrl = "${Dgapi.deletecause}/$causesId";

// //     final response = await http.delete(
// //       Uri.parse(deleteUrl),
// //       headers: {
// //         'Accept': 'application/json',
// //       },
// //     );

// //     print("🗑️ Delete response: ${response.body}");

// //     if (response.statusCode == 200 || response.statusCode == 204) {
// //       print("✅ Deleted successfully");
// //       await getCauses();
// //       return response.statusCode;
// //     } else {
// //       throw Exception("Delete failed: ${response.statusCode}");
// //     }
// //   } catch (e) {
// //     print("❗ Delete error: $e");
// //     throw Exception("Delete error: $e");
// //   } finally {
// //     loadingState.state = false;
// //   }
// // }
// }

// final causesProvider =
//     StateNotifierProvider<INterstsNotifier, Interests>((ref) {
//   return INterstsNotifier(ref);
// });

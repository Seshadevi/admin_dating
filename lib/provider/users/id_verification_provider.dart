// import 'dart:convert';
// import 'package:admin_dating/models/users/id_verification_model.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:admin_dating/utils/dgapi.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/retry.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Verificationprovider extends StateNotifier<List<VerificationId>> {
//   final Ref ref;
//   Verificationprovider(this.ref) : super(const []);

//   /// Fetch verification users list (kept your naming pattern)
//   Future<void> verificationid() async {
//     final loadingState = ref.read(loadingProvider.notifier);
//     final prefs = await SharedPreferences.getInstance();

//     try {
//       loadingState.state = true;

//       String? token;

//       String? userDataString = prefs.getString('userData');
//       if (userDataString == null || userDataString.isEmpty) {
//         throw Exception("User token is missing. Please log in again.");
//       }
//       final Map<String, dynamic> userData = jsonDecode(userDataString);

//       token = userData['accessToken'] ??
//           (userData['data'] != null &&
//                   (userData['data'] as List).isNotEmpty &&
//                   userData['data'][0]['access_token'] != null
//               ? userData['data'][0]['access_token']
//               : null);

//       if (token == null || token.isEmpty) {
//         throw Exception("User token is invalid. Please log in again.");
//       }

//       print('Retrieved Token from SharedPreferences: $token');

//       final client = RetryClient(
//         http.Client(),
//         retries: 3,
//         when: (response) =>
//             response.statusCode == 401 || response.statusCode == 400,
//         onRetry: (req, res, retryCount) async {
//           if (retryCount == 0 &&
//               (res?.statusCode == 401 || res?.statusCode == 400)) {
//             print("Token expired, refreshing...");
//             String? newAccessToken =
//                 await ref.read(loginProvider.notifier).restoreAccessToken();

//             if (newAccessToken != null && newAccessToken.isNotEmpty) {
//               await prefs.setString('accessToken', newAccessToken);
//               req.headers['Authorization'] = 'Bearer $newAccessToken';
//               print("New Token: $newAccessToken");
//             }
//           }
//         },
//       );

//       print('Fetching verification ids');

//       final response = await client.get(
//         Uri.parse(Dgapi.getverification),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       final responseBody = response.body;
//       print('Get verification Status Code: ${response.statusCode}');
//       print('Get verification Response Body: $responseBody');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           final decoded = jsonDecode(responseBody);

//           // Support: [ ... ], { data: [ ... ] }, or a single object
//           final List<dynamic> rawList;
//           if (decoded is List) {
//             rawList = decoded;
//           } else if (decoded is Map && decoded['data'] is List) {
//             rawList = decoded['data'] as List;
//           } else if (decoded is Map) {
//             rawList = [decoded];
//           } else {
//             throw Exception("Unexpected response format");
//           }

//           final items = rawList
//               .map((e) => VerificationId.fromJson(e as Map<String, dynamic>))
//               .toList();

//           state = items;
//           print('Successfully fetched verification list (${items.length})');
//         } catch (e) {
//           print("Invalid response format: $e");
//           throw Exception("Error parsing verification list");
//         }
//       } else {
//         print("Error fetching verification ids: ${response.body}");
//         throw Exception("Error fetching verification ids: ${response.body}");
//       }
//     } catch (e) {
//       print("Failed to fetch verification ids: $e");
//     } finally {
//       loadingState.state = false;
//     }
//   }

//   /// Approve/Reject user’s verification (verified: true/false)
//   Future<bool> updateVerification({
//     required int userId,
//     required bool verified,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();

//     try {
//       // Get token (same way as above)
//       String? token;
//       final userDataString = prefs.getString('userData');
//       if (userDataString != null && userDataString.isNotEmpty) {
//         final Map<String, dynamic> userData = jsonDecode(userDataString);
//         token = userData['accessToken'] ??
//             (userData['data'] != null &&
//                     (userData['data'] as List).isNotEmpty &&
//                     userData['data'][0]['access_token'] != null
//                 ? userData['data'][0]['access_token']
//                 : null);
//       }
//       token ??= prefs.getString('accessToken');
//       if (token == null || token.isEmpty) {
//         // try refresh once
//         token = await ref.read(loginProvider.notifier).restoreAccessToken();
//         if (token == null || token.isEmpty) {
//           throw Exception("Missing token. Please log in again.");
//         }
//         await prefs.setString('accessToken', token);
//       }

//       final client = RetryClient(
//         http.Client(),
//         retries: 3,
//         when: (response) =>
//             response.statusCode == 401 || response.statusCode == 400,
//         onRetry: (req, res, retryCount) async {
//           if (retryCount == 0 &&
//               (res?.statusCode == 401 || res?.statusCode == 400)) {
//             print("Token expired during update, refreshing...");
//             String? newAccessToken =
//                 await ref.read(loginProvider.notifier).restoreAccessToken();
//             if (newAccessToken != null && newAccessToken.isNotEmpty) {
//               await prefs.setString('accessToken', newAccessToken);
//               req.headers['Authorization'] = 'Bearer $newAccessToken';
//               print("New Token: $newAccessToken");
//             }
//           }
//         },
//       );

//       // "$baseUrl/admin/users/userId/verification" -> replace userId
//       final url = Dgapi.updateverification.replaceFirst('userId', '$userId');
//       print('Updating verification for userId=$userId -> $verified, URL=$url');

//       final res = await client.patch(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'verified': verified}),
//       );

//       print('Update Status Code: ${res.statusCode}');
//       print('Update Response Body: ${res.body}');

//       if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
//         // Optimistically update local state
//         state = state
//             .map((u) =>
//                 (u.userId == userId) ? u.copyWith(verified: verified) : u)
//             .toList();
//         return true;
//       } else {
//         throw Exception('Update failed: ${res.statusCode} ${res.body}');
//       }
//     } catch (e) {
//       print('Failed to update verification: $e');
//       return false;
//     }
//   }
// }

// final verificationIdProvider =
//     StateNotifierProvider<Verificationprovider, List<VerificationId>>((ref) {
//   return Verificationprovider(ref);
// });


// lib/provider/users/id_verification_provider.dart
// import 'dart:convert';
// import 'package:admin_dating/models/users/id_verification_model.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:admin_dating/utils/dgapi.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/retry.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Verificationprovider extends StateNotifier<List<Verifications>> {
//   final Ref ref;
//   Verificationprovider(this.ref) : super(const []);

//   /// Fetch verification users list -> flattens to List<Verifications>
//   Future<void> verificationid() async {
//     final loadingState = ref.read(loadingProvider.notifier);
//     final prefs = await SharedPreferences.getInstance();

//     try {
//       loadingState.state = true;

//       // --- token retrieval (robust) ---
//       String? token;
//       final userDataString = prefs.getString('userData');
//       if (userDataString == null || userDataString.isEmpty) {
//         throw Exception("User token is missing. Please log in again.");
//       }
//       final Map<String, dynamic> userData = jsonDecode(userDataString);
//       token = userData['accessToken'] ??
//           (userData['data'] is List &&
//                   (userData['data'] as List).isNotEmpty &&
//                   (userData['data'][0]['access_token'] is String)
//               ? userData['data'][0]['access_token'] as String
//               : null);

//       if (token == null || token.isEmpty) {
//         throw Exception("User token is invalid. Please log in again.");
//       }

//       final client = RetryClient(
//         http.Client(),
//         retries: 3,
//         when: (res) => res.statusCode == 401 || res.statusCode == 400,
//         onRetry: (req, res, retryCount) async {
//           if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
//             final newAccessToken =
//                 await ref.read(loginProvider.notifier).restoreAccessToken();
//             if (newAccessToken != null && newAccessToken.isNotEmpty) {
//               await prefs.setString('accessToken', newAccessToken);
//               req.headers['Authorization'] = 'Bearer $newAccessToken';
//             }
//           }
//         },
//       );

//       final response = await client.get(
//         Uri.parse(Dgapi.getverification),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final body = response.body;
//         final decoded = jsonDecode(body);

//         // Accepts: { data: [{ verifications: [...] }, ...], ... }
//         // or { verifications: [...] }
//         // or [ { verifications: [...] }, ... ]
//         // or raw list of verification objects [...]
//         final List<Verifications> flat = [];

//         void addFrom(dynamic verifList) {
//           if (verifList is List) {
//             for (final v in verifList) {
//               if (v is Map<String, dynamic>) {
//                 flat.add(Verifications.fromJson(v));
//               }
//             }
//           }
//         }

//         if (decoded is Map<String, dynamic>) {
//           if (decoded['verifications'] is List) {
//             addFrom(decoded['verifications']);
//           } else if (decoded['data'] is List) {
//             for (final d in (decoded['data'] as List)) {
//               if (d is Map<String, dynamic> && d['verifications'] is List) {
//                 addFrom(d['verifications']);
//               }
//             }
//           } else if (decoded['data'] is Map &&
//               (decoded['data'] as Map)['verifications'] is List) {
//             addFrom((decoded['data'] as Map)['verifications']);
//           } else if (decoded['data'] is List) {
//             // some APIs send direct verifications array as data
//             addFrom(decoded['data']);
//           }
//         } else if (decoded is List) {
//           // assume list of verification objects OR list of {verifications: [...]}
//           for (final e in decoded) {
//             if (e is Map<String, dynamic> && e['verifications'] is List) {
//               addFrom(e['verifications']);
//             } else if (e is Map<String, dynamic>) {
//               flat.add(Verifications.fromJson(e));
//             }
//           }
//         }

//         state = flat;
//       } else {
//         throw Exception("Error fetching verification ids: ${response.body}");
//       }
//     } catch (e) {
//       // You may want to surface this to the UI with another provider
//       // or return a Result type. For now we just log and keep last state.
//       // print('Failed to fetch: $e');
//     } finally {
//       loadingState.state = false;
//     }
//   }

//   /// Approve/Reject user’s verification (verified: true/false)
//   Future<bool> updateVerification({
//     required int userId,
//     required bool verified,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();

//     try {
//       // Token again
//       String? token;
//       final userDataString = prefs.getString('userData');
//       if (userDataString?.isNotEmpty == true) {
//         final Map<String, dynamic> userData = jsonDecode(userDataString!);
//         token = userData['accessToken'] ??
//             (userData['data'] is List &&
//                     (userData['data'] as List).isNotEmpty &&
//                     (userData['data'][0]['access_token'] is String)
//                 ? userData['data'][0]['access_token'] as String
//                 : null);
//       }
//       token ??= prefs.getString('accessToken');
//       token ??= await ref.read(loginProvider.notifier).restoreAccessToken();
//       if (token == null || token.isEmpty) {
//         throw Exception("Missing token. Please log in again.");
//       }
//       await prefs.setString('accessToken', token);

//       final client = RetryClient(
//         http.Client(),
//         retries: 3,
//         when: (res) => res.statusCode == 401 || res.statusCode == 400,
//         onRetry: (req, res, retryCount) async {
//           if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
//             final newAccessToken =
//                 await ref.read(loginProvider.notifier).restoreAccessToken();
//             if (newAccessToken != null && newAccessToken.isNotEmpty) {
//               await prefs.setString('accessToken', newAccessToken);
//               req.headers['Authorization'] = 'Bearer $newAccessToken';
//             }
//           }
//         },
//       );

//       final url = Dgapi.updateverification.replaceFirst('userId', '$userId');

//       final res = await client.patch(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({'verified': verified}),
//       );

//       if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
//         // Optimistically update: if your backend returns a textual `status`,
//         // consider mapping verified->'verified'/'rejected'.
//         state = [
//           for (final v in state)
//             if (v.userId == userId)
//               v.copyWith(
//                 verified: verified,
//                 status: verified ? 'verified' : 'rejected',
//               )
//             else
//               v
//         ];
//         return true;
//       } else {
//         throw Exception('Update failed: ${res.statusCode} ${res.body}');
//       }
//     } catch (_) {
//       return false;
//     }
//   }
// }

// final verificationIdProvider =
//     StateNotifierProvider<Verificationprovider, List<Verifications>>(
//   (ref) => Verificationprovider(ref),
// );
















import 'dart:convert';
import 'package:admin_dating/models/users/id_verification_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Verificationprovider extends StateNotifier<List<VerificationId>> {
  final Ref ref;
  Verificationprovider(this.ref) : super(const []);

  /// Fetch verification users list
  Future<void> verificationid() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();

    try {
      loadingState.state = true;

      String? token = await _getAuthToken(prefs);
      if (token == null) {
        throw Exception("User token is missing. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) => response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken = await ref.read(loginProvider.notifier).restoreAccessToken();

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await prefs.setString('accessToken', newAccessToken);
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );

      print('Fetching verification ids from: ${Dgapi.getverification}');

      final response = await client.get(
        Uri.parse(Dgapi.getverification),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decoded = jsonDecode(response.body);
          
          // Handle different response formats
          List<VerificationId> verificationList = [];
          
          if (decoded is List) {
            // Direct array of verification objects
            verificationList = decoded
                .map((item) => VerificationId.fromJson(item as Map<String, dynamic>))
                .toList();
          } else if (decoded is Map) {
            if (decoded['data'] is List) {
              // Response with data wrapper
              verificationList = (decoded['data'] as List)
                  .map((item) => VerificationId.fromJson(item as Map<String, dynamic>))
                  .toList();
            } else {
              // Single object response
              verificationList = [VerificationId.fromJson(Map<String, dynamic>.from(decoded as Map))];

            }
          }

          state = verificationList;
          print('Successfully loaded ${verificationList.length} verification records');
          
          // Debug: Print structure
          for (var i = 0; i < verificationList.length && i < 2; i++) {
            final item = verificationList[i];
            print('Item $i: ${item.data?.length ?? 0} data entries');
            if (item.data?.isNotEmpty ?? false) {
              final firstData = item.data!.first;
              print('  First data has ${firstData.verifications?.length ?? 0} verifications');
            }
          }
          
        } catch (parseError) {
          print("JSON parsing error: $parseError");
          print("Response body: ${response.body}");
          throw Exception("Failed to parse verification data: $parseError");
        }
      } else {
        final errorMessage = "HTTP ${response.statusCode}: ${response.body}";
        print("API Error: $errorMessage");
        throw Exception("Failed to fetch verifications: $errorMessage");
      }
    } catch (e) {
      print("Verification fetch error: $e");
      // Don't clear state on error, keep previous data
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  /// Update verification status (approve/reject)
  Future<bool> updateVerification({
    required int userId,
    required bool verified,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      String? token = await _getAuthToken(prefs);
      if (token == null) {
        token = await ref.read(loginProvider.notifier).restoreAccessToken();
        if (token == null || token.isEmpty) {
          throw Exception("Authentication required. Please log in again.");
        }
        await prefs.setString('accessToken', token);
      }

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) => response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired during update, refreshing...");
            String? newAccessToken = await ref.read(loginProvider.notifier).restoreAccessToken();
            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await prefs.setString('accessToken', newAccessToken);
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("Updated token for retry");
            }
          }
        },
      );

      // Replace userId placeholder in URL
      final url = Dgapi.updateverification.replaceFirst('userId', '$userId');
      print('Updating verification: userId=$userId, verified=$verified');
      print('Request URL: $url');

      final requestBody = jsonEncode({
        'verified': verified,
        'status': verified ? 'verified' : 'rejected', // Include status for better API compatibility
      });

      final response = await client.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print('Update Response - Status: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Update local state optimistically
        _updateLocalVerificationState(userId, verified);
        return true;
      } else {
        final errorMsg = 'Update failed: ${response.statusCode} - ${response.body}';
        print(errorMsg);
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('Verification update error: $e');
      return false;
    }
  }

  /// Helper method to get authentication token
  Future<String?> _getAuthToken(SharedPreferences prefs) async {
    try {
      // Try to get from userData first
      final userDataString = prefs.getString('userData');
      if (userDataString != null && userDataString.isNotEmpty) {
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        
        // Check multiple possible token locations
        String? token = userData['accessToken'] as String?;
        token ??= userData['access_token'] as String?;
        
        if (userData['data'] is List && (userData['data'] as List).isNotEmpty) {
          final firstData = (userData['data'] as List)[0] as Map<String, dynamic>;
          token ??= firstData['access_token'] as String?;
          token ??= firstData['accessToken'] as String?;
        }
        
        if (token != null && token.isNotEmpty) {
          return token;
        }
      }
      
      // Fallback to direct accessToken storage
      return prefs.getString('accessToken');
    } catch (e) {
      print('Token extraction error: $e');
      return prefs.getString('accessToken');
    }
  }

  /// Update local state after successful API call
  void _updateLocalVerificationState(int userId, bool verified) {
    state = state.map((verificationId) {
      if (verificationId.data != null) {
        final updatedData = verificationId.data!.map((data) {
          if (data.verifications != null) {
            final updatedVerifications = data.verifications!.map((verification) {
              if (verification.userId == userId) {
                return verification.copyWith(
                  verified: verified,
                  status: verified ? 'verified' : 'rejected',
                );
              }
              return verification;
            }).toList();
            return data.copyWith(verifications: updatedVerifications);
          }
          return data;
        }).toList();
        return verificationId.copyWith(data: updatedData);
      }
      return verificationId;
    }).toList();
  }

  /// Refresh verification list
  Future<void> refresh() async {
    await verificationid();
  }

  /// Clear all verification data
  void clear() {
    state = [];
  }

  /// Get verification by user ID
  Verifications? getVerificationByUserId(int userId) {
    for (final verificationId in state) {
      if (verificationId.data != null) {
        for (final data in verificationId.data!) {
          if (data.verifications != null) {
            for (final verification in data.verifications!) {
              if (verification.userId == userId) {
                return verification;
              }
            }
          }
        }
      }
    }
    return null;
  }
}

final verificationIdProvider = StateNotifierProvider<Verificationprovider, List<VerificationId>>((ref) {
  return Verificationprovider(ref);
});
// import 'dart:convert';

// import 'package:admin_dating/models/users/Realusersmodel.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/provider/loginprovider.dart';
// import 'package:admin_dating/utils/dgapi.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/retry.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Realusersprovider extends StateNotifier<Realusersmodel> {
//   final Ref ref;
//   Realusersprovider(this.ref) : super(Realusersmodel.initial());

//   // Modified method to accept optional token parameter
//   Future<void> getRealusers({String? specificToken,int?modeId}) async {
//     final loadingState = ref.read(loadingProvider.notifier);
//     final prefs = await SharedPreferences.getInstance();
//     print('acces token............$specificToken.');
    
//     try {
//       loadingState.state = true;
      
//       String? token;

//       // If a specific token is provided, use it directly
//       if (specificToken != null && specificToken.isNotEmpty) {
//         token = specificToken;
//         print('Using provided token: $token');
//       } else {
//         // Fallback to the original logic
//         String? userDataString = prefs.getString('userData');
//         if (userDataString == null || userDataString.isEmpty) {
//           throw Exception("User token is missing. Please log in again.");
//         }

//         final Map<String, dynamic> userData = jsonDecode(userDataString);

//         token = userData['accessToken'] ??
//             (userData['data'] != null &&
//                     (userData['data'] as List).isNotEmpty &&
//                     userData['data'][0]['access_token'] != null
//                 ? userData['data'][0]['access_token']
//                 : null);

//         if (token == null || token.isEmpty) {
//           throw Exception("User token is invalid. Please log in again.");
//         }

//         print('Retrieved Token from SharedPreferences: $token');
//       }

//       final client = RetryClient(
//         http.Client(),
//         retries: 3,
//         when: (response) =>
//             response.statusCode == 401 || response.statusCode == 400,
//         onRetry: (req, res, retryCount) async {
//           if (retryCount == 0 &&
//               (res?.statusCode == 401 || res?.statusCode == 400)) {
//             print("Token expired, refreshing...");
            
//             // Only try to refresh if we're not using a specific token
//             if (specificToken == null) {
//               String? newAccessToken =
//                   await ref.read(loginProvider.notifier).restoreAccessToken();
              
//               await prefs.setString('accessToken', newAccessToken);
//               token = newAccessToken;
//               req.headers['Authorization'] = 'Bearer $newAccessToken';
              
//               print("New Token: $newAccessToken");
//             } else {
//               print("Cannot refresh specific token, using original");
//               req.headers['Authorization'] = 'Bearer $specificToken';
//             }
//           }
//         },
//       );

//       print('Fetching Realusers...');

//       final response = await http.get(
//         Uri.parse(Dgapi.realUsers),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
      
//       final responseBody = response.body;
//       print('Get Realusers Status Code: ${response.statusCode}');
//       print('Get Realusers Response Body: $responseBody');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           final res = jsonDecode(responseBody);
//           final usersData = Realusersmodel.fromJson(res);
//           state = usersData;
//           print('Successfully fetched Realusers data');
//         } catch (e) {
//           print("Invalid response format: $e");
//           throw Exception("Error parsing Realusers data");
//         }
//       } else {
//         print("Error fetching Realusers: ${response.body}");
//         throw Exception("Error fetching Realusers: ${response.body}");
//       }
//     } catch (e) {
//       print("Failed to fetch Realusers: $e");
//       // Set error state or handle error appropriately
//       state = state.copyWith(
//         success: false,
//         // message: e.toString(),
//       );
//     } finally {
//       loadingState.state = false;
//     }
//   }
// }

// final realusersprovider =
//     StateNotifierProvider<Realusersprovider, Realusersmodel>((ref) {
//   return Realusersprovider(ref);
// });
import 'dart:convert';

import 'package:admin_dating/models/users/Realusersmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Realusersprovider extends StateNotifier<Realusersmodel> {
  final Ref ref;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _currentToken;
  int? _currentModeId;

  Realusersprovider(this.ref) : super(Realusersmodel.initial());

  // Modified method to support pagination and mode filtering
  Future<void> getRealusers({
    String? specificToken,
    int? modeId,
    int page = 1,
    bool loadMore = false,
  }) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    print('access token............$specificToken.');
    
    if (!loadMore && !_isLoadingMore) {
      loadingState.state = true;
      _currentPage = 1;
      _hasMore = true;
    }

    if (loadMore && (_isLoadingMore || !_hasMore)) return;

    if (loadMore) {
      _isLoadingMore = true;
      _currentPage++;
    }

    try {
      String? token;
      _currentToken = specificToken;
      _currentModeId = modeId ;

      // If a specific token is provided, use it directly
      if (specificToken != null && specificToken.isNotEmpty) {
        token = specificToken;
        print('Using provided token: $token');
      } else {
        // Fallback to the original logic
        String? userDataString = prefs.getString('userData');
        if (userDataString == null || userDataString.isEmpty) {
          throw Exception("User token is missing. Please log in again.");
        }

        final Map<String, dynamic> userData = jsonDecode(userDataString);

        token = userData['accessToken'] ??
            (userData['data'] != null &&
                    (userData['data'] as List).isNotEmpty &&
                    userData['data'][0]['access_token'] != null
                ? userData['data'][0]['access_token']
                : null);

        if (token == null || token.isEmpty) {
          throw Exception("User token is invalid. Please log in again.");
        }

        print('Retrieved Token from SharedPreferences: $token');
      }

      // Build URL with pagination and mode filter
      String url = '${Dgapi.realUsers}?page=${loadMore ? _currentPage : page}&limit=10';
      if (modeId != null && modeId!=null) {
        url += '&modeId=$modeId';
      }

      print('Fetching users from: $url');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            
            // Only try to refresh if we're not using a specific token
            if (specificToken == null) {
              String? newAccessToken =
                  await ref.read(loginProvider.notifier).restoreAccessToken();
              
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken;
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              
              print("New Token: $newAccessToken");
            } else {
              print("Cannot refresh specific token, using original");
              req.headers['Authorization'] = 'Bearer $specificToken';
            }
          }
        },
      );

      print('Fetching Realusers...');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      final responseBody = response.body;
      print('Get Realusers Status Code: ${response.statusCode}');
      print('Get Realusers Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final newUsersData = Realusersmodel.fromJson(res);

          if (loadMore && state.data != null) {
            // Append new data to existing data
            final existingData = List<Data>.from(state.data!);
            existingData.addAll(newUsersData.data ?? []);
            
            state = state.copyWith(
              data: existingData,
              pagination: newUsersData.pagination,
            );
          } else {
            // Replace with new data
            state = newUsersData;
            _currentPage = newUsersData.pagination?.page ?? 1;
          }

          // Check if there are more pages
          final currentPage = state.pagination?.page ?? 1;
          final totalPages = state.pagination?.totalPages ?? 1;
          _hasMore = currentPage < totalPages;

          print('Successfully fetched users. Page: $currentPage/$totalPages');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Realusers data");
        }
      } else {
        print("Error fetching Realusers: ${response.body}");
        throw Exception("Error fetching Realusers: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Realusers: $e");
      // Set error state or handle error appropriately
      state = state.copyWith(
        success: false,
        // message: e.toString(),
      );
    } finally {
      // client.close();
      if (!loadMore) loadingState.state = false;
      if (loadMore) _isLoadingMore = false;
    }
  }

  // Load more users
  Future<void> loadMoreUsers() async {
    await getRealusers(
      specificToken: _currentToken,
      modeId: _currentModeId,
      loadMore: true,
    );
  }

  // Refresh users
  Future<void> refreshUsers() async {
    _currentPage = 1;
    _hasMore = true;
    await getRealusers(
      specificToken: _currentToken,
      modeId: _currentModeId,
      page: 1,
    );
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}

final realusersprovider =
    StateNotifierProvider<Realusersprovider, Realusersmodel>((ref) {
  return Realusersprovider(ref);
});

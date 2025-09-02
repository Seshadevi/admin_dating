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
  
  // Add this to accumulate data across multiple page calls
  List<Data> _accumulatedData = [];
  bool _isAccumulating = false;

  Realusersprovider(this.ref) : super(Realusersmodel.initial());

  // NEW METHOD: Start accumulating data mode (for client-side filtering)
  void startAccumulating() {
    _isAccumulating = true;
    _accumulatedData.clear();
    print("Started accumulating mode for client-side filtering");
  }

  // NEW METHOD: Stop accumulating and return to normal mode
  void stopAccumulating() {
    _isAccumulating = false;
    print("Stopped accumulating mode. Total accumulated: ${_accumulatedData.length}");
  }

  // NEW METHOD: Get accumulated data
  List<Data> getAccumulatedData() {
    return List.from(_accumulatedData);
  }

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
    print('Accumulating mode: $_isAccumulating, Page: $page');
    
    if (!loadMore && !_isLoadingMore && !_isAccumulating) {
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
      _currentModeId = modeId;

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
      String url = '${Dgapi.realUsers}?page=${loadMore ? _currentPage : page}';
      if (modeId != null) {
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

          if (_isAccumulating) {
            // ACCUMULATING MODE: Add to accumulated data, keep state as latest page
            if (newUsersData.data != null) {
              _accumulatedData.addAll(newUsersData.data!);
              print("Accumulated page $page: ${newUsersData.data!.length} users. Total accumulated: ${_accumulatedData.length}");
            }
            
            // Update state with current page info but don't replace data
            state = newUsersData;
            
          } else if (loadMore && state.data != null) {
            // NORMAL LOAD MORE: Append new data to existing data
            final existingData = List<Data>.from(state.data!);
            existingData.addAll(newUsersData.data ?? []);
            
            state = state.copyWith(
              data: existingData,
              pagination: newUsersData.pagination,
            );
          } else {
            // NORMAL SINGLE PAGE: Replace with new data
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
      state = state.copyWith(
        success: false,
      );
    } finally {
      if (!loadMore && !_isAccumulating) loadingState.state = false;
      if (loadMore) _isLoadingMore = false;
    }
  }

  // Load specific page (for pagination)
  Future<void> loadPage(int page) async {
    final loadingState = ref.read(loadingProvider.notifier);
    loadingState.state = true;
    
    _currentPage = page;
    
    await getRealusers(
      specificToken: _currentToken,
      modeId: _currentModeId,
      page: page,
      loadMore: false,
    );
  }

  // Load more users (for infinite scroll)
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

  // Get current page number
  int get currentPage => _currentPage;
  
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  bool get isAccumulating => _isAccumulating;
}

final realusersprovider =
    StateNotifierProvider<Realusersprovider, Realusersmodel>((ref) {
  return Realusersprovider(ref);
});
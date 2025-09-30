

import 'dart:convert';

import 'package:admin_dating/models/users/get_reports_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetReportsProviders extends StateNotifier<GetReportModel> {
  final Ref ref;
  GetReportsProviders(this.ref) : super(GetReportModel.initial());

  Future<void> getereports() async {
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

      print('get reports');

      final response = await client.get(
        Uri.parse(Dgapi.getreports),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseBody = response.body;
      print('Get reports Status Code: ${response.statusCode}');
      print('Get reports Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = GetReportModel.fromJson(res);
          state = usersData;
          print('get reports successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing reports");
        }
      } else {
        print("Error fetching reports${response.body}");
        throw Exception("Error fetching reports: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch reports: $e");
    } finally {
      loadingState.state = false;
    }
  }
}

final getReportsProviders = StateNotifierProvider<GetReportsProviders, GetReportModel>((ref){
      return GetReportsProviders(ref);
});
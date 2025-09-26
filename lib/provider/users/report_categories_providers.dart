import 'dart:convert';
import 'package:admin_dating/models/users/report_categories_model.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportCategoriesProviders extends StateNotifier<ReportCategoriesModel> {
  final Ref ref;
  ReportCategoriesProviders(this.ref) : super(ReportCategoriesModel.initial());

  /// 🔹 Get Features with token + refresh
  Future<void> getReportCategries({
    int page = 1, 
    bool append = false
    }
  ) async {
    final prefs = await SharedPreferences.getInstance();
    //final accesstoken = ref.read(loginProvider).data![0].accessToken;
    
    try {
       String? token = await _getToken(prefs);

      final client = _retryClient(prefs, token);

      final response = await client.get(
        Uri.parse("${Dgapi.getreportcategories}?page=$page"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('Get ReportCategries Status Code: ${response.statusCode}');
      print('Get ReportCategries Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
         final newModel = ReportCategoriesModel.fromJson(res);

      if (append && state.data != null) {
        // ✅ Append data (do not replace)
        state = state.copyWith(
          data: [...state.data!, ...?newModel.data],
          pagination: newModel.pagination,
          success: true,
        );
        } else {
        // ✅ First page (replace state)
        state = newModel.copyWith(success: true);
      }
        print('✅ ReportCategries fetched successfully');
      } else {
        throw Exception("Error fetching ReportCategries: ${response.body}");
      }
    } catch (e) {
      print("❌ Failed to fetch ReportCategries: $e");
    }
  }




  // /// 🔹 Add Feature with token + refresh
   Future<bool> addReportCategories({
    required List<String> category,
    
  }) async {

    final prefs = await SharedPreferences.getInstance();
   // final accesstoken = ref.read(loginProvider).data![0].accessToken;

    try {
       String? token = await _getToken(prefs);

       if (token == null || token.isEmpty) {
         throw Exception("User token invalid. Please log in again.");
       }

      final client = _retryClient(prefs,token);

      final response = await client.post(
        Uri.parse(Dgapi.getreportcategories),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "category": category,
         
        }),
      );

      print('Post Feature Plans Status Code: ${response.statusCode}');
      print('Post Feature Plans Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getReportCategries(); // refresh list
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Failed to create Feature Plans: $e");
      return false;
    }
  }




/// 🔹 Update Feature with token + refresh
Future<bool> updateReportCategories( {
  int? categoryId,
  required List<String> category,
}) async {
  final prefs = await SharedPreferences.getInstance();
 // final accesstoken = ref.read(loginProvider).data![0].accessToken;

  try {
    String? token = await _getToken(prefs);

    if (token == null || token.isEmpty) {
      throw Exception("User token invalid. Please log in again.");
    }

    final client = _retryClient(prefs, token);

    final response = await client.put(
      Uri.parse('${Dgapi.updateandDeletecategoies}/$categoryId'), 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
       "category": category,
      }),
    );

    print('PUT Feature Plans Status Code: ${response.statusCode}');
    print('PUT Feature Plans Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getReportCategries(); // refresh list
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("❌ Failed to update Feature Plans: $e");
    return false;
  }
}


/// 🔹 Delete Feature by ID with token + refresh
Future<bool> deleteReportCategories({
  required int? categoryId, 
}) async {
  final prefs = await SharedPreferences.getInstance();
 // final accesstoken = ref.read(loginProvider).data![0].accessToken;

  try {
    String? token = await _getToken(prefs);
    if (token == null || token.isEmpty) {
      throw Exception("User token invalid. Please log in again.");
    }

    final client = _retryClient(prefs, token);

    final response = await client.delete(
      Uri.parse('${Dgapi.updateandDeletecategoies}/$categoryId'), // API expects featureId in URL
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print('DELETE Feature Plans Status Code: ${response.statusCode}');
    print('DELETE Feature Plans Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      await getReportCategries(); // refresh list
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("❌ Failed to delete Feature Plans: $e");
    return false;
  }
}


  /// 🔹 Extract token from prefs (with fallback)
  Future<String?> _getToken(SharedPreferences prefs) async {
    String? userDataString = prefs.getString('userData');
    if (userDataString == null || userDataString.isEmpty) {
      throw Exception("User token missing. Please log in again.");
    }

    final Map<String, dynamic> userData = jsonDecode(userDataString);

    String? token = userData['accessToken'] ??
        (userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null);

    if (token == null || token.isEmpty) {
      throw Exception("User token invalid. Please log in again.");
    }

    return token;
  }

  /// 🔹 Retry client with refresh logic
  RetryClient _retryClient(SharedPreferences prefs, String? accesstoken) {
    return RetryClient(
      http.Client(),
      retries: 3,
      when: (res) => res.statusCode == 401 || res.statusCode == 400,
      onRetry: (req, res, retryCount) async {
        if (retryCount == 0 &&
            (res?.statusCode == 401 || res?.statusCode == 400)) {
          print("⚠️ Token expired, refreshing...");
          String? newAccessToken =
              await ref.read(loginProvider.notifier).restoreAccessToken();

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await prefs.setString('accessToken', newAccessToken);
            req.headers['Authorization'] = 'Bearer $newAccessToken';
            print("🔄 New Token: $newAccessToken");
          }
        }
      },
    );
  }



}

final reportCategoriesProviders =
    StateNotifierProvider<ReportCategoriesProviders, ReportCategoriesModel>((ref) {
  return ReportCategoriesProviders(ref);
});

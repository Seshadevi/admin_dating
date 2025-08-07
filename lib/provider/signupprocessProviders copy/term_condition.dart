
import 'package:admin_dating/models/signupprocessmodels/termConditionalModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TermsNotifier extends StateNotifier<TermsAndConditions> {
  final Ref ref;
  TermsNotifier(this.ref) : super(TermsAndConditions.initial());
  
  Future<void> getTermsandConditions() async {
    final loadingState = ref.read(loadingProvider.notifier);

    try {
      
      loadingState.state = true;

      print('get TermsAndConditions');

      final response = await http.get(
        Uri.parse(Dgapi.termsAndConditions));
      final responseBody = response.body;
      print('Get TermsAndConditions Status Code: ${response.statusCode}');
      print('Get TermsAndConditions Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = TermsAndConditions.fromJson(res);
          state = usersData;
          print("TermsAndConditions fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing TermsAndConditions.");
        }
      } else {
        print("Error fetching TermsAndConditions: ${response.body}");
        throw Exception("Error fetching TermsAndConditions: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch TermsAndConditions: $e");
    }
  }
   Future<bool> addterms({required String terms}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final prefs = await SharedPreferences.getInstance();

  try {
    loadingState.state = true;

    final apiUrl = Uri.parse(Dgapi.TermsAdd);
    final request = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
       
      },
      body: jsonEncode({
        '':terms,
      }),
    );

    print('Add Status Code: ${request.statusCode}');
    print('Add Response Body: ${request.body}');

    if (request.statusCode == 201 || request.statusCode == 200) {
      print("TermsandConditions added successfully!");
      await getTermsandConditions(); // Refresh after add
      return true;
    } else {
      final errorBody = jsonDecode(request.body);
      final errorMessage = errorBody['message'] ?? 'Unexpected error occurred.';
      print("Error adding TermsandConditions: $errorMessage");
      return false;
    }
  } catch (e) {
    print("Failed to add TermsandConditions: $e");
    return false;
  } finally {
    loadingState.state = false;
  }
}
}

final termsProvider = StateNotifierProvider<TermsNotifier, TermsAndConditions>((ref) {
  return TermsNotifier(ref);
});

import 'package:admin_dating/models/signupprocessmodels/termConditionalModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
}

final termsProvider = StateNotifierProvider<TermsNotifier, TermsAndConditions>((ref) {
  return TermsNotifier(ref);
});
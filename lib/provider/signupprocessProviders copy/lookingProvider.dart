
import 'package:admin_dating/models/signupprocessmodels/lookingModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LookingNotifier extends StateNotifier<LookingFor> {
  final Ref ref;
  LookingNotifier(this.ref) : super(LookingFor.initial());
  
  Future<void> getLookingFor() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get LookingFor');
      
      final response = await http.get(
        Uri.parse(Dgapi.lookingFor)
      );
      final responseBody = response.body;
      print('Get LookingFor Status Code: ${response.statusCode}');
      print('Get LookingFor Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = LookingFor.fromJson(res);
          state = usersData;
          print("LookingFor fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing LookingFor");
        }
      } else {
        print("Error fetching LookingFor: ${response.body}");
        throw Exception("Error fetching LookingFor: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch LookingFor: $e");
    }
  }
}

final lookingProvider = StateNotifierProvider<LookingNotifier,LookingFor>((ref) {
  return LookingNotifier(ref);
});
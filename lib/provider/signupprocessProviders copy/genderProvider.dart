

import 'package:admin_dating/models/signupprocessmodels/genderModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GenderNotifier extends StateNotifier<GenderModel> {
  final Ref ref;
  GenderNotifier(this.ref) : super(GenderModel.initial());
  
  Future<void> getGender() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get gender');

      
    final response = await http.get(
        Uri.parse(Dgapi.gender));
      final responseBody = response.body;
      print('Get gender Status Code: ${response.statusCode}');
      print('Get gender Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = GenderModel.fromJson(res);
          state = usersData;
          print("gender fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing gender.");
        }
      } else {
        print("Error fetching gender: ${response.body}");
        throw Exception("Error fetching gender: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch gender: $e");
    }
  }
}

final genderProvider = StateNotifierProvider<GenderNotifier, GenderModel>((ref) {
  return GenderNotifier(ref);
});
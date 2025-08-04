
import 'package:admin_dating/models/signupprocessmodels/drinkingModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DrinkingNotifier extends StateNotifier<DrinkingModel> {
  final Ref ref;
  DrinkingNotifier(this.ref) : super(DrinkingModel.initial());
  
  Future<void> getdrinking() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get drinking');

     final response = await http.get(
        Uri.parse(Dgapi.drinking));
      final responseBody = response.body;
      print('Get modes Status Code: ${response.statusCode}');
      print('Get modes Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = DrinkingModel.fromJson(res);
          state = usersData;
          print("drinking fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing driking.");
        }
      } else {
        print("Error fetching drinking: ${response.body}");
        throw Exception("Error fetching drinking: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch drinking: $e");
    }
  }
}

final drinkingProvider = StateNotifierProvider<DrinkingNotifier, DrinkingModel>((ref) {
  return DrinkingNotifier(ref);
});
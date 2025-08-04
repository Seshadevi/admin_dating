
import 'package:admin_dating/models/signupprocessmodels/choosefoodies_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class InterestsProvider extends StateNotifier<InterestsModel> {
  final Ref ref;
  InterestsProvider(this.ref) : super(InterestsModel.initial());
  
  Future<void> getInterests() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get intersts');

     final response = await http.get(
        Uri.parse(Dgapi.interests));
      final responseBody = response.body;
      print('Get modes Status Code: ${response.statusCode}');
      print('Get modes Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = InterestsModel.fromJson(res);
          state = usersData;
          print("intersts fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing interests.");
        }
      } else {
        print("Error fetching interests: ${response.body}");
        throw Exception("Error fetching interests: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch interests: $e");
    }
  }
}

final interestsProvider = StateNotifierProvider<InterestsProvider, InterestsModel>((ref) {
  return InterestsProvider(ref);
});
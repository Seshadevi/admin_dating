

import 'package:admin_dating/models/signupprocessmodels/religionModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ReligionNotifier extends StateNotifier<ReligionModel> {
  final Ref ref;
  ReligionNotifier(this.ref) : super(ReligionModel.initial());
  
  Future<void> getReligions() async {
    
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get religions');

      final response = await http.get(
        Uri.parse(Dgapi.religion));
      final responseBody = response.body;
      print('Get religions Status Code: ${response.statusCode}');
      print('Get religions Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = ReligionModel.fromJson(res);
          state = usersData;
          print("religions fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing religions.");
        }
      } else {
        print("Error fetching religions: ${response.body}");
        throw Exception("Error fetching religions: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch religions $e");
    }
  }
}

final religionProvider = StateNotifierProvider<ReligionNotifier, ReligionModel>((ref) {
  return ReligionNotifier(ref);
});

import 'package:admin_dating/models/signupprocessmodels/causesModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CausesNotifier extends StateNotifier<CausesModel> {
  final Ref ref;
  CausesNotifier(this.ref) : super(CausesModel.initial());
  
  Future<void> getCauses() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
    
      print('get causes');

      final response = await http.get(
        Uri.parse(Dgapi.causes)
      );
      final responseBody = response.body;
      print('Get cause Status Code: ${response.statusCode}');
      print('Get cause Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = CausesModel.fromJson(res);
          state = usersData;
          print("causes fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing causes.");
        }
      } else {
        print("Error fetching causes: ${response.body}");
        throw Exception("Error fetching causes: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch causes: $e");
    }
    finally {
    loadingState.state = false;
  }
  }
}

final causesProvider = StateNotifierProvider<CausesNotifier, CausesModel>((ref) {
  return CausesNotifier(ref);
});
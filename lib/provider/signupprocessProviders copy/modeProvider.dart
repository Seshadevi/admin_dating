import 'package:admin_dating/models/signupprocessmodels/modeModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ModeNotifier extends StateNotifier<ModeModel> {
  final Ref ref;
  ModeNotifier(this.ref) : super(ModeModel.initial());
  
  Future<void> getModes() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
      
      print('get modes');

      final response = await http.get(
        Uri.parse(Dgapi.modes));
      final responseBody = response.body;
      print('Get modes Status Code: ${response.statusCode}');
      print('Get modes Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = ModeModel.fromJson(res);
          state = usersData;
          print("modes fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing modes.");
        }
      } else {
        print("Error fetching modes: ${response.body}");
        throw Exception("Error fetching modes: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch modes: $e");
    }
  }
}

final modesProvider = StateNotifierProvider<ModeNotifier, ModeModel>((ref) {
  return ModeNotifier(ref);
});

import 'package:admin_dating/models/signupprocessmodels/defaultMessagesModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DefaultNotifier extends StateNotifier<DefaultModel> {
  final Ref ref;
  DefaultNotifier(this.ref) : super(DefaultModel.initial());
  
  Future<void> getdefaultmessages() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
   
      print('get default messages');

    
      final response = await http.get(
        Uri.parse(Dgapi.defaultMessages)       
      );
      final responseBody = response.body;
      print('Get default Status Code: ${response.statusCode}');
      print('Get default Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = DefaultModel.fromJson(res);
          state = usersData;
          print("default fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing default.");
        }
      } else {
        print("Error fetching defaultmessages: ${response.body}");
        throw Exception("Error fetching defaultmessages: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch defaultmessages: $e");
    }
  }
}

final defaultmessagesProvider = StateNotifierProvider<DefaultNotifier, DefaultModel>((ref) {
  return DefaultNotifier(ref);
});
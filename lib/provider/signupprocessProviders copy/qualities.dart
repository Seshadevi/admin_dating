import 'package:admin_dating/models/signupprocessmodels/qualitiesModel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class QualitiesNotifier extends StateNotifier<QualitiesModel> {
  final Ref ref;
  QualitiesNotifier(this.ref) : super(QualitiesModel.initial());
  
  Future<void> getQualities() async {
    final loadingState = ref.read(loadingProvider.notifier);
    try {
      loadingState.state = true;
     
      print('get Qualities');

      final response = await http.get(
        Uri.parse(Dgapi.qualities));
      final responseBody = response.body;
      print('Get Qualities Status Code: ${response.statusCode}');
      print('Get Qualities Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = QualitiesModel.fromJson(res);
          state = usersData;
          print("Qualities fetched successfully: ${usersData.message}");
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Qualities.");
        }
      } else {
        print("Error fetching Qualities: ${response.body}");
        throw Exception("Error fetching Qualities: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Qualities $e");
    }
  }
}

final qualitiesProvider = StateNotifierProvider<QualitiesNotifier, QualitiesModel>((ref) {
  return QualitiesNotifier(ref);
});
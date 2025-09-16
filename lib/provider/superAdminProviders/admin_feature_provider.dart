import 'dart:convert';

import 'package:admin_dating/models/superAdminModels/admin_feature_model.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AdminFeatureProvider extends StateNotifier<AdminFeatureModel> {
  final Ref ref;
  AdminFeatureProvider(this.ref) : super(AdminFeatureModel.initial());

  Future<void> getAdminFeatures() async {
    try {
      print('Fetching AdminFeature...');

      final response = await http.get(
        Uri.parse(Dgapi.adminfeatures),
      );

      final responseBody = response.body;
      print('Get AdminFeature Status Code: ${response.statusCode}');
      print('Get AdminFeature Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        try {
          final res = jsonDecode(responseBody);
          final usersData = AdminFeatureModel.fromJson(res);
          state = usersData;
          
          print('AdminFeature fetched successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing AdminFeature.");
        }
      } else {
        print("Error fetching AdminFeature: ${response.body}");
        throw Exception("Error fetching AdminFeature: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch AdminFeature: $e");
    }
  }


  

 Future<bool> addAdminFeatures ({
  required String featureName,

  }) async {
    try {
      print('Creating AdminFeatures...');

      final response = await http.post(
        Uri.parse(Dgapi.adminaddfeatures),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "featureName": featureName,
        }),
      );

      final responseBody = response.body;
      print('Post AdminFeatures Status Code: ${response.statusCode}');
      print('Post AdminFeatures Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getAdminFeatures();
        try {
          final res = jsonDecode(responseBody);
          print('......$res');
          // final roleData = GetRolesModel.fromJson(res);

          // state = roleData;
          print('AdminFeatures created successfully');
          return true;

        } catch (e) {
          print("Invalid response format: $e");
          return false;
         // throw Exception("Error parsing role response.");
        }
      } else {
        print("Error creating AdminFeatures: ${response.body}");
        return false;
        //throw Exception("Error creating role: ${response.body}");
      }
    } catch (e) {
      print("Failed to create AdminFeatures: $e");
      return false;
    }
  }

}
 
 final adminFeatureProvider = StateNotifierProvider <AdminFeatureProvider,AdminFeatureModel>((ref){
   return AdminFeatureProvider(ref);
 });
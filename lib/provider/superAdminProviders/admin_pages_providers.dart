import 'dart:convert';

import 'package:admin_dating/models/superAdminModels/admin_pages_model.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AdminPagesProviders extends StateNotifier<AdminpagesModel>{
   final Ref ref;
  AdminPagesProviders(this.ref) : super(AdminpagesModel.initial());



  
  Future<void> getadminpages() async {
    try {
      print('Fetching adminpages...');

      final response = await http.get(
        Uri.parse(Dgapi.admingetpages),
      );

      final responseBody = response.body;
      print('Get adminpages Status Code: ${response.statusCode}');
      print('Get adminpages Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        try {
          final res = jsonDecode(responseBody);
          final usersData = AdminpagesModel.fromJson(res);
          state = usersData;
          
          print('adminpages fetched successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing roles.");
        }
      } else {
        print("Error fetching adminpages: ${response.body}");
        throw Exception("Error fetching adminpages: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch adminpages: $e");
    }
  }

  
}

 
final adminPagesProviders =
    StateNotifierProvider<AdminPagesProviders, AdminpagesModel>((ref) {
  return AdminPagesProviders(ref);
});
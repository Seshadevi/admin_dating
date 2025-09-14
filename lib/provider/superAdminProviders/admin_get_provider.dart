import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/models/superAdminModels/admin_get_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;



class AdminGetsProvider extends StateNotifier<List<AdminGetModel>>
 {
  final Ref ref;
AdminGetsProvider(this.ref) : super([]);



  // Future<void> getAdmins() async {
  //   try {
  //     print('Fetching Admins...');

  //     final response = await http.get(
  //       Uri.parse(Dgapi.fetchadmins),
  //     );

  //     final responseBody = response.body;
  //     print('Get Admins Status Code: ${response.statusCode}');
  //     print('Get Admins Response Body: $responseBody');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       try {
  //         final res = jsonDecode(responseBody);
  //         final usersData = AdminGetModel.fromJson(res);
  //         state = usersData;
          
  //         print('Admins fetched successfully');
  //       } catch (e) {
  //         print("Invalid response format: $e");
  //         throw Exception("Error parsing Admins.");
  //       }
  //     } else {
  //       print("Error fetching Admins: ${response.body}");
  //       throw Exception("Error fetching Admins: ${response.body}");
  //     }
  //   } catch (e) {
  //     print("Failed to fetch Admins: $e");
  //   }
  // }


Future<void> getAdmins() async {
  try {
    final response = await http.get(Uri.parse(Dgapi.fetchadmins));
    final responseBody = response.body;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final res = jsonDecode(responseBody);
      final usersData = (res as List).map((json) => AdminGetModel.fromJson(json)).toList();
      state = usersData; // <- state must now be List<AdminGetModel>
    } else {
      throw Exception("Error fetching Admins: ${response.body}");
    }
  } catch (e) {
    print("Failed to fetch Admins: $e");
  }
}


  
   Future<bool> createAdmin({
    required File image,
    required String firstName,
    required String email,
    required String password,
    required String roleId,
  }) async {
    try {
       ref.read(loadingProvider.notifier).state = true;
      var uri = Uri.parse(Dgapi.createadmin);

      var request = http.MultipartRequest("POST", uri);

      // Add text fields
      request.fields['userame'] = firstName;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['roleId'] = roleId ; // fixed value based on Postman

      // Add image file
      if (image.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profilePic',
          image.path,
        ));
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Create Admin Status: ${response.statusCode}");
      print("Create Admin Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // You can decode if needed
        final res = jsonDecode(response.body);
        print("Admin created: $res");
        getAdmins();
        return true;
      } else {
        print("Error creating admin: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception while creating admin: $e");
     
      return false;
    }
    finally{
      ref.read(loadingProvider.notifier).state = false;
    }
  }
}



// Riverpod provider
final adminGetsProvider =
    StateNotifierProvider<AdminGetsProvider, List<AdminGetModel>>((ref) {
  return AdminGetsProvider(ref);
});

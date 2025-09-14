import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/models/superAdminModels/admin_get_model.dart';
import 'package:admin_dating/models/superAdminModels/roles_get_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;



class RolesProvider extends StateNotifier<GetRolesModel> {
  final Ref ref;
  RolesProvider(this.ref) : super(GetRolesModel.initial());

  Future<void> getroles() async {
    try {
      print('Fetching roles...');

      final response = await http.get(
        Uri.parse(Dgapi.fetchroles),
      );

      final responseBody = response.body;
      print('Get roles Status Code: ${response.statusCode}');
      print('Get roles Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = GetRolesModel.fromJson(res);
          state = usersData;
          
          print('roles fetched successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing roles.");
        }
      } else {
        print("Error fetching roles: ${response.body}");
        throw Exception("Error fetching roles: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch roles: $e");
    }
  }





 Future<bool> addRole ({
  required String roleName,

  }) async {
    try {
      print('Creating role...');

      final response = await http.post(
        Uri.parse(Dgapi.addroles),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "role_name": roleName,
        }),
      );

      final responseBody = response.body;
      print('Post Role Status Code: ${response.statusCode}');
      print('Post Role Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          print('......$res');
          // final roleData = GetRolesModel.fromJson(res);

          // state = roleData;
          print('Role created successfully');
          return true;

        } catch (e) {
          print("Invalid response format: $e");
          return false;
         // throw Exception("Error parsing role response.");
        }
      } else {
        print("Error creating role: ${response.body}");
        return false;
        //throw Exception("Error creating role: ${response.body}");
      }
    } catch (e) {
      print("Failed to create role: $e");
      return false;
    }
  }

  
  //  Future<bool> createRole({
  //   required File image,
  //   required String firstName,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //      ref.read(loadingProvider.notifier).state = true;
  //     var uri = Uri.parse(Dgapi.login1);

  //     var request = http.MultipartRequest("POST", uri);

  //     // Add text fields
  //     request.fields['firstName'] = firstName;
  //     request.fields['email'] = email;
  //     request.fields['password'] = password;
  //     request.fields['role'] = "admin"; // fixed value based on Postman

  //     // Add image file
  //     if (image.path.isNotEmpty) {
  //       request.files.add(await http.MultipartFile.fromPath(
  //         'profilePic',
  //         image.path,
  //       ));
  //     }

  //     // Send request
  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     print("Create Admin Status: ${response.statusCode}");
  //     print("Create Admin Response: ${response.body}");

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // You can decode if needed
  //       final res = jsonDecode(response.body);
  //       print("Admin created: $res");
  //      // getAdmins();
  //       return true;
  //     } else {
  //       print("Error creating admin: ${response.body}");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Exception while creating admin: $e");
     
  //     return false;
  //   }
  //   finally{
  //     ref.read(loadingProvider.notifier).state = false;
  //   }
  // }
}



// Riverpod provider
final rolesProvider =
    StateNotifierProvider<RolesProvider, GetRolesModel>((ref) {
  return RolesProvider(ref);
});
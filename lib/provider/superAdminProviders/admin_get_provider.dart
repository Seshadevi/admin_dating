import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/constants/dating_colors.dart';
import 'package:admin_dating/models/superAdminModels/admin_get_model.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter/material.dart';
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
    print("Sending username: ${firstName}");
    print("Sending email: ${email}");
    print("Sending password: ${password}");
    print("Sending roleId: ${roleId}");
    print("Sending profilePic: ${image.path}");

    try {
       ref.read(loadingProvider.notifier).state = true;
      var uri = Uri.parse(Dgapi.createadmin);

      var request = http.MultipartRequest("POST", uri);

      // Add text fields
     request.fields['username'] = firstName;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['roleId'] = roleId;
 // fixed value based on Postman

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


  Future<bool> updateAdmin({
  required int id,
  File? image, // optional, only send if changed
  required String firstName,
  required String email,
  required String password,
  required String roleId,
}) async {
  print("Updating admin ID: $id");
  print("Sending username: $firstName");
  print("Sending email: $email");
  print("Sending password: $password");
  print("Sending roleId: $roleId");
  print("Sending profilePic: ${image?.path}");

  try {
    ref.read(loadingProvider.notifier).state = true;
    var uri = Uri.parse("http://97.74.93.26:6100/superAdmin/updateAdmin/$id");

    var request = http.MultipartRequest("PUT", uri);

    // Add text fields
    request.fields['username'] = firstName;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['roleId'] = roleId;

    // Add image only if user picked a new one
    if (image != null && image.path.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'profilePic',
        image.path,
      ));
    }

    // Send request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Update Admin Status: ${response.statusCode}");
    print("Update Admin Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final res = jsonDecode(response.body);
      print("Admin updated: $res");
      await getAdmins(); // refresh list
      return true;
    } else {
      print("Error updating admin: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Exception while updating admin: $e");
    return false;
  } finally {
    ref.read(loadingProvider.notifier).state = false;
  }
}


Future<void> deleteAdmin(int id, {BuildContext? context}) async {
  try {
    final uri = Uri.parse("http://97.74.93.26:6100/superAdmin/deleteAdmin/$id");
    final response = await http.delete(uri);

    print("Delete Admin Status: ${response.statusCode}");
    print("Delete Admin Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getAdmins(); // refresh list

      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Admin deleted successfully",style: TextStyle(color: Colors.white),),
            backgroundColor: DatingColors.darkGreen,
          ),
        );
      }
    } else {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete admin: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    print("Exception while deleting admin: $e");
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

}



// Riverpod provider
final adminGetsProvider =
    StateNotifierProvider<AdminGetsProvider, List<AdminGetModel>>((ref) {
  return AdminGetsProvider(ref);
});

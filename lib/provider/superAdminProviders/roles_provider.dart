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
        await getroles();
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



Future<bool> updateRole({
  required int id,
  required String roleName,
}) async {
  try {
    print('Updating role ID: $id with name: $roleName');

    final response = await http.patch(
      Uri.parse("http://97.74.93.26:6100/superAdmin/adminRole/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "role_name": roleName,
      }),
    );

    final responseBody = response.body;
    print('Update Role Status Code: ${response.statusCode}');
    print('Update Role Response Body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getroles(); // refresh roles list
      try {
        final res = jsonDecode(responseBody);
        print('Role updated successfully: $res');
        return true;
      } catch (e) {
        print("Invalid response format: $e");
        return false;
      }
    } else {
      print("Error updating role: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Failed to update role: $e");
    return false;
  }
}





Future<bool> deleteRole(int? id) async {
  try {
    print('Deleting role with ID: $id');

    final response = await http.delete(
      Uri.parse("http://97.74.93.26:6100/superAdmin/adminRole/$id"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    final responseBody = response.body;
    print('Delete Role Status Code: ${response.statusCode}');
    print('Delete Role Response Body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
      await getroles();
      try {
        final res = jsonDecode(responseBody);
        print('Role deleted successfully: $res');
        return true;
      } catch (e) {
        print("Invalid response format: $e");
        return false;
      }
    } else {
      print("Error deleting role: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Failed to delete role: $e");
    return false;
  }
}

}



// Riverpod provider
final rolesProvider =
    StateNotifierProvider<RolesProvider, GetRolesModel>((ref) {
  return RolesProvider(ref);
});
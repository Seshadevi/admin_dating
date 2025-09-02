import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';

class LoginNotifier extends StateNotifier<UserModel> {
  final Ref ref;
  LoginNotifier(this.ref) : super(UserModel.initial());

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      print('No user data found.');
      return false;
    }

    try {
      final extractedData = json.decode(prefs.getString('userData')!);
      final loginModel = UserModel.fromJson(extractedData);

      if (loginModel.data == null ||
          loginModel.data![0].accessToken == null ||
          loginModel.data![0].user == null) {
        print('Invalid user data structure.');
        return false;
      }

      // Update your provider state here (if applicable)
      state = loginModel;

      print('Auto-login successful. User ID: ${loginModel.data![0].user!.id}');
      return true;
    } catch (e, stackTrace) {
      print('Error during auto-login: $e');
      print(stackTrace);
      return false;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    const String apiUrl = Dgapi.login;
    final prefs = await SharedPreferences.getInstance();
    print("api function email:$email, password:$password");

    try {
      print("this inside try block for login api func");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginModel = UserModel.fromJson(decoded);

        await prefs.setString('userData', json.encode(loginModel.toJson()));
        state = loginModel;

        return loginModel;
      } else {
        return UserModel(
          success: false,
          messages: [decoded['message'] ?? 'Login failed.'],
        );
      }
    } catch (e) {
      return UserModel(success: false, messages: ["Server error occurred."]);
    }
  }

  Future<String> restoreAccessToken() async {
    const url = Dgapi.refreshToken;
    final prefs = await SharedPreferences.getInstance();

    try {
      final currentUser = ref.read(loginProvider);
      final currentRefreshToken = currentUser.data?.first.refreshToken;

      if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
        throw Exception("No valid refresh token found.");
      }

      print("Using refresh token: $currentRefreshToken");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $currentRefreshToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({"refresh_token": currentRefreshToken}),
      );

      final userDetails = json.decode(response.body);
      print('Token refresh response: $userDetails');

      if (response.statusCode == 200) {
        final newAccessToken = userDetails['data']['access_token'];
        final newRefreshToken = userDetails['data']['refresh_token'];

        print('New access token: $newAccessToken');
        print('New refresh token: $newRefreshToken');

        // You can update the UserModel here if needed
        return newAccessToken;
      } else {
        print("Failed to refresh token. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Exception while refreshing token: $e');
    }

    return '';
  }

  Future<int> signupuserApi({
    String? email,
    String? mobile,
    // double? latitude,
    // double? longitude,
    String? userName,
    String? dateOfBirth,
    String? selectedGender,
    bool? showGenderOnProfile,
    List<int>? modeid,
    List<int>? drinkingId,
    List<int>? selectedkidsIds,
    List<int>? selectedreligionIds,
    List<int>? selectedGenderIds,
    List<int>? selectedInterestIds,
    List<int>? selectedcauses,
    List<int>? selectedLookingfor,
    List<int>? selectedqualities,
    List<String>? seletedprompts,
    List<dynamic>? choosedimages,
    List<int>? defaultmessages,
    String? finalheadline,
    bool? termsAndCondition,
    int? selectedHeight,
    List<int>? experience,
    List<int>? industry,
    List<int>?relationship,
    List<int>?starsign,
    List<int>?languages,
    String?hometown,
   String? newtotown,
   String? politics,
   String? pronoun,
   String? educationlevel,
   String? havekids,
  }) async {
    const String apiUrl = Dgapi.login1;
    final prefs = await SharedPreferences.getInstance();
    final int? userId = state.data?.first.user?.id;

    print("✅ Proceeding with API request...");
    print(
        'sign in data.........userId:$userId:$email,mobile:$mobile,latitude:,longitude:,Name:$userName,dob:$dateOfBirth,selectedgender:$selectedGender:');
    print('data:::lookinfor:$selectedLookingfor,qualities::$selectedqualities,interests:$selectedInterestIds,kids:$selectedkidsIds,defaltmessages:$defaultmessages,drinking:$drinkingId,religion:$selectedreligionIds,');
    print(
        'data.......show:$showGenderOnProfile,height:$selectedHeight,headline:$finalheadline,images:${choosedimages!.length},mode:$modeid');

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Basic fields
      request.fields['email'] = email ?? '';
      request.fields['latitude'] = "12.99";
      request.fields['longitude'] = "14.9";
      // request.fields['latitude'] = latitude.toString();
      // request.fields['longitude'] = longitude.toString();
      request.fields['firstName'] = userName ?? '';
      request.fields['dob'] = dateOfBirth ?? '';
      request.fields['role'] = "user";
      // request.fields['gender'] = selectedGender?? '';
      request.fields['gender'] = 'Man';
      request.fields['showOnProfile'] = showGenderOnProfile.toString();
      request.fields['height'] = selectedHeight.toString();
      request.fields['headLine'] = finalheadline ?? '';
      request.fields['mobile'] = mobile ?? '';
      request.fields['createdByAdminId'] = userId?.toString() ?? '';
      request.fields['prompts'] = seletedprompts?.join(',') ?? '';
      request.fields['educationLevel'] = educationlevel.toString();
      request.fields['newToArea'] = newtotown.toString();
      request.fields['hometown'] = hometown.toString();
      request.fields['haveKids'] = havekids.toString();
      request.fields['politics'] = politics.toString();
      request.fields['pronouns'] = pronoun.toString();
      

      // // Safe list fields (skip empty ones)
      if (selectedGenderIds != null) {
        for (int i = 0; i < selectedGenderIds.length; i++) {
          request.fields['genderIdentities[$i]'] =
              selectedGenderIds[i].toString(); // ✅
        }
      }

      if (selectedInterestIds != null) {
        for (int i = 0; i < selectedInterestIds.length; i++) {
          request.fields['interests[$i]'] = selectedInterestIds[i].toString();
        }
      }
      if (starsign != null) {
        for (int i = 0; i < starsign.length; i++) {
          request.fields['starSign[$i]'] = starsign[i].toString();
        }
      }
      if (relationship != null) {
        for (int i = 0; i < relationship.length; i++) {
          request.fields['relationships[$i]'] = relationship[i].toString();
        }
      }
      if (experience != null) {
        for (int i = 0; i < experience.length; i++) {
          request.fields['experiences[$i]'] = experience[i].toString();
        }
        
      }
       if (modeid != null) {
        for (int i = 0; i < modeid.length; i++) {
          request.fields['modeId[$i]'] = modeid[i].toString();
        }
        
      }
      if (industry != null) {
        for (int i = 0; i < industry.length; i++) {
          request.fields['industries[$i]'] = industry[i].toString();
        }
      }
       if (languages != null) {
        for (int i = 0; i < languages.length; i++) {
          request.fields['spokenLanguages[$i]'] = languages[i].toString();
        }
      }

      if (selectedqualities != null) {
        for (int i = 0; i < selectedqualities.length; i++) {
          request.fields['qualities[$i]'] = selectedqualities[i].toString();
        }
      }
      if (selectedkidsIds != null) {
        for (int i = 0; i < selectedkidsIds.length; i++) {
          request.fields['kids[$i]'] = selectedkidsIds![i].toString();
        }
      }
      if (drinkingId != null) {
        for (int i = 0; i < drinkingId.length; i++) {
          request.fields['drinking[$i]'] = drinkingId[i].toString();
        }
      }

      if (selectedLookingfor != null) {
        for (int i = 0; i < selectedLookingfor.length; i++) {
          request.fields['lookingFor[$i]'] = selectedLookingfor![i].toString();
        }
      }

      if (selectedreligionIds != null) {
        for (int i = 0; i < selectedreligionIds.length; i++) {
          request.fields['religions[$i]'] = selectedreligionIds[i].toString();
        }
      }

      if (selectedcauses != null) {
        for (int i = 0; i < selectedcauses.length; i++) {
          request.fields['causesAndCommunities[$i]'] =
              selectedcauses[i].toString();
        }
      }

      // if (seletedprompts!=null) {
      //   // Prompts (Map<int, String>)
      //   seletedprompts.forEach((key, value) {
      //     request.fields['prompts[$key]'] = value;
      //   } );
      // }

      if (defaultmessages != null) {
        for (int i = 0; i < defaultmessages.length; i++) {
          request.fields['defaultMessages[$i]'] = defaultmessages[i].toString();
        }
      }

      // Upload images (only jpg/png/jpeg)
      for (int i = 0; i < choosedimages!.length; i++) {
        final image = choosedimages[i];

        if (image != null && await image.exists()) {
          final filePath = image.path;
          final fileExtension = filePath.split('.').last.toLowerCase();

          MediaType? contentType;
          if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
            contentType = MediaType('image', 'jpeg');
          } else if (fileExtension == 'png') {
            contentType = MediaType('image', 'png');
          } else {
            print('❌ Unsupported file type: $filePath');
            continue;
          }

          final multipartFile = await http.MultipartFile.fromPath(
            'profilePic',
            filePath,
            contentType: contentType,
          );

          request.files.add(multipartFile);
        }
      }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("🔄 API Response: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await prefs.setBool("isSignedUp", true);

        print('User added succesfully.');
        return response.statusCode;
      } else {
        print("❌ Signup failed with status: ${response.statusCode}");
        return response.statusCode;
      }
    } catch (e) {
      print("❗ Exception during signup: $e");
      return 500;
    }
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  return LoginNotifier(ref);
});

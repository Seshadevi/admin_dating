import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/provider/loader.dart';
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
          request.fields['starSignId[$i]'] = starsign[i].toString();
        }
      }
      if (relationship != null) {
        for (int i = 0; i < relationship.length; i++) {
          request.fields['relationshipId[$i]'] = relationship[i].toString();
        }
      }
      if (experience != null) {
        for (int i = 0; i < experience.length; i++) {
          request.fields['experienceId[$i]'] = experience[i].toString();
        }
        
      }
       if (modeid != null) {
        for (int i = 0; i < modeid.length; i++) {
          request.fields['modeId[$i]'] = modeid[i].toString();
        }
        
      }
      if (industry != null) {
        for (int i = 0; i < industry.length; i++) {
          request.fields['industryId[$i]'] = industry[i].toString();
        }
      }
       if (languages != null) {
        for (int i = 0; i < languages.length; i++) {
          request.fields['languageId[$i]'] = languages[i].toString();
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
  Future<int> updateProfile({
  String? specificToken,
  List<int>? modeid,
  String? modename,
  List<int>? causeId,
  String? bio,
  List<int>? interestId,
  List<int>? qualityId,
  List<String>? prompt,
  List<dynamic>? image,
  List<int>? languagesId,
  List<int>? starsignId,
  int? jobId,
  int? educationId,
  List<int>? religionId,
  List<int>? lookingfor,
  List<int>? kidsId,
  List<int>? drinkingId,
  // int? eductionId,
  String? smoking,
  String? gender,
  bool? showOnProfile,
  String? pronoun,
  String?exercise,
  List<int>? industryId,
  List<int>? experienceId,
  String? haveKids,
  String? educationLevel,
  String? newarea,
  int? height,
  List<int>? relationshipId,
  String? name,
  String? dob,
  // List<int>?causes,
  String? hometown,
  String? politics,
}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  loadingState.state = true;
   print(
        'updated data...industires:$industryId,expereince:$experienceId,.home:$hometown,causes:$causeId,lookingfor:$lookingfor,mode:$modeid,smoking:$smoking, modename:$modename,, intrestId:$interestId, qualityId:$qualityId, bio:$bio, prompt:$prompt, image:${image?.length},languages:$languagesId,work:$jobId,education:$educationId,starsign:$starsignId');
  
  try {
    final String apiUrl = Dgapi.updateprofile;
    final prefs = await SharedPreferences.getInstance();
    loadingState.state = true;
      
      String? token;

      // If a specific token is provided, use it directly
      if (specificToken != null && specificToken.isNotEmpty) {
        token = specificToken;
        print('Using provided token: $token');
      } else {
        // Fallback to the original logic
        String? userDataString = prefs.getString('userData');
        if (userDataString == null || userDataString.isEmpty) {
          throw Exception("User token is missing. Please log in again.");
        }

        final Map<String, dynamic> userData = jsonDecode(userDataString);

        token = userData['accessToken'] ??
            (userData['data'] != null &&
                    (userData['data'] as List).isNotEmpty &&
                    userData['data'][0]['access_token'] != null
                ? userData['data'][0]['access_token']
                : null);

        if (token == null || token.isEmpty) {
          throw Exception("User token is invalid. Please log in again.");
        }

        print('Retrieved Token from SharedPreferences: $token');
      }

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            
            // Only try to refresh if we're not using a specific token
            if (specificToken == null) {
              String? newAccessToken =
                  await ref.read(loginProvider.notifier).restoreAccessToken();
              
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken;
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              
              print("New Token: $newAccessToken");
            } else {
              print("Cannot refresh specific token, using original");
              req.headers['Authorization'] = 'Bearer $specificToken';
            }
          }
        },
      );

     


    
    var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Add simple fields if not null
    if (modeid != null) request.fields['modeId'] = modeid.toString();
    if (modename != null) request.fields['modename'] = modename;
    if (bio != null) request.fields['headLine'] = bio;
    if (religionId != null) request.fields['religionId'] = religionId.toString();
    if (experienceId != null) request.fields['experiences'] = experienceId.toString();
    if (industryId != null) request.fields['industries'] = industryId.toString();
    if (jobId != null) request.fields['workId'] = jobId.toString();
    if (educationId != null) request.fields['educationId'] = educationId.toString();
    if (starsignId != null) request.fields['starSignId'] = starsignId.toString();
    if (smoking != null) request.fields['smoking'] = smoking.toString();
    if (gender != null) request.fields['gender'] = gender.toString();
    if (showOnProfile != null) request.fields['showOnProfile'] = showOnProfile.toString();
    if (pronoun != null) request.fields['pronouns'] = pronoun.toString();
    if (exercise != null) request.fields['exercise'] =exercise.toString();
    if (haveKids != null) request.fields['haveKids'] =haveKids.toString();
    if (educationLevel != null) request.fields['educationLevel'] =educationLevel.toString();
    if (newarea != null) request.fields['newToArea'] =newarea.toString();
    if (height != null) request.fields['height'] =height.toString();
    if ( relationshipId != null) request.fields[' relationshipId'] = relationshipId.toString();
    if (industryId != null) request.fields['industryId'] =industryId.toString();
    if (experienceId != null) request.fields['experienceId'] =experienceId.toString();
    
    // Add list fields as indexed keys
    void addListField(String key, List<int>? values) {
      if (values != null && values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          request.fields['$key[$i]'] = values[i].toString();
        }
      }
    }

    addListField('causesAndCommunities', causeId);
    addListField('interests', interestId);
    addListField('qualities', qualityId);
    addListField('lookingFor', lookingfor);
    addListField('kids', kidsId);
    addListField('drinking', drinkingId);
    addListField('languageId', languagesId);
    // addListField('languageId', languagesId);

    // Handle prompt (List<Map<String,String>>) as JSON string if needed
    // if (prompt != null && prompt.isNotEmpty) {
    //   request.fields['prompts'] = jsonEncode(prompt);
    // }
    if (prompt != null && prompt.isNotEmpty) {
        for (int i = 0; i < prompt.length; i++) {
          request.fields['prompts[$i]'] = prompt[i].toString();
        }
      }

    // Upload images if any
   if (image != null && image.isNotEmpty) {
  for (int i = 0; i < image.length; i++) {
    final filePath = image[i]; // String path
    final file = File(filePath);

    if (await file.exists()) {
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
        'profilePic', // confirm with backend
        filePath,
        contentType: contentType,
      );

      request.files.add(multipartFile);
    } else {
      print('⚠️ File not found: $filePath');
    }
  }
}

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print("📨 API Responsebody: $responseBody");
    print("Status code: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Updated data parsed successfully");

      final userDetails = jsonDecode(responseBody);

      try {
        final userModel = UserModel.fromJson(userDetails);
        state = userModel;

        final userData = json.encode(userDetails);
        await prefs.setString('userData', userData);
        print('User data saved in SharedPreferences.');
      } catch (_) {
        if (userDetails['data'] != null && userDetails['data'] is List) {
          await prefs.setString('userData', responseBody);
        } else {
          throw Exception("Failed to parse updated profile data");
        }
      }

      return response.statusCode;
    } else {
      throw Exception("Profile update failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("❗ Exception during profile update: $e");
    throw Exception("Update failed: $e");
  } finally {
    loadingState.state = false;
  }
}
}

final loginProvider = StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  return LoginNotifier(ref);
});

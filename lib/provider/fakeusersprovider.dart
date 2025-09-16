// import 'dart:convert';
// import 'dart:io';
// import 'package:admin_dating/models/users/admincreatedusersmodes.dart';
// import 'package:admin_dating/models/users/admincreatedusersmodes.dart';
// import 'package:admin_dating/provider/loader.dart';
// import 'package:admin_dating/utils/dgapi.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/retry.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:admin_dating/provider/users/admincreatedusersprovider.dart';

// import 'package:http_parser/http_parser.dart';

// class Fakeusersprovider extends StateNotifier<AdminCreatedUsersModel> {
//   final Ref ref;
//   Fakeusersprovider(this.ref) : super(AdminCreatedUsersModel.initial());

  

//   Future<int> signupuserApi({
//   String? email,
//   String? mobile,
//   double? latitude,
//   double? longitude,
//   String? userName,
//   String? dateOfBirth,
//   String? selectedGender,
//   bool? showGenderOnProfile,
//   List<int>? modeid,
//   List<int>? drinkingId,
//   List<int>? selectedkidsIds,
//   List<int>? selectedreligionIds,
//   List<int>? selectedGenderIds,
//   List<int>? selectedInterestIds,
//   List<int>? selectedcauses,
//   List<int>? selectedLookingfor,
//   List<int>? selectedqualities,
//   List<String>? seletedprompts,
//   List<dynamic>? choosedimages,
//   List<int>? defaultmessages,
//   String? finalheadline,
//   bool? termsAndCondition,
//   int? selectedHeight,
//   List<int>? experience,
//   List<int>? industry,
//   List<int>? relationship,
//   List<int>? starsign,
//   List<int>? languages,
//   String? hometown,
//   String? newtotown,
//   String? politics,
//   String? pronoun,
//   String? educationlevel,
//   String? havekids,
// }) async {
//   const String apiUrl = Dgapi.login1;
//   final prefs = await SharedPreferences.getInstance();
//   RetryClient? client;

//   print("✅ Proceeding with API request...");
//   print('Sign in data - email: $email, mobile: $mobile, userName: $userName');
//   final loadingState = ref.read(loadingProvider.notifier);

//   try {
//     final loadingState = ref.read(loadingProvider.notifier);
//     loadingState.state = true;

//     // Get admin access token from SharedPreferences
//     String? userDataString = prefs.getString('userData');
//     if (userDataString == null || userDataString.isEmpty) {
//       throw Exception("Admin token is missing. Please log in again.");
//     }

//     final Map<String, dynamic> userData = jsonDecode(userDataString);
    
//     // Extract access token from admin data
//     String? adminToken = userData['accessToken'] ??
//         (userData['data'] != null &&
//                 (userData['data'] as List).isNotEmpty &&
//                 userData['data'][0]['access_token'] != null
//             ? userData['data'][0]['access_token']
//             : null);

//     if (adminToken == null || adminToken.isEmpty) {
//       throw Exception("Admin token is invalid. Please log in again.");
//     }

//     // Get admin user ID for createdByAdminId field
//     int? adminUserId = userData['data'] != null &&
//             (userData['data'] as List).isNotEmpty &&
//             userData['data'][0]['user'] != null
//         ? userData['data'][0]['user']['id']
//         : null;

//     print('Retrieved Admin Token: $adminToken');
//     print('Admin User ID: $adminUserId');

//     // Setup retry client
//     client = RetryClient(
//       http.Client(),
//       retries: 3,
//       when: (res) => res.statusCode == 401 || res.statusCode == 400,
//       onRetry: (req, res, retryCount) async {
//         if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
//           print("Admin token expired, refreshing...");
//           final newAccessToken = await ref.read(fakeusersprovider.notifier).restoreAccessToken();
//           if (newAccessToken != null && newAccessToken.isNotEmpty) {
//             await prefs.setString('accessToken', newAccessToken);
//             adminToken = newAccessToken;
//             req.headers['Authorization'] = 'Bearer $newAccessToken';
//             print("New Admin Token: $newAccessToken");
//           }
//         }
//       },
//     );

//     // Build multipart PUT request
//     final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//     request.headers['Authorization'] = 'Bearer $adminToken';
//     request.headers['Accept'] = 'application/json';

//     // Basic required fields
//     request.fields['role'] = "user";
    
//     if (adminUserId != null) {
//       request.fields['createdByAdminId'] = adminUserId.toString();
//     }

//     // Basic user information
//     if (email != null) request.fields['email'] = email;
//     if (mobile != null) request.fields['mobile'] = mobile;
//     if (userName != null) request.fields['firstName'] = userName;
//     if (dateOfBirth != null) request.fields['dob'] = dateOfBirth;
//     if (selectedGender != null) request.fields['gender'] = selectedGender;
//     if (finalheadline != null) request.fields['headLine'] = finalheadline;
    
//     // Location data
//     if (latitude != null) request.fields['latitude'] = latitude.toString();
//     if (longitude != null) request.fields['longitude'] = longitude.toString();

//     // Boolean fields
//     if (showGenderOnProfile != null) {
//       request.fields['showOnProfile'] = showGenderOnProfile.toString();
//     }
//     if (havekids != null) request.fields['haveKids'] = havekids;
//     if (newtotown != null) request.fields['newToArea'] = newtotown;

//     // Numeric fields
//     if (selectedHeight != null) {
//       request.fields['height'] = selectedHeight.toString();
//     }

//     // String fields
//     if (educationlevel != null) request.fields['educationLevel'] = educationlevel;
//     if (hometown != null) request.fields['hometown'] = hometown;
//     if (politics != null) request.fields['politics'] = politics;
//     if (pronoun != null) request.fields['pronouns'] = pronoun;

//     // List fields with proper array formatting
//     if (seletedprompts != null && seletedprompts.isNotEmpty) {
//       for (int i = 0; i < seletedprompts.length; i++) {
//         request.fields['prompts[$i]'] = seletedprompts[i];
//       }
//     }

//     if (modeid != null && modeid.isNotEmpty) {
//       for (int i = 0; i < modeid.length; i++) {
//         request.fields['modeId[$i]'] = modeid[i].toString();
//       }
//     }

//     if (selectedGenderIds != null && selectedGenderIds.isNotEmpty) {
//       for (int i = 0; i < selectedGenderIds.length; i++) {
//         request.fields['genderIdentities[$i]'] = selectedGenderIds[i].toString();
//       }
//     }

//     if (selectedInterestIds != null && selectedInterestIds.isNotEmpty) {
//       for (int i = 0; i < selectedInterestIds.length; i++) {
//         request.fields['interests[$i]'] = selectedInterestIds[i].toString();
//       }
//     }

//     if (selectedqualities != null && selectedqualities.isNotEmpty) {
//       for (int i = 0; i < selectedqualities.length; i++) {
//         request.fields['qualities[$i]'] = selectedqualities[i].toString();
//       }
//     }

//     if (selectedLookingfor != null && selectedLookingfor.isNotEmpty) {
//       for (int i = 0; i < selectedLookingfor.length; i++) {
//         request.fields['lookingFor[$i]'] = selectedLookingfor[i].toString();
//       }
//     }

//     if (selectedcauses != null && selectedcauses.isNotEmpty) {
//       for (int i = 0; i < selectedcauses.length; i++) {
//         request.fields['causesAndCommunities[$i]'] = selectedcauses[i].toString();
//       }
//     }

//     if (selectedreligionIds != null && selectedreligionIds.isNotEmpty) {
//       for (int i = 0; i < selectedreligionIds.length; i++) {
//         request.fields['religions[$i]'] = selectedreligionIds[i].toString();
//       }
//     }

//     if (selectedkidsIds != null && selectedkidsIds.isNotEmpty) {
//       for (int i = 0; i < selectedkidsIds.length; i++) {
//         request.fields['kids[$i]'] = selectedkidsIds[i].toString();
//       }
//     }

//     if (drinkingId != null && drinkingId.isNotEmpty) {
//       for (int i = 0; i < drinkingId.length; i++) {
//         request.fields['drinking[$i]'] = drinkingId[i].toString();
//       }
//     }

//     if (defaultmessages != null && defaultmessages.isNotEmpty) {
//       for (int i = 0; i < defaultmessages.length; i++) {
//         request.fields['defaultMessages[$i]'] = defaultmessages[i].toString();
//       }
//     }

//     if (starsign != null && starsign.isNotEmpty) {
//       for (int i = 0; i < starsign.length; i++) {
//         request.fields['starSignId[$i]'] = starsign[i].toString();
//       }
//     }

//     if (relationship != null && relationship.isNotEmpty) {
//       for (int i = 0; i < relationship.length; i++) {
//         request.fields['relationshipId[$i]'] = relationship[i].toString();
//       }
//     }

//     if (experience != null && experience.isNotEmpty) {
//       for (int i = 0; i < experience.length; i++) {
//         request.fields['experienceId[$i]'] = experience[i].toString();
//       }
//     }

//     if (industry != null && industry.isNotEmpty) {
//       for (int i = 0; i < industry.length; i++) {
//         request.fields['industryId[$i]'] = industry[i].toString();
//       }
//     }

//     if (languages != null && languages.isNotEmpty) {
//       for (int i = 0; i < languages.length; i++) {
//         request.fields['languageId[$i]'] = languages[i].toString();
//       }
//     }

//     // Handle image uploads
//     if (choosedimages != null && choosedimages.isNotEmpty) {
//       for (int i = 0; i < choosedimages.length; i++) {
//         final image = choosedimages[i];

//         if (image != null && await image.exists()) {
//           final filePath = image.path;
//           final fileExtension = filePath.split('.').last.toLowerCase();

//           MediaType? contentType;
//           if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
//             contentType = MediaType('image', 'jpeg');
//           } else if (fileExtension == 'png') {
//             contentType = MediaType('image', 'png');
//           } else {
//             print('Unsupported file type: $filePath');
//             continue;
//           }

//           final multipartFile = await http.MultipartFile.fromPath(
//             'profilePic',
//             filePath,
//             contentType: contentType,
//           );

//           request.files.add(multipartFile);
//           print('Added image file: $filePath');
//         }
//       }
//     }

//     // Send the request
//     print('Sending request to: $apiUrl');
//     final response = await request.send();
//     final responseBody = await response.stream.bytesToString();

//     print("API Response Status: ${response.statusCode}");
//     print("API Response Body: $responseBody");

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       await prefs.setBool("isSignedUp", true);
//       print('User created successfully by admin.');
      
//       // Refresh the users list
//       await ref.read(admincreatedusersprovider.notifier).getAdmincreatedusers();
//       return response.statusCode;
//     } else {
//       print("Signup failed with status: ${response.statusCode}");
//       print("Error response: $responseBody");
//       return response.statusCode;
//     }

//   } catch (e, stackTrace) {
//     print("Exception during signup: $e");
//     print("Stack trace: $stackTrace");
//     return 500;
//   } finally {
//     loadingState.state = false;
//     client?.close();
//   }
// }
//   Future<int> updateProfile({
//   String? specificToken,
//   List<int>? modeid,
//   String? modename,
//   List<int>? causeId,
//   String? bio,
//   List<int>? interestId,
//   List<int>? qualityId,
//   List<String>? prompt,
//   List<dynamic>? image,
//   List<int>? languagesId,
//   List<int>? starsignId,
//   int? jobId,
//   int? educationId,
//   List<int>? religionId,
//   List<int>? lookingfor,
//   List<int>? kidsId,
//   List<int>? drinkingId,
//   String? smoking,
//   String? gender,
//   bool? showOnProfile,
//   String? pronoun,
//   String? exercise,
//   List<int>? industryId,
//   List<int>? experienceId,
//   String? haveKids,
//   String? educationLevel,
//   String? newarea,
//   int? height,
//   List<int>? relationshipId,
//   String? name,
//   String? dob,
//   String? hometown,
//   String? politics,
//   double? latitude,
//   double? longitude,
// }) async {
//   final loadingState = ref.read(loadingProvider.notifier);
//   loadingState.state = true;

//   print('Updating profile data - industries: $industryId, experience: $experienceId, hometown: $hometown');
//   print('Causes: $causeId, lookingfor: $lookingfor, mode: $modeid, smoking: $smoking');

//   RetryClient? client;
//   try {
//     final String apiUrl = Dgapi.updateprofile;
//     final prefs = await SharedPreferences.getInstance();

//     // Resolve token (specific token > stored admin token > refresh)
//     String? token = specificToken;
    
//     if (token == null || token.isEmpty) {
//       final userDataString = prefs.getString('userData');
//       if (userDataString == null || userDataString.isEmpty) {
//         throw Exception("Admin token is missing. Please log in again.");
//       }
      
//       final Map<String, dynamic> userData = jsonDecode(userDataString);
//       token = userData['accessToken'] ??
//           (userData['data'] != null &&
//                   (userData['data'] as List).isNotEmpty &&
//                   userData['data'][0]['access_token'] != null
//               ? userData['data'][0]['access_token']
//               : null);
      
//       token ??= prefs.getString('accessToken');
      
//       if (token == null || token.isEmpty) {
//         throw Exception("Token is invalid. Please log in again.");
//       }
//     }
    
//     print('Using token: ${token.substring(0, 20)}...');

//     // Build RetryClient with token refresh on 401/400
//     client = RetryClient(
//       http.Client(),
//       retries: 3,
//       when: (res) => res.statusCode == 401 || res.statusCode == 400,
//       onRetry: (req, res, retryCount) async {
//         if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
//           if (specificToken == null) {
//             print("Token expired, refreshing...");
//             final newAccessToken = await ref.read(fakeusersprovider.notifier).restoreAccessToken();
//             if (newAccessToken != null && newAccessToken.isNotEmpty) {
//               await prefs.setString('accessToken', newAccessToken);
//               token = newAccessToken;
//               req.headers['Authorization'] = 'Bearer $newAccessToken';
//               print("New Token obtained");
//             }
//           } else {
//             req.headers['Authorization'] = 'Bearer $specificToken';
//             print("Using specific token provided by caller on retry");
//           }
//         }
//       },
//     );

//     // Build multipart PUT request
//     final request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
//     request.headers['Authorization'] = 'Bearer $token';
//     request.headers['Accept'] = 'application/json';

//     // Basic string fields
//     if (bio != null) request.fields['headLine'] = bio;
//     if (smoking != null) request.fields['smoking'] = smoking;
//     if (gender != null) request.fields['gender'] = gender;
//     if (pronoun != null) request.fields['pronouns'] = pronoun;
//     if (exercise != null) request.fields['exercise'] = exercise;
//     if (haveKids != null) request.fields['haveKids'] = haveKids;
//     if (educationLevel != null) request.fields['educationLevel'] = educationLevel;
//     if (newarea != null) request.fields['newToArea'] = newarea;
//     if (name != null) request.fields['firstName'] = name;
//     if (dob != null) request.fields['dob'] = dob;
//     if (hometown != null) request.fields['hometown'] = hometown;
//     if (politics != null) request.fields['politics'] = politics;

//     // Boolean fields
//     if (showOnProfile != null) {
//       request.fields['showOnProfile'] = showOnProfile.toString();
//     }

//     // Numeric fields
//     if (height != null) request.fields['height'] = height.toString();
//     if (jobId != null) request.fields['workId'] = jobId.toString();
//     if (educationId != null) request.fields['educationId'] = educationId.toString();

//     // Location fields
//     if (latitude != null) request.fields['latitude'] = latitude.toString();
//     if (longitude != null) request.fields['longitude'] = longitude.toString();

//     // Helper function for indexed list fields
//     void addListField(String key, List<int>? values) {
//       if (values != null && values.isNotEmpty) {
//         for (int i = 0; i < values.length; i++) {
//           request.fields['$key[$i]'] = values[i].toString();
//         }
//       }
//     }

//     // Array fields with proper indexing
//     addListField('modeId', modeid);
//     addListField('causesAndCommunities', causeId);
//     addListField('interests', interestId);
//     addListField('qualities', qualityId);
//     addListField('lookingFor', lookingfor);
//     addListField('kids', kidsId);
//     addListField('drinking', drinkingId);
//     addListField('languageId', languagesId);
//     addListField('starSignId', starsignId);
//     addListField('religions', religionId);
//     addListField('relationshipId', relationshipId);
//     addListField('industryId', industryId);
//     addListField('experienceId', experienceId);

//     // Prompts array
//     if (prompt != null && prompt.isNotEmpty) {
//       for (int i = 0; i < prompt.length; i++) {
//         request.fields['prompts[$i]'] = prompt[i];
//       }
//     }

//     // Handle image uploads
//     if (image != null && image.isNotEmpty) {
//       for (int i = 0; i < image.length; i++) {
//         final imageItem = image[i];
//         String? filePath;
        
//         // Handle different image types (File, String path, etc.)
//         if (imageItem is File) {
//           filePath = imageItem.path;
//         } else if (imageItem is String) {
//           filePath = imageItem;
//         } else {
//           continue;
//         }

//         final file = File(filePath);
//         if (await file.exists()) {
//           final ext = filePath.split('.').last.toLowerCase();
//           MediaType? contentType;
          
//           if (ext == 'jpg' || ext == 'jpeg') {
//             contentType = MediaType('image', 'jpeg');
//           } else if (ext == 'png') {
//             contentType = MediaType('image', 'png');
//           } else {
//             print('Unsupported file type: $filePath');
//             continue;
//           }
          
//           final multipartFile = await http.MultipartFile.fromPath(
//             'profilePic',
//             filePath,
//             contentType: contentType,
//           );
          
//           request.files.add(multipartFile);
//           print('Added image file: ${filePath.split('/').last}');
//         } else {
//           print('File not found: $filePath');
//         }
//       }
//     }

//     // Send request via RetryClient
//     final streamed = await client.send(request);
//     final response = await http.Response.fromStream(streamed);

//     print("API Response Status: ${response.statusCode}");
//     print("API Response Body: ${response.body}");

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print("Profile updated successfully");
      
//       try {
//         final responseData = jsonDecode(response.body);
        
//         // Save updated user data
//         if (responseData != null) {
//           await prefs.setString('userData', response.body);
//           print('Updated user data saved in SharedPreferences.');
//         }

//         // Refresh the admin users list if this was done by admin
//         if (specificToken != null) {
//           await ref.read(admincreatedusersprovider.notifier).getAdmincreatedusers();
//         }
        
//         return response.statusCode;
//       } catch (parseError) {
//         print('Error parsing response: $parseError');
//         // Still consider it successful if the status code is good
//         return response.statusCode;
//       }
      
//     } else {
//       final errorBody = response.body;
//       print("Profile update failed: $errorBody");
//       throw Exception("Profile update failed with status: ${response.statusCode}");
//     }
    
//   } catch (e, stackTrace) {
//     print("Exception during profile update: $e");
//     print("Stack trace: $stackTrace");
//     rethrow;
//   } finally {
//     loadingState.state = false;
//     client?.close();
//   }
// }

//   Future<String> restoreAccessToken() async {
//     final url = Uri.parse(Dgapi.refreshToken);

//     // read from current state (source of truth)
//     final current = ref.read(fakeusersprovider);
//     final currentRefreshToken = current.data?.first.refreshToken;

//     if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
//       throw Exception("No valid refresh token found.");
//     }

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json; charset=UTF-8'},
//         body: jsonEncode({"refresh_token": currentRefreshToken}),
//       );

//       final Map<String, dynamic> body = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         final newAccessToken = body['data']?['access_token'] as String?;
//         final newRefreshToken = body['data']?['refresh_token'] as String?;

//         if (newAccessToken == null || newAccessToken.isEmpty) {
//           throw Exception("Refresh endpoint did not return access_token.");
//         }

//         // write back to AdminCreatedUsersModel + SharedPreferences
//         await ref.read(fakeusersprovider.notifier).updateTokens(
//             accessToken: newAccessToken, refreshToken: newRefreshToken);

//         return newAccessToken;
//       } else {
//         final msg = body['message'] ?? 'Failed to refresh token';
//         throw Exception("$msg (status ${response.statusCode})");
//       }
//     } catch (e) {
//       // bubble up so caller (e.g., RetryClient) can handle
//       rethrow;
//     }
//   }

//   Future<void> updateTokens({
//     required String accessToken,
//     String? refreshToken,
//   }) async {
//     final current = state;

//     // build next `data` list
//     final List<Data> newData;
//     if ((current.data?.isNotEmpty ?? false)) {
//       final first = current.data!.first;
//       newData = [
//         first.copyWith(
//           accessToken: accessToken,
//           refreshToken: (refreshToken != null && refreshToken.isNotEmpty)
//               ? refreshToken
//               : first.refreshToken,
//         ),
//         ...current.data!.skip(1),
//       ];
//     } else {
//       newData = [Data(accessToken: accessToken, refreshToken: refreshToken)];
//     }

//     // update state
//     state = current.copyWith(data: newData);

//     // persist
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userData', jsonEncode(state.toJson()));
//   }
// }

// final fakeusersprovider = StateNotifierProvider<Fakeusersprovider, AdminCreatedUsersModel>((ref) {
//   return Fakeusersprovider(ref);
// });

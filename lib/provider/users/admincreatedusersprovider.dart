import 'dart:convert';

import 'package:admin_dating/models/users/admincreatedusersmodes.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/provider/loginprovider.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:http_parser/http_parser.dart';

class Admincreatedusersprovider extends StateNotifier<AdminCreatedUsersModel> {
  final Ref ref;
  Admincreatedusersprovider(this.ref) : super(AdminCreatedUsersModel.initial());

  Future<void> getAdmincreatedusers() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    try {
      loadingState.state = true;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken; // ✅ Update token for next use
            req.headers['Authorization'] = 'Bearer $newAccessToken';

            print("New Token: $newAccessToken");
          }
        },
      );

      print('get admincreadtedusers');
      final user = ref.read(loginProvider);
      final userinfo =
          user.data?.isNotEmpty == true ? user.data![0].user : null;
      final String apiUrl = Dgapi.admincreatedusers;

      final response = await client.get(
        Uri.parse("$apiUrl"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseBody = response.body;
      print('Get Admincreatedusers Status Code: ${response.statusCode}');
      print('Get Admincreatedusers Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final res = jsonDecode(responseBody);
          final usersData = AdminCreatedUsersModel.fromJson(res);
          state = usersData;
          print('get Admincreatedusers successfully');
        } catch (e) {
          print("Invalid response format: $e");
          throw Exception("Error parsing Admincreatedusers");
        }
      } else {
        print("Error fetching Admincreatedusers${response.body}");
        throw Exception("Error fetching Admincreatedusers: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Admincreatedusers: $e");
    } finally {
      loadingState.state = false;
    }
  }

  Future<int> signupuserApi({
    String? email,
    String? mobile,
    double? latitude,
    double? longitude,
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
    List<int>? relationship,
    List<int>? starsign,
    List<int>? languages,
    String? hometown,
    String? newtotown,
    String? politics,
    String? pronoun,
    String? educationlevel,
    String? havekids,
  }) async {
    const String apiUrl = Dgapi.login1;
    final prefs = await SharedPreferences.getInstance();

    // Fix: Properly extract admin ID from login provider data
    final userData = ref.watch(loginProvider);
    final firstDataItem = userData.data![0].user!.id;
    print("admin id from creted fakeuser:$firstDataItem");
    //  int? adminId;

    // try {
    //   // Based on your API response, the structure is: data[0].id (not data[0].user.id)
    //   if (userData.data != null && userData.data!.isNotEmpty) {
    //

    //     // if (firstDataItem is Map<String, dynamic>) {
    //     //   // Direct access to id from the user object
    //     //   adminId = firstDataItem['id'] as int?;
    //     // }
    //   }
    //   print('Extracted adminId: $adminId');
    // } catch (e) {
    //   print("Warning: Could not get admin ID from userData: $e");
    //   print("UserData structure: ${userData.data}");
    //   adminId = null;
    // }

    RetryClient? client;
    final loadingState = ref.read(loadingProvider.notifier);

    print("✅ Proceeding with API request...");
    print('Sign in data - email: $email, mobile: $mobile, userName: $userName');
    print('Admin ID: $firstDataItem');

    try {
      loadingState.state = true;

      // Get admin token from SharedPreferences
      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> storedUserData = jsonDecode(userDataString);

      // Extract token - check multiple possible locations
      String? token;
      if (storedUserData.containsKey('accessToken')) {
        token = storedUserData['accessToken'];
      } else if (storedUserData.containsKey('access_token')) {
        token = storedUserData['access_token'];
      } else if (storedUserData.containsKey('data') &&
          storedUserData['data'] is List &&
          storedUserData['data'].isNotEmpty) {
        final firstItem = storedUserData['data'][0];
        if (firstItem is Map<String, dynamic>) {
          token = firstItem['access_token'] ?? firstItem['accessToken'];
        }
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            if (newAccessToken != null) {
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken;
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );

      // Build multipart POST request
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Basic required fields
      request.fields['role'] = "user";

      // Only add createdByAdminId if we have a valid adminId
      // if (adminId != null) {

      //   print('Using createdByAdminId: $adminId');
      // } else {
      //   print('Warning: No admin ID available for createdByAdminId field');
      // }

      // Basic user information
      request.fields['createdByAdminId'] = firstDataItem.toString();
      if (email != null) request.fields['email'] = email;
      if (mobile != null) request.fields['mobile'] = mobile;
      if (userName != null) request.fields['firstName'] = userName;
      if (dateOfBirth != null) request.fields['dob'] = dateOfBirth;
      if (selectedGender != null) request.fields['gender'] = selectedGender;
      if (finalheadline != null) request.fields['headLine'] = finalheadline;

      // Location data - ensure non-null values
      request.fields['latitude'] = (latitude ?? 0.0).toString();
      request.fields['longitude'] = (longitude ?? 0.0).toString();

      // Boolean fields
      if (showGenderOnProfile != null) {
        request.fields['showOnProfile'] = showGenderOnProfile.toString();
      }
      if (havekids != null) request.fields['haveKids'] = havekids;
      if (newtotown != null) request.fields['newToArea'] = newtotown;

      // Numeric fields
      if (selectedHeight != null) {
        request.fields['height'] = selectedHeight.toString();
      }

      // String fields
      if (educationlevel != null)
        request.fields['educationLevel'] = educationlevel;
      if (hometown != null) request.fields['hometown'] = hometown;
      if (politics != null) request.fields['politics'] = politics;
      if (pronoun != null) request.fields['pronouns'] = pronoun;

      // Helper function for list fields
      void addListField(String key, List<int>? values) {
        if (values != null && values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            request.fields['$key[$i]'] = values[i].toString();
          }
        }
      }

      // Handle prompts separately
      if (seletedprompts != null && seletedprompts.isNotEmpty) {
        for (int i = 0; i < seletedprompts.length; i++) {
          request.fields['prompts[$i]'] = seletedprompts[i];
        }
      }

      // Apply helper function to all list fields
      addListField('modeId', modeid);
      addListField('genderIdentities', selectedGenderIds);
      addListField('interests', selectedInterestIds);
      addListField('qualities', selectedqualities);
      addListField('lookingFor', selectedLookingfor);
      addListField('causesAndCommunities', selectedcauses);
      addListField('religions', selectedreligionIds);
      addListField('kids', selectedkidsIds);
      addListField('drinking', drinkingId);
      addListField('defaultMessages', defaultmessages);
      addListField('starSignId', starsign);
      addListField('relationshipId', relationship);
      addListField('experienceId', experience);
      addListField('industryId', industry);
      addListField('languageId', languages);

      // Handle image uploads - Fixed to properly handle File objects
      if (choosedimages != null && choosedimages.isNotEmpty) {
        print('Processing ${choosedimages.length} images for upload...');

        for (int i = 0; i < choosedimages.length; i++) {
          final image = choosedimages[i];

          // Check if it's a File object and exists
          if (image is File) {
            if (await image.exists()) {
              final filePath = image.path;
              final fileExtension = filePath.split('.').last.toLowerCase();

              MediaType? contentType;
              if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
                contentType = MediaType('image', 'jpeg');
              } else if (fileExtension == 'png') {
                contentType = MediaType('image', 'png');
              } else {
                print('Unsupported file type: $filePath');
                continue;
              }

              final multipartFile = await http.MultipartFile.fromPath(
                'profilePic',
                filePath,
                contentType: contentType,
              );

              request.files.add(multipartFile);
              print('Added image file: ${filePath.split('/').last}');
            } else {
              print('File does not exist: ${image.path}');
            }
          } else if (image != null) {
            print('Invalid image type at index $i: ${image.runtimeType}');
            print('Image value: $image');
          }
        }

        print('Total files added: ${request.files.length}');
      } else {
        print('No images provided for upload');
      }

      // Send the request
      print('Sending request to: $apiUrl');
      print('Request fields count: ${request.fields.length}');
      print('Request files count: ${request.files.length}');

      final response = await client.send(request);
      final responseBody = await http.Response.fromStream(response);

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${responseBody.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await prefs.setBool("isSignedUp", true);
        print('User created successfully by admin.');

        // Refresh the users list
        try {
          await ref
              .read(admincreatedusersprovider.notifier)
              .getAdmincreatedusers();
        } catch (refreshError) {
          print('Warning: Failed to refresh users list: $refreshError');
        }

        return response.statusCode;
      } else {
        print("Signup failed with status: ${response.statusCode}");
        print("Error response: ${responseBody.body}");
        return response.statusCode;
      }
    } catch (e, stackTrace) {
      print("Exception during signup: $e");
      print("Stack trace: $stackTrace");
      return 500;
    } finally {
      loadingState.state = false;
      client?.close();
    }
  }

  Future<int> updateProfile({
    int? fakeuserId,
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
    String? smoking,
    String? gender,
    bool? showOnProfile,
    String? pronoun,
    String? exercise,
    List<int>? industryId,
    List<int>? experienceId,
    String? haveKids,
    String? educationLevel,
    String? newarea,
    int? height,
    List<int>? relationshipId,
    String? name,
    String? dob,
    String? hometown,
    String? politics,
    double? latitude,
    double? longitude,
    String? accestoken
  }) async {
    final loadingState = ref.read(loadingProvider.notifier);

    loadingState.state = true;

    print(
        'Updating profile data fakeuserid:$fakeuserId- industries: $industryId, experience: $experienceId, hometown: $hometown');
    print(
        'Causes: $causeId, lookingfor: $lookingfor, mode: $modeid, smoking: $smoking');
    print('fakeuserId: $fakeuserId');
    print('specificToken: $specificToken');
    print('modeid: $modeid');
    print('modename: $modename');
    print('causeId: $causeId');
    print('bio: $bio');
    print('interestId: $interestId');
    print('qualityId: $qualityId');
    print('prompt: $prompt');
    print('image: $image');
    print('languagesId: $languagesId');
    print('starsignId: $starsignId');
    print('jobId: $jobId');
    print('educationId: $educationId');
    print('religionId: $religionId');
    print('lookingfor: $lookingfor');
    print('kidsId: $kidsId');
    print('drinkingId: $drinkingId');
    print('smoking: $smoking');
    print('gender: $gender');
    print('showOnProfile: $showOnProfile');
    print('pronoun: $pronoun');
    print('exercise: $exercise');
    print('industryId: $industryId');
    print('experienceId: $experienceId');
    print('haveKids: $haveKids');
    print('educationLevel: $educationLevel');
    print('newarea: $newarea');
    print('height: $height');
    print('relationshipId: $relationshipId');
    RetryClient? client;
    try {
      final String apiUrl = Dgapi.updateprofile;
      final prefs = await SharedPreferences.getInstance();

      // // Resolve token (specific token > stored admin token > refresh)
      // String? token = specificToken;

      // if (token == null || token.isEmpty) {
      //   final userDataString = prefs.getString('userData');
      //   if (userDataString == null || userDataString.isEmpty) {
      //     throw Exception("Admin token is missing. Please log in again.");
      //   }

      //   final Map<String, dynamic> userData = jsonDecode(userDataString);
      //   token = userData['accessToken'] ??
      //       (userData['data'] != null &&
      //               (userData['data'] as List).isNotEmpty &&
      //               userData['data'][0]['access_token'] != null
      //           ? userData['data'][0]['access_token']
      //           : null);

      //   token ??= prefs.getString('accessToken');

      //   if (token == null || token.isEmpty) {
      //     throw Exception("Token is invalid. Please log in again.");
      //   }
      // }

      // print('Using token: ${token.substring(0, 20)}...');

      // // Build RetryClient with token refresh on 401/400
      // client = RetryClient(
      //   http.Client(),
      //   retries: 3,
      //   when: (res) => res.statusCode == 401 || res.statusCode == 400,
      //   onRetry: (req, res, retryCount) async {
      //     if (retryCount == 0 && (res?.statusCode == 401 || res?.statusCode == 400)) {
      //       if (specificToken == null) {
      //         print("Token expired, refreshing...");
      //         final newAccessToken = await ref.read(loginProvider.notifier).restoreAccessToken();
      //         if (newAccessToken != null && newAccessToken.isNotEmpty) {
      //           await prefs.setString('accessToken', newAccessToken);
      //           token = newAccessToken;
      //           req.headers['Authorization'] = 'Bearer $newAccessToken';
      //           print("New Token obtained");
      //         }
      //       } else {
      //         req.headers['Authorization'] = 'Bearer $specificToken';
      //         print("Using specific token provided by caller on retry");
      //       }
      //     }
      //   },
      // );
      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            await prefs.setString('accessToken', newAccessToken);
            token = newAccessToken; // ✅ Update token for next use
            req.headers['Authorization'] = 'Bearer $newAccessToken';

            print("New Token: $newAccessToken");
          }
        },
      );

      // Build multipart PUT request
      final request =
          http.MultipartRequest('PUT', Uri.parse("$apiUrl"));
      request.headers['Authorization'] = 'Bearer $specificToken';
      request.headers['Accept'] = 'application/json';

      // Basic string fields
      if (bio != null) request.fields['headLine'] = bio;
      if (smoking != null) request.fields['smoking'] = smoking;
      if (gender != null) request.fields['gender'] = gender;
      if (pronoun != null) request.fields['pronouns'] = pronoun;
      if (exercise != null) request.fields['exercise'] = exercise;
      if (haveKids != null) request.fields['haveKids'] = haveKids;
      if (educationLevel != null)
        request.fields['educationLevel'] = educationLevel;
      if (newarea != null) request.fields['newToArea'] = newarea;
      if (name != null) request.fields['firstName'] = name;
      if (dob != null) request.fields['dob'] = dob;
      if (hometown != null) request.fields['hometown'] = hometown;
      if (politics != null) request.fields['politics'] = politics;

      // Boolean fields
      if (showOnProfile != null) {
        request.fields['showOnProfile'] = showOnProfile.toString();
      }

      // Numeric fields
      if (height != null) request.fields['height'] = height.toString();
      if (jobId != null) request.fields['workId'] = jobId.toString();
      if (educationId != null)
        request.fields['educationId'] = educationId.toString();

      // Location fields
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // Helper function for indexed list fields
      void addListField(String key, List<int>? values) {
        if (values != null && values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            request.fields['$key[$i]'] = values[i].toString();
          }
        }
      }

      // Array fields with proper indexing
      addListField('modeId', modeid);
      addListField('causesAndCommunities', causeId);
      addListField('interests', interestId);
      addListField('qualities', qualityId);
      addListField('lookingFor', lookingfor);
      addListField('kids', kidsId);
      addListField('drinking', drinkingId);
      addListField('languageId', languagesId);
      addListField('starSignId', starsignId);
      addListField('religions', religionId);
      addListField('relationshipId', relationshipId);
      addListField('industryId', industryId);
      addListField('experienceId', experienceId);

      // Prompts array
      if (prompt != null && prompt.isNotEmpty) {
        for (int i = 0; i < prompt.length; i++) {
          request.fields['prompts[$i]'] = prompt[i];
        }
      }

      // Handle image uploads
      if (image != null && image.isNotEmpty) {
        for (int i = 0; i < image.length; i++) {
          final imageItem = image[i];
          String? filePath;

          // Handle different image types (File, String path, etc.)
          if (imageItem is File) {
            filePath = imageItem.path;
          } else if (imageItem is String) {
            filePath = imageItem;
          } else {
            continue;
          }

          final file = File(filePath);
          if (await file.exists()) {
            final ext = filePath.split('.').last.toLowerCase();
            MediaType? contentType;

            if (ext == 'jpg' || ext == 'jpeg') {
              contentType = MediaType('image', 'jpeg');
            } else if (ext == 'png') {
              contentType = MediaType('image', 'png');
            } else {
              print('Unsupported file type: $filePath');
              continue;
            }

            final multipartFile = await http.MultipartFile.fromPath(
              'profilePic',
              filePath,
              contentType: contentType,
            );

            request.files.add(multipartFile);
            print('Added image file: ${filePath.split('/').last}');
          } else {
            print('File not found: $filePath');
          }
        }
      }

      // Send request via RetryClient
      final streamed = await client.send(request);
      final response = await http.Response.fromStream(streamed);

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Profile updated successfully");

        try {
          final responseData = jsonDecode(response.body);

          // Save updated user data
          if (responseData != null) {
            await prefs.setString('userData', response.body);
            print('Updated user data saved in SharedPreferences.');
          }
          // state = responseData;
          // Refresh the admin users list if this was done by admin
          if (specificToken != null) {
            await ref
                .read(admincreatedusersprovider.notifier)
                .getAdmincreatedusers();
          }

          return response.statusCode;
        } catch (parseError) {
          print('Error parsing response: $parseError');
          // Still consider it successful if the status code is good
          return response.statusCode;
        }
      } else {
        final errorBody = response.body;
        print("Profile update failed: $errorBody");
        throw Exception(
            "Profile update failed with status: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Exception during profile update: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    } finally {
      loadingState.state = false;
      // client?.close();
    }
  }

  Future<int> deletefakeuser({required fakeuserId}) async {
    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    print('userid.fake.......$fakeuserId');

    try {
      loadingState.state = true;

      String? userDataString = prefs.getString('userData');
      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);

      String? token = userData['accessToken'] ??
          (userData['data'] != null &&
                  (userData['data'] as List).isNotEmpty &&
                  userData['data'][0]['access_token'] != null
              ? userData['data'][0]['access_token']
              : null);

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      final client = RetryClient(
        http.Client(),
        retries: 3,
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            print("Token expired, refreshing...");
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();

            if (newAccessToken != null && newAccessToken.isNotEmpty) {
              await prefs.setString('accessToken', newAccessToken);
              token = newAccessToken; // Update token for next use
              req.headers['Authorization'] = 'Bearer $newAccessToken';
              print("New Token: $newAccessToken");
            }
          }
        },
      );

      final String deleteUrl = "${Dgapi.fakeuserdelete}/$fakeuserId";
      print("Delete URL: $deleteUrl");

      // Use the RetryClient with proper authorization
      final response = await client.delete(
        Uri.parse(deleteUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // This was missing!
        },
      );

      print("Delete response status: ${response.statusCode}");
      print("Delete response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Deleted successfully");

        // Remove from local state immediately for better UX
        // Assuming your model has a 'users' or 'data' property that contains the list
        // if (state.data != null) {
        //   final updatedUsers =
        //       state.data!.where((user) => user.id != fakeuserId).toList();
        //   state = state.copyWith(data: updatedUsers);
        // }

        // Then refresh from server
       getAdmincreatedusers();
        return response.statusCode;
      } else {
        throw Exception(
            "Delete failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Delete error: $e");
      throw Exception("Delete error: $e");
    } finally {
      loadingState.state = false;
    }
  }
}

final admincreatedusersprovider =
    StateNotifierProvider<Admincreatedusersprovider, AdminCreatedUsersModel>(
        (ref) {
  return Admincreatedusersprovider(ref);
});

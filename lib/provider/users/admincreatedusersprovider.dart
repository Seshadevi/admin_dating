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

  int _currentPage = 1;
  bool _hasMore = true;
   
   bool _isLoading = false;  
   bool _isLoadingNextPage = false;
   bool get isLoading => _isLoading;
   bool get isLoadingNextPage => _isLoadingNextPage;

  Future<void> getAdmincreatedusers({int page = 1, bool refresh = false}) async {
    
     if (refresh) {
    _currentPage = 1;
    _hasMore = true;
  } else if (_isLoadingNextPage || !_hasMore) {
    return; // do nothing if already loading next page or no more pages
  }

    final loadingState = ref.read(loadingProvider.notifier);
    final prefs = await SharedPreferences.getInstance();
    try {
      if (page == 1) {
      _isLoading = true;
      loadingState.state = true;
    } else {
      _isLoadingNextPage = true;
    }

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

          print('get admincreatedusers, page $page');
      final String apiUrl = "${Dgapi.admincreatedusers}?page=$page";

      final response = await client.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseBody = response.body;
      print('Get Admincreatedusers Status Code: ${response.statusCode}');
      print('Get Admincreatedusers Response Body: $responseBody');

           if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final newUsers = AdminCreatedUsersModel.fromJson(res);

        if (page == 1) {
        state = newUsers; // initial load / refresh
      } else {
        state = state.copyWith(
          data: [...(state.data ?? []), ...(newUsers.data ?? [])], // append page 2+
        );
      }

        _currentPage = page;
        _hasMore = (newUsers.data?.isNotEmpty ?? false);
      } else {
        throw Exception("Error fetching Admincreatedusers: ${response.body}");
      }
    } catch (e) {
      print("Failed to fetch Admincreatedusers: $e");
    } finally {
      _isLoading = false;
       _isLoadingNextPage = false;
       loadingState.state = false;
    }
  }

  Future<void> getNextPage() async {
    await getAdmincreatedusers(page: _currentPage + 1);
  }

  Future<void> refreshUsers() async {
    _currentPage = 1;
    _hasMore = true;
    await getAdmincreatedusers(page: 1, refresh: true);
  }


  Future<int> fakeusercreateApi({
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
  int? starsign,
  List<int>? languages,
  String? work,
  String? selectedsmoke,
  String? selecteddiet,
  String? selectedexercise,
  String? selectedslipping,
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
  // print('Sign in data - email: $email, mobile: $mobile, userName: $userName');
  // print('Admin ID: $firstDataItem');
  // print("profilepics:${choosedimages!.length}, date of birth:$dateOfBirth ,gender:$selectedGender ,height:$selectedHeight,selectedgender:$selectedGenderIds");
  // print("mode:$modeid,interesrts");



  print('email: $email');
  print('mobile: $mobile');
  print('latitude: $latitude');
  print('longitude: $longitude');
  print('userName: $userName');
  print('dateOfBirth: $dateOfBirth');
  print('selectedGender: $selectedGender');
  print('showGenderOnProfile: $showGenderOnProfile');
  print('modeid: $modeid');
  print('drinkingId: $drinkingId');
  print('selectedkidsIds: $selectedkidsIds');
  print('selectedreligionIds: $selectedreligionIds');
  print('selectedGenderIds: $selectedGenderIds');
  print('selectedInterestIds: $selectedInterestIds');
  print('selectedcauses: $selectedcauses');
  print('selectedLookingfor: $selectedLookingfor');
  print('selectedqualities: $selectedqualities');
  print('seletedprompts: $seletedprompts');
  print('choosedimages: $choosedimages');
  print('defaultmessages: $defaultmessages');
  print('finalheadline: $finalheadline');
  print('termsAndCondition: $termsAndCondition');
  print('selectedHeight: $selectedHeight');
  print('experience: $experience');
  print('industry: $industry');
  print('relationship: $relationship');
  print('starsign: $starsign');
  print('languages: $languages');
  print('hometown: $hometown');
  print('newtotown: $newtotown');
  print('politics: $politics');
  print('pronoun: $pronoun');
  print('educationlevel: $educationlevel');
  print('havekids: $havekids');


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
    if (educationlevel != null) request.fields['educationLevel'] = educationlevel;
    if (hometown != null) request.fields['hometown'] = hometown;
    if (politics != null) request.fields['politics'] = politics;
    if (pronoun != null) request.fields['pronouns'] = pronoun;
    if (work != null) request.fields['works']=work;
    if (selectedsmoke != null) request.fields['smoking']=selectedsmoke;
    if (selecteddiet != null) request.fields['dietaryPreference']=selecteddiet;
    if (selectedexercise != null) request.fields['exercise']=selectedexercise;
    if (selectedslipping != null) request.fields['sleepingHabits']=selectedslipping;
    if (starsign != null) request.fields['starsignId'] = starsign.toString();
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
    //addListField('starSignId', starsign);
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
        await ref.read(admincreatedusersprovider.notifier).getAdmincreatedusers();
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
  String? email,
  String? mobile,
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
  int?choosegender,
  bool? showOnProfile,
  String? pronoun,
  String? exercise,
  List<int>? industryId,
  List<int>? defaultMessages,
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
}) async {
  final loadingState = ref.read(loadingProvider.notifier);
  final accestoken = ref.read(loginProvider).data![0].accessToken;
  loadingState.state = true;

  print(
      'Updating profile data fakeuserid:$fakeuserId- industries: $industryId, experience: $experienceId, hometown: $hometown');
  print(
      'Causes: $causeId, lookingfor: $lookingfor, mode: $modeid, smoking: $smoking');

  print('in api ------fakeuserId: $fakeuserId');
  print('specificToken: $specificToken');
  print("firstName:$name");
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
  print("choosegender: $choosegender");
  print('showOnProfile: $showOnProfile');
  print('pronoun: $pronoun');
  print('exercise: $exercise');
  print('industryId: $industryId');
  print('dateofbirth:$dob');
  print('experienceId: $experienceId');
  print('haveKids: $haveKids');
  print('educationLevel: $educationLevel');
  print('newarea: $newarea');
  print('height: $height');
  print('in--------api relationshipId: $relationshipId');

  RetryClient? client;
  try {
    final String apiUrl = Dgapi.updateprofile;
    final prefs = await SharedPreferences.getInstance();

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

    if (accestoken == null || accestoken.isEmpty) {
      throw Exception("User token is invalid. Please log in again.");
    }

    print('Retrieved Token: $token');

    final client = RetryClient(
      http.Client(),
      retries: 3,
      when: (response) =>
          response.statusCode == 401 || response.statusCode == 400,
      onRetry: (req, res, retryCount) async {
        try {
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
        } catch (e) {
          print("Error during token refresh: $e");
        }
      },
    );

    // Build multipart PUT request
    http.MultipartRequest request;
    try {
      request =
          http.MultipartRequest('PUT', Uri.parse("$apiUrl/$fakeuserId"));
      request.headers['Authorization'] = 'Bearer $accestoken';
      request.headers['Accept'] = 'application/json';
    } catch (e) {
      print("Error while creating MultipartRequest: $e");
      rethrow;
    }

    // Basic string fields
    try {
      if (bio != null) request.fields['headLine'] = bio;
      if (smoking != null) request.fields['smoking'] = smoking;
      if (gender != null) request.fields['gender'] = gender;
      if (pronoun != null) request.fields['pronouns'] = pronoun;
      if (exercise != null) request.fields['exercise'] = exercise;
      if (haveKids != null) request.fields['haveKids'] = haveKids;
      if (educationLevel != null) {
        request.fields['educationLevel'] = educationLevel;
      }
      if (newarea != null) request.fields['newToArea'] = newarea;
      if (name != null) request.fields['firstName'] = name;
      if (dob != null) request.fields['dob'] = dob;
      if (hometown != null) request.fields['hometown'] = hometown;
      if (politics != null) request.fields['politics'] = politics;
      if (choosegender != null) request.fields['genderIdentities'] = choosegender.toString();
      if (email != null) request.fields['email'] = email;
      if (mobile != null) request.fields['mobile']= mobile;
    } catch (e) {
      print("Error while adding basic fields: $e");
    }

    // Boolean fields
    if (showOnProfile != null) {
      try {
        request.fields['showOnProfile'] = showOnProfile.toString();
      } catch (e) {
        print("Error while setting showOnProfile: $e");
      }
    }

    // Numeric fields
    try {
      if (height != null) request.fields['height'] = height.toString();
      if (jobId != null) request.fields['workId'] = jobId.toString();
      if (educationId != null) {
        request.fields['educationId'] = educationId.toString();
      }
    } catch (e) {
      print("Error while setting numeric fields: $e");
    }

    // Location fields
    try {
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();
    } catch (e) {
      print("Error while setting location fields: $e");
    }

    // Helper function for indexed list fields
    void addListField(String key, List<int>? values) {
      try {
        if (values != null && values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            request.fields['$key[$i]'] = values[i].toString();
          }
        }
      } catch (e) {
        print("Error while adding list field $key: $e");
      }
    }

    // Array fields
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
    addListField('defaultMessages',defaultMessages);

    // Prompts array
    try {
      if (prompt != null && prompt.isNotEmpty) {
        for (int i = 0; i < prompt.length; i++) {
          request.fields['prompts[$i]'] = prompt[i];
        }
      }
    } catch (e) {
      print("Error while adding prompts: $e");
    }

    // Handle image uploads
    try {
      if (image != null && image.isNotEmpty) {
        for (int i = 0; i < image.length; i++) {
          final imageItem = image[i];
          String? filePath;

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
    } catch (e) {
      print("Error while processing images: $e");
    }

    // Send request via RetryClient
    try {
      final streamed = await client.send(request);
      final response = await http.Response.fromStream(streamed);

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Profile updated successfully");

        try {
          final responseData = jsonDecode(response.body);
          if (specificToken != null) {
            await ref
                .read(admincreatedusersprovider.notifier)
                .getAdmincreatedusers();
          }
          return response.statusCode;
        } catch (parseError) {
          print('Error parsing response: $parseError');
          return response.statusCode;
        }
      } else {
        final errorBody = response.body;
        print("Profile update failed: $errorBody");
        throw Exception(
            "Profile update failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during API request: $e");
      rethrow;
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

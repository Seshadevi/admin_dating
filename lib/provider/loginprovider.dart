import 'dart:convert';
import 'dart:io';
import 'package:admin_dating/models/loginmodel.dart';
import 'package:admin_dating/provider/loader.dart';
import 'package:admin_dating/utils/dgapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_dating/provider/users/admincreatedusersprovider.dart';
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
        body: json.encode({"emailOrUsername": email, "password": password}),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginModel = UserModel.fromJson(decoded);

        await prefs.setString('userData', json.encode(loginModel.toJson()));
        
            // Save just the access token separately
          final accessToken = loginModel.data?[0].accessToken ?? '';
          await prefs.setString('access_token', accessToken);

        state = loginModel;

        return loginModel;
      } else {
        return UserModel(
          success: false,
          messages: [decoded['message'] ?? 'Login failed.'],
        );
      }
    } catch (e, stack) {
    print("Login exception: $e");
    print("Stack trace: $stack");
    return UserModel(success: false, messages: ["$e"]);
  }
  }

  // Future<int> signupuserApi({
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
  //   final int? userId = state.data?.first.user?.id;

  //   print("✅ Proceeding with API request...");
  //   print(
  //       'sign in data.........userId:$userId:$email,mobile:$mobile,latitude:$latitude,longitude:$longitude,Name:$userName,dob:$dateOfBirth,selectedgender:$selectedGender:');
  //   print(
  //       'data:::lookinfor:$selectedLookingfor,qualities::$selectedqualities,interests:$selectedInterestIds,kids:$selectedkidsIds,defaltmessages:$defaultmessages,drinking:$drinkingId,religion:$selectedreligionIds,');
  //   print(
  //       'data.......show:$showGenderOnProfile,height:$selectedHeight,headline:$finalheadline,images:${choosedimages!.length},mode:$modeid');
  //   print("havekids:$havekids,pronounces:$pronoun");
  //   print("");

  //   // try {
  //     // var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //     RetryClient? client;
  //   try {
      
      

  //     // ---- Resolve token (specific token > stored token > refresh) ----
  //     String? token = specificToken;
  //     if (token == null || token.isEmpty) {
  //       final userDataString = prefs.getString('userData');
  //       if (userDataString == null || userDataString.isEmpty) {
  //         throw Exception("User token is missing. Please log in again.");
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
  //         throw Exception("User token is invalid. Please log in again.");
  //       }
  //     }
  //     print('Using token: $token');

  //     // ---- Build RetryClient with token refresh on 401/400 ----
  //     client = RetryClient(
  //       http.Client(),
  //       retries: 3,
  //       when: (res) => res.statusCode == 401 || res.statusCode == 400,
  //       onRetry: (req, res, retryCount) async {
  //         // Only refresh if not using caller-provided specificToken
  //         if (retryCount == 0 &&
  //             (res?.statusCode == 401 || res?.statusCode == 400)) {
  //           if (specificToken == null) {
  //             print("Token expired, refreshing...");
  //             final newAccessToken =
  //                 await ref.read(loginProvider.notifier).restoreAccessToken();
  //             if (newAccessToken != null && newAccessToken.isNotEmpty) {
  //               await prefs.setString('accessToken', newAccessToken);
  //               token = newAccessToken;
  //               req.headers['Authorization'] = 'Bearer $newAccessToken';
  //               print("New Token: $newAccessToken");
  //             }
  //           } else {
  //             // Keep using the provided token (cannot refresh it here)
  //             req.headers['Authorization'] = 'Bearer $specificToken';
  //             print("Using specific token provided by caller on retry");
  //           }
  //         }
  //       },
  //     );

  //     // ---- Build multipart PUT request ----
  //     final request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
  //     request.headers['Authorization'] = 'Bearer $token';
  //     request.headers['Accept'] = 'application/json';






  //     // Basic fields
  //     if (email != null) {
  //       request.fields['email'] = email;
  //     }
  //     if(selectedGender != null){
  //       request.fields['gender']= selectedGender;
  //     }

  //     if (userName != null) {
  //       request.fields['firstName'] = userName;
  //     }

  //     // dob
  //     if (dateOfBirth != null) {
  //       request.fields['dob'] = dateOfBirth;
  //     }

  //     request.fields['role'] =
  //         "user"; // remove this line if you truly want conditional only

  //     // showOnProfile (bool)
  //     if (showGenderOnProfile != null) {
  //       request.fields['showOnProfile'] = showGenderOnProfile.toString();
  //     }

  //     // height (num)
  //     if (selectedHeight != null) {
  //       request.fields['height'] = selectedHeight.toString();
  //     }

  //     // headLine
  //     if (finalheadline != null) {
  //       request.fields['headLine'] = finalheadline;
  //     }

  //     // mobile
  //     if (mobile != null) {
  //       request.fields['mobile'] = mobile;
  //     }

  //     // createdByAdminId (int)
  //     if (userId != null) {
  //       request.fields['createdByAdminId'] = userId.toString();
  //     }

  //     // prompts (list)
  //     if (seletedprompts != null && seletedprompts.isNotEmpty) {
  //       request.fields['prompts'] = seletedprompts.join(',');
  //     }

  //     // educationLevel
  //     if (educationlevel != null) {
  //       request.fields['educationLevel'] = educationlevel;
  //     }

  //     // newToArea (bool)
  //     if (newtotown != null) {
  //       request.fields['newToArea'] = newtotown.toString();
  //     }

  //     // hometown
  //     if (hometown != null) {
  //       request.fields['hometown'] = hometown;
  //     }

  //     // haveKids (bool)
  //     if (havekids != null) {
  //       request.fields['haveKids'] = havekids.toString();
  //     }

  //     // politics
  //     if (politics != null) {
  //       request.fields['politics'] = politics;
  //     }

  //     // pronouns
  //     if (pronoun != null) {
  //       request.fields['pronouns'] = pronoun;
  //     }
  //     request.fields['latitude'] = latitude.toString();
  //     request.fields['longitude'] = longitude.toString();


  //     // // Safe list fields (skip empty ones)
  //     if (selectedGenderIds != null) {
  //       for (int i = 0; i < selectedGenderIds.length; i++) {
  //         request.fields['genderIdentities[$i]'] =
  //             selectedGenderIds[i].toString(); // ✅
  //       }
  //     }

  //     if (selectedInterestIds != null) {
  //       for (int i = 0; i < selectedInterestIds.length; i++) {
  //         request.fields['interests[$i]'] = selectedInterestIds[i].toString();
  //       }
  //     }
  //     if (starsign != null) {
  //       for (int i = 0; i < starsign.length; i++) {
  //         request.fields['starSignId[$i]'] = starsign[i].toString();
  //       }
  //     }
  //     if (relationship != null) {
  //       for (int i = 0; i < relationship.length; i++) {
  //         request.fields['relationshipId[$i]'] = relationship[i].toString();
  //       }
  //     }
  //     if (experience != null) {
  //       for (int i = 0; i < experience.length; i++) {
  //         request.fields['experienceId[$i]'] = experience[i].toString();
  //       }
  //     }
  //     if (modeid != null) {
  //       for (int i = 0; i < modeid.length; i++) {
  //         request.fields['modeId[$i]'] = modeid[i].toString();
  //       }
  //     }
  //     if (industry != null) {
  //       for (int i = 0; i < industry.length; i++) {
  //         request.fields['industryId[$i]'] = industry[i].toString();
  //       }
  //     }
  //     if (languages != null) {
  //       for (int i = 0; i < languages.length; i++) {
  //         request.fields['languageId[$i]'] = languages[i].toString();
  //       }
  //     }

  //     if (selectedqualities != null) {
  //       for (int i = 0; i < selectedqualities.length; i++) {
  //         request.fields['qualities[$i]'] = selectedqualities[i].toString();
  //       }
  //     }
  //     if (selectedkidsIds != null) {
  //       for (int i = 0; i < selectedkidsIds.length; i++) {
  //         request.fields['kids[$i]'] = selectedkidsIds![i].toString();
  //       }
  //     }
  //     if (drinkingId != null) {
  //       for (int i = 0; i < drinkingId.length; i++) {
  //         request.fields['drinking[$i]'] = drinkingId[i].toString();
  //       }
  //     }

  //     if (selectedLookingfor != null) {
  //       for (int i = 0; i < selectedLookingfor.length; i++) {
  //         request.fields['lookingFor[$i]'] = selectedLookingfor![i].toString();
  //       }
  //     }

  //     if (selectedreligionIds != null) {
  //       for (int i = 0; i < selectedreligionIds.length; i++) {
  //         request.fields['religions[$i]'] = selectedreligionIds[i].toString();
  //       }
  //     }

  //     if (selectedcauses != null) {
  //       for (int i = 0; i < selectedcauses.length; i++) {
  //         request.fields['causesAndCommunities[$i]'] =
  //             selectedcauses[i].toString();
  //       }
  //     }

  //     // if (seletedprompts!=null) {
  //     //   // Prompts (Map<int, String>)
  //     //   seletedprompts.forEach((key, value) {
  //     //     request.fields['prompts[$key]'] = value;
  //     //   } );
  //     // }

  //     if (defaultmessages != null) {
  //       for (int i = 0; i < defaultmessages.length; i++) {
  //         request.fields['defaultMessages[$i]'] = defaultmessages[i].toString();
  //       }
  //     }

  //     // Upload images (only jpg/png/jpeg)
  //     for (int i = 0; i < choosedimages!.length; i++) {
  //       final image = choosedimages[i];

  //       if (image != null && await image.exists()) {
  //         final filePath = image.path;
  //         final fileExtension = filePath.split('.').last.toLowerCase();

  //         MediaType? contentType;
  //         if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
  //           contentType = MediaType('image', 'jpeg');
  //         } else if (fileExtension == 'png') {
  //           contentType = MediaType('image', 'png');
  //         } else {
  //           print('❌ Unsupported file type: $filePath');
  //           continue;
  //         }

  //         final multipartFile = await http.MultipartFile.fromPath(
  //           'profilePic',
  //           filePath,
  //           contentType: contentType,
  //         );

  //         request.files.add(multipartFile);
  //       }
  //     }
     
  //     // Send the request
  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();

  //     print("🔄 API Response: $responseBody");

  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       await prefs.setBool("isSignedUp", true);

  //       print('User added succesfully.');
  //       await ref.read(admincreatedusersprovider.notifier).getAdmincreatedusers();
  //       return response.statusCode;

  //     } else {
  //       print("❌ Signup failed with status: ${response.statusCode}");
  //       return response.statusCode;
  //     }
  //   } catch (e) {
  //     print("❗ Exception during signup: $e");
  //     return 500;
  //   }
  // }

  // Future<int> updateProfile({
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
  //   double? logitude,
  // }) async {
  //   final loadingState = ref.read(loadingProvider.notifier);
  //   loadingState.state = true;

  //   print(
  //       'updated data...industires:$industryId,expereince:$experienceId,.home:$hometown,causes:$causeId,lookingfor:$lookingfor,mode:$modeid,smoking:$smoking, modename:$modename,, intrestId:$interestId, qualityId:$qualityId, bio:$bio, prompt:$prompt, image:${image?.length},languages:$languagesId,work:$jobId,education:$educationId,starsign:$starsignId');

  //   RetryClient? client;
  //   try {
  //     final String apiUrl = Dgapi.updateprofile;
  //     final prefs = await SharedPreferences.getInstance();

  //     // ---- Resolve token (specific token > stored token > refresh) ----
  //     String? token = specificToken;
  //     if (token == null || token.isEmpty) {
  //       final userDataString = prefs.getString('userData');
  //       if (userDataString == null || userDataString.isEmpty) {
  //         throw Exception("User token is missing. Please log in again.");
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
  //         throw Exception("User token is invalid. Please log in again.");
  //       }
  //     }
  //     print('Using token: $token');

  //     // ---- Build RetryClient with token refresh on 401/400 ----
  //     client = RetryClient(
  //       http.Client(),
  //       retries: 3,
  //       when: (res) => res.statusCode == 401 || res.statusCode == 400,
  //       onRetry: (req, res, retryCount) async {
  //         // Only refresh if not using caller-provided specificToken
  //         if (retryCount == 0 &&
  //             (res?.statusCode == 401 || res?.statusCode == 400)) {
  //           if (specificToken == null) {
  //             print("Token expired, refreshing...");
  //             final newAccessToken =
  //                 await ref.read(loginProvider.notifier).restoreAccessToken();
  //             if (newAccessToken != null && newAccessToken.isNotEmpty) {
  //               await prefs.setString('accessToken', newAccessToken);
  //               token = newAccessToken;
  //               req.headers['Authorization'] = 'Bearer $newAccessToken';
  //               print("New Token: $newAccessToken");
  //             }
  //           } else {
  //             // Keep using the provided token (cannot refresh it here)
  //             req.headers['Authorization'] = 'Bearer $specificToken';
  //             print("Using specific token provided by caller on retry");
  //           }
  //         }
  //       },
  //     );

  //     // ---- Build multipart PUT request ----
  //     final request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
  //     request.headers['Authorization'] = 'Bearer $token';
  //     request.headers['Accept'] = 'application/json';

  //     // Simple fields
  //     if (modeid != null) request.fields['modeId'] = modeid.toString();
  //     if (modename != null) request.fields['modename'] = modename;
  //     if (bio != null) request.fields['headLine'] = bio;
  //     if (religionId != null)
  //       request.fields['religionId'] = religionId.toString();
  //     if (experienceId != null)
  //       request.fields['experiences'] = experienceId.toString();
  //     if (industryId != null)
  //       request.fields['industries'] = industryId.toString();
  //     if (jobId != null) request.fields['workId'] = jobId.toString();
  //     if (educationId != null)
  //       request.fields['educationId'] = educationId.toString();
  //     if (starsignId != null)
  //       request.fields['starSignId'] = starsignId.toString();
  //     if (smoking != null) request.fields['smoking'] = smoking;
  //     if (gender != null) request.fields['gender'] = gender;
  //     if (showOnProfile != null)
  //       request.fields['showOnProfile'] = showOnProfile.toString();
  //     if (pronoun != null) request.fields['pronouns'] = pronoun;
  //     if (exercise != null) request.fields['exercise'] = exercise;
  //     if (haveKids != null) request.fields['haveKids'] = haveKids;
  //     if (educationLevel != null)
  //       request.fields['educationLevel'] = educationLevel;
  //     if (newarea != null) request.fields['newToArea'] = newarea;
  //     if (height != null) request.fields['height'] = height.toString();
  //     if (relationshipId != null)
  //       request.fields['relationshipId'] =
  //           relationshipId.toString(); // ⚠️ removed leading space bug
  //     if (industryId != null)
  //       request.fields['industryId'] = industryId.toString();
  //     if (experienceId != null)
  //       request.fields['experienceId'] = experienceId.toString();
  //     if (name != null) request.fields['name'] = name;
  //     if (dob != null) request.fields['dob'] = dob;
  //     if (hometown != null) request.fields['hometown'] = hometown;
  //     if (politics != null) request.fields['politics'] = politics;
  //     request.fields['latitude'] = latitude.toString();
  //     request.fields['longitude'] = logitude.toString();

  //     // Indexed list fields
  //     void addListField(String key, List<int>? values) {
  //       if (values != null && values.isNotEmpty) {
  //         for (int i = 0; i < values.length; i++) {
  //           request.fields['$key[$i]'] = values[i].toString();
  //         }
  //       }
  //     }

  //     addListField('causesAndCommunities', causeId);
  //     addListField('interests', interestId);
  //     addListField('qualities', qualityId);
  //     addListField('lookingFor', lookingfor);
  //     addListField('kids', kidsId);
  //     addListField('drinking', drinkingId);
  //     addListField('languageId', languagesId);

  //     // Prompts (as array items)
  //     if (prompt != null && prompt.isNotEmpty) {
  //       for (int i = 0; i < prompt.length; i++) {
  //         request.fields['prompts[$i]'] = prompt[i];
  //       }
  //     }

  //     // Images
  //     if (image != null && image.isNotEmpty) {
  //       for (int i = 0; i < image.length; i++) {
  //         final filePath = image[i]; // String path
  //         final file = File(filePath);
  //         if (await file.exists()) {
  //           final ext = filePath.split('.').last.toLowerCase();
  //           MediaType? contentType;
  //           if (ext == 'jpg' || ext == 'jpeg') {
  //             contentType = MediaType('image', 'jpeg');
  //           } else if (ext == 'png') {
  //             contentType = MediaType('image', 'png');
  //           } else {
  //             print('❌ Unsupported file type: $filePath');
  //             continue;
  //           }
  //           final multipartFile = await http.MultipartFile.fromPath(
  //             'profilePic', // confirm with backend
  //             filePath,
  //             contentType: contentType,
  //           );
  //           request.files.add(multipartFile);
  //         } else {
  //           print('⚠️ File not found: $filePath');
  //         }
  //       }
  //     }

  //     // ---- Send via RetryClient (IMPORTANT) ----
  //     final streamed = await client.send(request);
  //     final response = await http.Response.fromStream(streamed);

  //     print("📨 API Responsebody: ${response.body}");
  //     print("Status code: ${response.statusCode}");

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print("✅ Updated data parsed successfully");
  //       final userDetails = jsonDecode(response.body);

  //       try {
  //         final userModel = UserModel.fromJson(userDetails);
  //         state = userModel;

  //         final userData = json.encode(userDetails);
  //         await prefs.setString('userData', userData);
  //         print('User data saved in SharedPreferences.');
  //       } catch (_) {
  //         if (userDetails['data'] != null && userDetails['data'] is List) {
  //           await prefs.setString('userData', response.body);
  //         } else {
  //           throw Exception("Failed to parse updated profile data");
  //         }
  //       }

  //       return response.statusCode;
  //     } else {
  //       throw Exception(
  //           "Profile update failed with status: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❗ Exception during profile update: $e");
  //     throw Exception("Update failed: $e");
  //   } finally {
  //     loadingState.state = false;
  //     // await client?.close(); // 🔒 important
  //   }
  // }

  Future<String> restoreAccessToken() async {
    final url = Uri.parse(Dgapi.refreshToken);

    // read from current state (source of truth)
    final current = ref.read(loginProvider);
    final currentRefreshToken = current.data?.first.refreshToken;

    if (currentRefreshToken == null || currentRefreshToken.isEmpty) {
      throw Exception("No valid refresh token found.");
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({"refresh_token": currentRefreshToken}),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final newAccessToken = body['data']?['access_token'] as String?;
        final newRefreshToken = body['data']?['refresh_token'] as String?;

        if (newAccessToken == null || newAccessToken.isEmpty) {
          throw Exception("Refresh endpoint did not return access_token.");
        }

        // write back to UserModel + SharedPreferences
        await ref.read(loginProvider.notifier).updateTokens(
            accessToken: newAccessToken, refreshToken: newRefreshToken);

        return newAccessToken;
      } else {
        final msg = body['message'] ?? 'Failed to refresh token';
        throw Exception("$msg (status ${response.statusCode})");
      }
    } catch (e) {
      // bubble up so caller (e.g., RetryClient) can handle
      rethrow;
    }
  }

  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final current = state;

    // build next `data` list
    final List<Data> newData;
    if ((current.data?.isNotEmpty ?? false)) {
      final first = current.data!.first;
      newData = [
        first.copyWith(
          accessToken: accessToken,
          refreshToken: (refreshToken != null && refreshToken.isNotEmpty)
              ? refreshToken
              : first.refreshToken,
        ),
        ...current.data!.skip(1),
      ];
    } else {
      newData = [Data(accessToken: accessToken, refreshToken: refreshToken)];
    }

    // update state
    state = current.copyWith(data: newData);

    // persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(state.toJson()));
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, UserModel>((ref) {
  return LoginNotifier(ref);
});

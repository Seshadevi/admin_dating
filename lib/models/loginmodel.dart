class UserModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  UserModel({this.statusCode, this.success, this.messages, this.data});

  factory UserModel.initial() => UserModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );

  UserModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return UserModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = List<String>.from(json['messages']);
    data = json['data'] != null
        ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
        : null;
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.map((v) => v.toJson()).toList(),
      };
}
class Data {
  String? accessToken;
  String? refreshToken;
  User? user;

  Data({this.accessToken, this.refreshToken, this.user});

  factory Data.initial() => Data(
        accessToken: '',
        refreshToken: '',
        user: User.initial(),
      );

  Data copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) {
    return Data(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'user': user?.toJson(),
      };
}
class User {
  int? id;
  dynamic mobile;
  String? role;
  String? email;
  dynamic firstName;
  dynamic lastName;
  dynamic gender;
  dynamic dob;
  List<dynamic>? genderIdentities;
  dynamic showOnProfile;
  dynamic headLine;
  List<dynamic>? profilePics;
  bool? termsAndConditions;
  dynamic mode;
  List<dynamic>? qualities;
  List<dynamic>? drinking;
  List<dynamic>? kids;
  List<dynamic>? religions;
  List<dynamic>? interests;
  List<dynamic>? lookingFor;
  List<dynamic>? causesAndCommunities;
  List<dynamic>? prompts;
  List<dynamic>? defaultMessages;
  Location? location;

  User({
    this.id,
    this.mobile,
    this.role,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.dob,
    this.genderIdentities,
    this.showOnProfile,
    this.headLine,
    this.profilePics,
    this.termsAndConditions,
    this.mode,
    this.qualities,
    this.drinking,
    this.kids,
    this.religions,
    this.interests,
    this.lookingFor,
    this.causesAndCommunities,
    this.prompts,
    this.defaultMessages,
    this.location,
  });

  factory User.initial() => User(
        id: 0,
        mobile: null,
        role: '',
        email: '',
        termsAndConditions: false,
        location: Location.initial(),
      );

  User copyWith({
    int? id,
    dynamic mobile,
    String? role,
    String? email,
    dynamic firstName,
    dynamic lastName,
    dynamic gender,
    dynamic dob,
    List<dynamic>? genderIdentities,
    dynamic showOnProfile,
    dynamic headLine,
    List<dynamic>? profilePics,
    bool? termsAndConditions,
    dynamic mode,
    List<dynamic>? qualities,
    List<dynamic>? drinking,
    List<dynamic>? kids,
    List<dynamic>? religions,
    List<dynamic>? interests,
    List<dynamic>? lookingFor,
    List<dynamic>? causesAndCommunities,
    List<dynamic>? prompts,
    List<dynamic>? defaultMessages,
    Location? location,
  }) {
    return User(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      genderIdentities: genderIdentities ?? this.genderIdentities,
      showOnProfile: showOnProfile ?? this.showOnProfile,
      headLine: headLine ?? this.headLine,
      profilePics: profilePics ?? this.profilePics,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      mode: mode ?? this.mode,
      qualities: qualities ?? this.qualities,
      drinking: drinking ?? this.drinking,
      kids: kids ?? this.kids,
      religions: religions ?? this.religions,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
      prompts: prompts ?? this.prompts,
      defaultMessages: defaultMessages ?? this.defaultMessages,
      location: location ?? this.location,
    );
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dob = json['dob'];
    genderIdentities = json['genderIdentities'];
    showOnProfile = json['showOnProfile'];
    headLine = json['headLine'];
    profilePics = json['profile_pics'];
    termsAndConditions = json['termsAndConditions'];
    mode = json['mode'];
    qualities = json['qualities'];
    drinking = json['drinking'];
    kids = json['kids'];
    religions = json['religions'];
    interests = json['interests'];
    lookingFor = json['lookingFor'];
    causesAndCommunities = json['causesAndCommunities'];
    prompts = json['prompts'];
    defaultMessages = json['defaultMessages'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mobile': mobile,
        'role': role,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'dob': dob,
        'genderIdentities': genderIdentities,
        'showOnProfile': showOnProfile,
        'headLine': headLine,
        'profile_pics': profilePics,
        'termsAndConditions': termsAndConditions,
        'mode': mode,
        'qualities': qualities,
        'drinking': drinking,
        'kids': kids,
        'religions': religions,
        'interests': interests,
        'lookingFor': lookingFor,
        'causesAndCommunities': causesAndCommunities,
        'prompts': prompts,
        'defaultMessages': defaultMessages,
        'location': location?.toJson(),
      };
}
class Location {
  dynamic latitude;
  dynamic longitude;

  Location({this.latitude, this.longitude});

  factory Location.initial() => Location(
        latitude: null,
        longitude: null,
      );

  Location copyWith({dynamic latitude, dynamic longitude}) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}

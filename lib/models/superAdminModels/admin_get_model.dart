class AdminGetModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  AdminGetModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  /// Initial empty state
  factory AdminGetModel.initial() => AdminGetModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );

  /// CopyWith
  AdminGetModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return AdminGetModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  /// From JSON
  factory AdminGetModel.fromJson(Map<String, dynamic> json) {
    return AdminGetModel(
      statusCode: json['statusCode'],
      success: json['success'],
      messages: (json['messages'] as List?)?.map((e) => e.toString()).toList(),
      data: (json['data'] as List?)?.map((e) => Data.fromJson(e)).toList(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'messages': messages,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class Data {
  int? id;
  String? mobile;
  String? role;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? pronouns;
  String? dob;
  bool? showOnProfile;

  List<dynamic>? qualities;
  List<dynamic>? drinking;
  List<dynamic>? kids;
  List<dynamic>? religions;
  List<dynamic>? interests;
  List<dynamic>? lookingFor;
  List<dynamic>? causesAndCommunities;
  List<dynamic>? prompts;
  List<dynamic>? defaultMessages;
  List<dynamic>? profilePics;

  String? starSign;
  String? education;
  String? work;
  Location? location;
  String? educationLevel;
  String? exercise;
  String? haveKids;
  List<dynamic>? genderIdentities;
  String? smoking;
  String? politics;
  String? hometown;
  String? height;
  List<dynamic>? spokenLanguages;
  String? createdByAdminId;
  List<dynamic>? modes;
  List<dynamic>? relationships;
  List<dynamic>? industries;
  String? newToArea;
  List<dynamic>? experiences;

  String? accessToken;
  String? refreshToken;

  Data({
    this.id,
    this.mobile,
    this.role,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.pronouns,
    this.dob,
    this.showOnProfile,
    this.qualities,
    this.drinking,
    this.kids,
    this.religions,
    this.interests,
    this.lookingFor,
    this.causesAndCommunities,
    this.prompts,
    this.defaultMessages,
    this.profilePics,
    this.starSign,
    this.education,
    this.work,
    this.location,
    this.educationLevel,
    this.exercise,
    this.haveKids,
    this.genderIdentities,
    this.smoking,
    this.politics,
    this.hometown,
    this.height,
    this.spokenLanguages,
    this.createdByAdminId,
    this.modes,
    this.relationships,
    this.industries,
    this.newToArea,
    this.experiences,
    this.accessToken,
    this.refreshToken,
  });

  /// Initial empty state
  factory Data.initial() => Data(
        id: 0,
        mobile: '',
        role: '',
        email: '',
        firstName: '',
        lastName: '',
        gender: '',
        pronouns: '',
        dob: '',
        showOnProfile: false,
        qualities: [],
        drinking: [],
        kids: [],
        religions: [],
        interests: [],
        lookingFor: [],
        causesAndCommunities: [],
        prompts: [],
        defaultMessages: [],
        profilePics: [],
        starSign: '',
        education: '',
        work: '',
        location: Location.initial(),
        educationLevel: '',
        exercise: '',
        haveKids: '',
        genderIdentities: [],
        smoking: '',
        politics: '',
        hometown: '',
        height: '',
        spokenLanguages: [],
        createdByAdminId: '',
        modes: [],
        relationships: [],
        industries: [],
        newToArea: '',
        experiences: [],
        accessToken: '',
        refreshToken: '',
      );

  /// CopyWith
  Data copyWith({
    int? id,
    String? mobile,
    String? role,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? pronouns,
    String? dob,
    bool? showOnProfile,
    List<dynamic>? qualities,
    List<dynamic>? drinking,
    List<dynamic>? kids,
    List<dynamic>? religions,
    List<dynamic>? interests,
    List<dynamic>? lookingFor,
    List<dynamic>? causesAndCommunities,
    List<dynamic>? prompts,
    List<dynamic>? defaultMessages,
    List<dynamic>? profilePics,
    String? starSign,
    String? education,
    String? work,
    Location? location,
    String? educationLevel,
    String? exercise,
    String? haveKids,
    List<dynamic>? genderIdentities,
    String? smoking,
    String? politics,
    String? hometown,
    String? height,
    List<dynamic>? spokenLanguages,
    String? createdByAdminId,
    List<dynamic>? modes,
    List<dynamic>? relationships,
    List<dynamic>? industries,
    String? newToArea,
    List<dynamic>? experiences,
    String? accessToken,
    String? refreshToken,
  }) {
    return Data(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      pronouns: pronouns ?? this.pronouns,
      dob: dob ?? this.dob,
      showOnProfile: showOnProfile ?? this.showOnProfile,
      qualities: qualities ?? this.qualities,
      drinking: drinking ?? this.drinking,
      kids: kids ?? this.kids,
      religions: religions ?? this.religions,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
      prompts: prompts ?? this.prompts,
      defaultMessages: defaultMessages ?? this.defaultMessages,
      profilePics: profilePics ?? this.profilePics,
      starSign: starSign ?? this.starSign,
      education: education ?? this.education,
      work: work ?? this.work,
      location: location ?? this.location,
      educationLevel: educationLevel ?? this.educationLevel,
      exercise: exercise ?? this.exercise,
      haveKids: haveKids ?? this.haveKids,
      genderIdentities: genderIdentities ?? this.genderIdentities,
      smoking: smoking ?? this.smoking,
      politics: politics ?? this.politics,
      hometown: hometown ?? this.hometown,
      height: height ?? this.height,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      createdByAdminId: createdByAdminId ?? this.createdByAdminId,
      modes: modes ?? this.modes,
      relationships: relationships ?? this.relationships,
      industries: industries ?? this.industries,
      newToArea: newToArea ?? this.newToArea,
      experiences: experiences ?? this.experiences,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  /// From JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      mobile: json['mobile'],
      role: json['role'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      pronouns: json['pronouns'],
      dob: json['dob'],
      showOnProfile: json['showOnProfile'],
      qualities: json['qualities'] ?? [],
      drinking: json['drinking'] ?? [],
      kids: json['kids'] ?? [],
      religions: json['religions'] ?? [],
      interests: json['interests'] ?? [],
      lookingFor: json['lookingFor'] ?? [],
      causesAndCommunities: json['causesAndCommunities'] ?? [],
      prompts: json['prompts'] ?? [],
      defaultMessages: json['defaultMessages'] ?? [],
      profilePics: json['profile_pics'] ?? [],
      starSign: json['starSign'],
      education: json['education'],
      work: json['work'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      educationLevel: json['educationLevel'],
      exercise: json['exercise'],
      haveKids: json['haveKids'],
      genderIdentities: json['genderIdentities'] ?? [],
      smoking: json['smoking'],
      politics: json['politics'],
      hometown: json['hometown'],
      height: json['height'],
      spokenLanguages: json['spokenLanguages'] ?? [],
      createdByAdminId: json['createdByAdminId'],
      modes: json['modes'] ?? [],
      relationships: json['relationships'] ?? [],
      industries: json['industries'] ?? [],
      newToArea: json['newToArea'],
      experiences: json['experiences'] ?? [],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'role': role,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'pronouns': pronouns,
      'dob': dob,
      'showOnProfile': showOnProfile,
      'qualities': qualities,
      'drinking': drinking,
      'kids': kids,
      'religions': religions,
      'interests': interests,
      'lookingFor': lookingFor,
      'causesAndCommunities': causesAndCommunities,
      'prompts': prompts,
      'defaultMessages': defaultMessages,
      'profile_pics': profilePics,
      'starSign': starSign,
      'education': education,
      'work': work,
      'location': location?.toJson(),
      'educationLevel': educationLevel,
      'exercise': exercise,
      'haveKids': haveKids,
      'genderIdentities': genderIdentities,
      'smoking': smoking,
      'politics': politics,
      'hometown': hometown,
      'height': height,
      'spokenLanguages': spokenLanguages,
      'createdByAdminId': createdByAdminId,
      'modes': modes,
      'relationships': relationships,
      'industries': industries,
      'newToArea': newToArea,
      'experiences': experiences,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

class Location {
  double? latitude;
  double? longitude;
  String? name;

  Location({this.latitude, this.longitude, this.name});

  factory Location.initial() => Location(
        latitude: 0.0,
        longitude: 0.0,
        name: '',
      );

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }
}
class AdminCreatedUsersModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;
  Pagination? pagination;

  AdminCreatedUsersModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
    this.pagination,
  });

  // Initial method - creates an empty instance with default values
  AdminCreatedUsersModel.initial()
      : statusCode = null,
        success = false,
        messages = [],
        data = [],
        pagination = null;

  AdminCreatedUsersModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    
    // Fixed messages parsing
    if (json['messages'] != null) {
      if (json['messages'] is List) {
        messages = List<String>.from(json['messages']);
      } else if (json['messages'] is String) {
        messages = [json['messages']];
      }
    }
    
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }

  AdminCreatedUsersModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
    Pagination? pagination,
  }) {
    return AdminCreatedUsersModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
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
  List<Qualities>? qualities;
  List<Drinking>? drinking;
  List<Kids>? kids;
  List<Religions>? religions;
  List<Interests>? interests;
  List<LookingFor>? lookingFor;
  List<CausesAndCommunities>? causesAndCommunities;
  List<Prompts>? prompts;
  List<DefaultMessages>? defaultMessages;
  List<ProfilePics>? profilePics;
  String? starSign;
  String? education;
  String? work;
  Location? location;
  String? educationLevel;
  String? exercise;
  bool? haveKids;
  List<GenderIdentities>? genderIdentities;
  String? smoking;
  String? politics;
  String? hometown;
  int? height;
  List<String>? spokenLanguages;
  int? createdByAdminId;
  List<Modes>? modes;
  List<String>? relationships;
  List<String>? industries;
  bool? newToArea;
  List<String>? experiences;
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

  Data.initial()
      : id = null,
        mobile = null,
        role = null,
        email = null,
        firstName = null,
        lastName = null,
        gender = null,
        pronouns = null,
        dob = null,
        showOnProfile = false,
        qualities = [],
        drinking = [],
        kids = [],
        religions = [],
        interests = [],
        lookingFor = [],
        causesAndCommunities = [],
        prompts = [],
        defaultMessages = [],
        profilePics = [],
        starSign = null,
        education = null,
        work = null,
        location = null,
        educationLevel = null,
        exercise = null,
        haveKids = null,
        genderIdentities = [],
        smoking = null,
        politics = null,
        hometown = null,
        height = null,
        spokenLanguages = [],
        createdByAdminId = null,
        modes = [],
        relationships = [],
        industries = [],
        newToArea = null,
        experiences = [],
        accessToken = null,
        refreshToken = null;

  // Helper method to safely convert to bool
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) {
      return value == 1;
    }
    return false;
  }

  // Helper method to safely convert to String
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map || value is List) {
      // If it's a complex object, return null instead of trying to convert
      return null;
    }
    return value.toString();
  }

  Data.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      mobile = _parseString(json['mobile']);
      role = _parseString(json['role']);
      email = _parseString(json['email']);
      firstName = _parseString(json['firstName']);
      lastName = _parseString(json['lastName']);
      gender = _parseString(json['gender']);
      pronouns = _parseString(json['pronouns']);
      dob = _parseString(json['dob']);
      
      // Fixed showOnProfile parsing
      showOnProfile = _parseBool(json['showOnProfile']);
      
      // Parse qualities
      if (json['qualities'] != null && json['qualities'] is List) {
        qualities = <Qualities>[];
        json['qualities'].forEach((v) {
          if (v != null) {
            try {
              qualities!.add(Qualities.fromJson(v));
            } catch (e) {
              print('Error parsing quality: $e');
            }
          }
        });
      }
      
      // Parse drinking
      if (json['drinking'] != null && json['drinking'] is List) {
        drinking = <Drinking>[];
        json['drinking'].forEach((v) {
          if (v != null) {
            try {
              drinking!.add(Drinking.fromJson(v));
            } catch (e) {
              print('Error parsing drinking: $e');
            }
          }
        });
      }
      
      // Parse kids
      if (json['kids'] != null && json['kids'] is List) {
        kids = <Kids>[];
        json['kids'].forEach((v) {
          if (v != null) {
            try {
              kids!.add(Kids.fromJson(v));
            } catch (e) {
              print('Error parsing kids: $e');
            }
          }
        });
      }
      
      // Parse religions
      if (json['religions'] != null && json['religions'] is List) {
        religions = <Religions>[];
        json['religions'].forEach((v) {
          if (v != null) {
            try {
              religions!.add(Religions.fromJson(v));
            } catch (e) {
              print('Error parsing religions: $e');
            }
          }
        });
      }
      
      // Parse interests
      if (json['interests'] != null && json['interests'] is List) {
        interests = <Interests>[];
        json['interests'].forEach((v) {
          if (v != null) {
            try {
              interests!.add(Interests.fromJson(v));
            } catch (e) {
              print('Error parsing interests: $e');
            }
          }
        });
      }
      
      // Parse lookingFor
      if (json['lookingFor'] != null && json['lookingFor'] is List) {
        lookingFor = <LookingFor>[];
        json['lookingFor'].forEach((v) {
          if (v != null) {
            try {
              lookingFor!.add(LookingFor.fromJson(v));
            } catch (e) {
              print('Error parsing lookingFor: $e');
            }
          }
        });
      }
      
      // Parse causesAndCommunities
      if (json['causesAndCommunities'] != null && json['causesAndCommunities'] is List) {
        causesAndCommunities = <CausesAndCommunities>[];
        json['causesAndCommunities'].forEach((v) {
          if (v != null) {
            try {
              causesAndCommunities!.add(CausesAndCommunities.fromJson(v));
            } catch (e) {
              print('Error parsing causesAndCommunities: $e');
            }
          }
        });
      }
      
      // Parse prompts
      if (json['prompts'] != null && json['prompts'] is List) {
        prompts = <Prompts>[];
        json['prompts'].forEach((v) {
          if (v != null) {
            try {
              prompts!.add(Prompts.fromJson(v));
            } catch (e) {
              print('Error parsing prompts: $e');
            }
          }
        });
      }
      
      // Parse defaultMessages
      if (json['defaultMessages'] != null && json['defaultMessages'] is List) {
        defaultMessages = <DefaultMessages>[];
        json['defaultMessages'].forEach((v) {
          if (v != null) {
            try {
              defaultMessages!.add(DefaultMessages.fromJson(v));
            } catch (e) {
              print('Error parsing defaultMessages: $e');
            }
          }
        });
      }
      
      // Parse profile_pics (note the underscore in JSON)
      if (json['profile_pics'] != null && json['profile_pics'] is List) {
        profilePics = <ProfilePics>[];
        json['profile_pics'].forEach((v) {
          if (v != null && v is Map<String, dynamic>) {
            try {
              profilePics!.add(ProfilePics.fromJson(v));
            } catch (e) {
              print('Error parsing profile_pics: $e');
              print('Profile pic data: $v');
            }
          }
        });
      }
      
      starSign = _parseString(json['starSign']);
      education = _parseString(json['education']);
      work = _parseString(json['work']);
      
      if (json['location'] != null && json['location'] is Map<String, dynamic>) {
        try {
          location = Location.fromJson(json['location']);
        } catch (e) {
          print('Error parsing location: $e');
          location = null;
        }
      }
          
      educationLevel = _parseString(json['educationLevel']);
      exercise = _parseString(json['exercise']);
      
      // Fixed haveKids parsing
      haveKids = _parseBool(json['haveKids']);
      
      // Parse genderIdentities
      if (json['genderIdentities'] != null && json['genderIdentities'] is List) {
        genderIdentities = <GenderIdentities>[];
        json['genderIdentities'].forEach((v) {
          if (v != null) {
            try {
              genderIdentities!.add(GenderIdentities.fromJson(v));
            } catch (e) {
              print('Error parsing genderIdentities: $e');
            }
          }
        });
      }
      
      smoking = _parseString(json['smoking']);
      politics = _parseString(json['politics']);
      hometown = _parseString(json['hometown']);
      height = json['height'];
      
      // Parse spokenLanguages
      if (json['spokenLanguages'] != null && json['spokenLanguages'] is List) {
        spokenLanguages = <String>[];
        json['spokenLanguages'].forEach((item) {
          if (item != null) {
            String? parsed = _parseString(item);
            if (parsed != null) {
              spokenLanguages!.add(parsed);
            }
          }
        });
      }
      
      createdByAdminId = json['createdByAdminId'];
      
      // Parse modes
      if (json['modes'] != null && json['modes'] is List) {
        modes = <Modes>[];
        json['modes'].forEach((v) {
          if (v != null) {
            try {
              modes!.add(Modes.fromJson(v));
            } catch (e) {
              print('Error parsing modes: $e');
            }
          }
        });
      }
      
      // Parse relationships
      if (json['relationships'] != null && json['relationships'] is List) {
        relationships = <String>[];
        json['relationships'].forEach((item) {
          if (item != null) {
            String? parsed = _parseString(item);
            if (parsed != null) {
              relationships!.add(parsed);
            }
          }
        });
      }
      
      // Parse industries
      if (json['industries'] != null && json['industries'] is List) {
        industries = <String>[];
        json['industries'].forEach((item) {
          if (item != null) {
            String? parsed = _parseString(item);
            if (parsed != null) {
              industries!.add(parsed);
            }
          }
        });
      }
      
      // Fixed newToArea parsing
      newToArea = _parseBool(json['newToArea']);
      
      // Parse experiences
      if (json['experiences'] != null && json['experiences'] is List) {
        experiences = <String>[];
        json['experiences'].forEach((item) {
          if (item != null) {
            String? parsed = _parseString(item);
            if (parsed != null) {
              experiences!.add(parsed);
            }
          }
        });
      }
      
      accessToken = _parseString(json['accessToken']);
      refreshToken = _parseString(json['refreshToken']);
      
    } catch (e) {
      print('Error parsing Data: $e');
      print('JSON that caused error: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mobile'] = mobile;
    data['role'] = role;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['pronouns'] = pronouns;
    data['dob'] = dob;
    data['showOnProfile'] = showOnProfile;
    
    if (qualities != null) {
      data['qualities'] = qualities!.map((v) => v.toJson()).toList();
    }
    if (drinking != null) {
      data['drinking'] = drinking!.map((v) => v.toJson()).toList();
    }
    if (kids != null) {
      data['kids'] = kids!.map((v) => v.toJson()).toList();
    }
    if (religions != null) {
      data['religions'] = religions!.map((v) => v.toJson()).toList();
    }
    if (interests != null) {
      data['interests'] = interests!.map((v) => v.toJson()).toList();
    }
    if (lookingFor != null) {
      data['lookingFor'] = lookingFor!.map((v) => v.toJson()).toList();
    }
    if (causesAndCommunities != null) {
      data['causesAndCommunities'] =
          causesAndCommunities!.map((v) => v.toJson()).toList();
    }
    if (prompts != null) {
      data['prompts'] = prompts!.map((v) => v.toJson()).toList();
    }
    if (defaultMessages != null) {
      data['defaultMessages'] =
          defaultMessages!.map((v) => v.toJson()).toList();
    }
    if (profilePics != null) {
      data['profile_pics'] = profilePics!.map((v) => v.toJson()).toList();
    }
    
    data['starSign'] = starSign;
    data['education'] = education;
    data['work'] = work;
    
    if (location != null) {
      data['location'] = location!.toJson();
    }
    
    data['educationLevel'] = educationLevel;
    data['exercise'] = exercise;
    data['haveKids'] = haveKids;
    
    if (genderIdentities != null) {
      data['genderIdentities'] =
          genderIdentities!.map((v) => v.toJson()).toList();
    }
    
    data['smoking'] = smoking;
    data['politics'] = politics;
    data['hometown'] = hometown;
    data['height'] = height;
    data['spokenLanguages'] = spokenLanguages;
    data['createdByAdminId'] = createdByAdminId;
    
    if (modes != null) {
      data['modes'] = modes!.map((v) => v.toJson()).toList();
    }
    
    data['relationships'] = relationships;
    data['industries'] = industries;
    data['newToArea'] = newToArea;
    data['experiences'] = experiences;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    
    return data;
  }

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
    List<Qualities>? qualities,
    List<Drinking>? drinking,
    List<Kids>? kids,
    List<Religions>? religions,
    List<Interests>? interests,
    List<LookingFor>? lookingFor,
    List<CausesAndCommunities>? causesAndCommunities,
    List<Prompts>? prompts,
    List<DefaultMessages>? defaultMessages,
    List<ProfilePics>? profilePics,
    String? starSign,
    String? education,
    String? work,
    Location? location,
    String? educationLevel,
    String? exercise,
    bool? haveKids,
    List<GenderIdentities>? genderIdentities,
    String? smoking,
    String? politics,
    String? hometown,
    int? height,
    List<String>? spokenLanguages,
    int? createdByAdminId,
    List<Modes>? modes,
    List<String>? relationships,
    List<String>? industries,
    bool? newToArea,
    List<String>? experiences,
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
}

// All other classes remain the same as before
class Qualities {
  int? id;
  String? name;

  Qualities({this.id, this.name});

  Qualities.initial()
      : id = null,
        name = null;

  Qualities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] is String ? json['name'] : json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  Qualities copyWith({int? id, String? name}) {
    return Qualities(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class Drinking {
  int? id;
  String? preference;

  Drinking({this.id, this.preference});

  Drinking.initial()
      : id = null,
        preference = null;

  Drinking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    preference = json['preference'] is String ? json['preference'] : json['preference']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['preference'] = preference;
    return data;
  }

  Drinking copyWith({int? id, String? preference}) {
    return Drinking(
      id: id ?? this.id,
      preference: preference ?? this.preference,
    );
  }
}

class Kids {
  int? id;
  String? kids;

  Kids({this.id, this.kids});

  Kids.initial()
      : id = null,
        kids = null;

  Kids.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kids = json['kids'] is String ? json['kids'] : json['kids']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['kids'] = kids;
    return data;
  }

  Kids copyWith({int? id, String? kids}) {
    return Kids(
      id: id ?? this.id,
      kids: kids ?? this.kids,
    );
  }
}

class Religions {
  int? id;
  String? religion;

  Religions({this.id, this.religion});

  Religions.initial()
      : id = null,
        religion = null;

  Religions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religion = json['religion'] is String ? json['religion'] : json['religion']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['religion'] = religion;
    return data;
  }

  Religions copyWith({int? id, String? religion}) {
    return Religions(
      id: id ?? this.id,
      religion: religion ?? this.religion,
    );
  }
}

class Interests {
  int? id;
  String? interests;

  Interests({this.id, this.interests});

  Interests.initial()
      : id = null,
        interests = null;

  Interests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interests = json['interests'] is String ? json['interests'] : json['interests']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['interests'] = interests;
    return data;
  }

  Interests copyWith({int? id, String? interests}) {
    return Interests(
      id: id ?? this.id,
      interests: interests ?? this.interests,
    );
  }
}

class LookingFor {
  int? id;
  String? value;

  LookingFor({this.id, this.value});

  LookingFor.initial()
      : id = null,
        value = null;

  LookingFor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'] is String ? json['value'] : json['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }

  LookingFor copyWith({int? id, String? value}) {
    return LookingFor(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }
}

class CausesAndCommunities {
  int? id;
  String? causesAndCommunities;

  CausesAndCommunities({this.id, this.causesAndCommunities});

  CausesAndCommunities.initial()
      : id = null,
        causesAndCommunities = null;

  CausesAndCommunities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    causesAndCommunities = json['causesAndCommunities'] is String ? json['causesAndCommunities'] : json['causesAndCommunities']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['causesAndCommunities'] = causesAndCommunities;
    return data;
  }

  CausesAndCommunities copyWith({int? id, String? causesAndCommunities}) {
    return CausesAndCommunities(
      id: id ?? this.id,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
    );
  }
}

class Prompts {
  int? id;
  String? prompt;
  String? response;

  Prompts({this.id, this.prompt, this.response});

  Prompts.initial()
      : id = null,
        prompt = null,
        response = null;

  Prompts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prompt = json['prompt'] is String ? json['prompt'] : json['prompt']?.toString();
    response = json['response'] is String ? json['response'] : json['response']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prompt'] = prompt;
    data['response'] = response;
    return data;
  }

  Prompts copyWith({int? id, String? prompt, String? response}) {
    return Prompts(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
    );
  }
}

class DefaultMessages {
  int? id;
  String? message;

  DefaultMessages({this.id, this.message});

  DefaultMessages.initial()
      : id = null,
        message = null;

  DefaultMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'] is String ? json['message'] : json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    return data;
  }

  DefaultMessages copyWith({int? id, String? message}) {
    return DefaultMessages(
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }
}

class ProfilePics {
  int? id;
  String? url;
  bool? isPrimary;

  ProfilePics({this.id, this.url, this.isPrimary});

  ProfilePics.initial()
      : id = null,
        url = null,
        isPrimary = false;

  ProfilePics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'] is String ? json['url'] : json['url']?.toString();
    isPrimary = json['isPrimary'] is bool ? json['isPrimary'] : 
                json['isPrimary']?.toString().toLowerCase() == 'true';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['isPrimary'] = isPrimary;
    return data;
  }

  ProfilePics copyWith({int? id, String? url, bool? isPrimary}) {
    return ProfilePics(
      id: id ?? this.id,
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}

class Location {
  double? latitude;
  double? longitude;
  String? name;

  Location({this.latitude, this.longitude, this.name});

  Location.initial()
      : latitude = null,
        longitude = null,
        name = null;

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    name = json['name'] is String ? json['name'] : json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    return data;
  }

  Location copyWith({double? latitude, double? longitude, String? name}) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }
}

class GenderIdentities {
  int? id;
  String? identity;

  GenderIdentities({this.id, this.identity});

  GenderIdentities.initial()
      : id = null,
        identity = null;

  GenderIdentities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identity = json['identity'] is String ? json['identity'] : json['identity']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['identity'] = identity;
    return data;
  }

  GenderIdentities copyWith({int? id, String? identity}) {
    return GenderIdentities(
      id: id ?? this.id,
      identity: identity ?? this.identity,
    );
  }
}

class Modes {
  int? id;
  String? mode;

  Modes({this.id, this.mode});

  Modes.initial()
      : id = null,
        mode = null;

  Modes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mode = json['mode'] is String ? json['mode'] : json['mode']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mode'] = mode;
    return data;
  }

  Modes copyWith({int? id, String? mode}) {
    return Modes(
      id: id ?? this.id,
      mode: mode ?? this.mode,
    );
  }
}

// class Pagination {
//   int? total;
//   int? page;
//   int? limit;
//   int? totalPages;

//   Pagination({this.total, this.page, this.limit, this.totalPages});

//   Pagination.initial()
//       : total = 0,
//         page = 1,
//         limit = 10,
//         totalPages = 0;

//   Pagination.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     page = json['page'];
//     limit = json['limit'];
//     totalPages = json['totalPages'];
//   }

//   Map<String, dynamic> toJson() {
//     final
class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({this.total, this.page, this.limit, this.totalPages});

  Pagination.initial()
      : total = 0,
        page = 1,
        limit = 10,
        totalPages = 0;

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }

  Pagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return Pagination(
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
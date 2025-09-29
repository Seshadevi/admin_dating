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
  String? headLine;
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
  StarSign? starSign;
  String? education;
  List<Sports>? sports;
  List<Work>? works;
  Location? location;
  String? educationLevel;
  String? exercise;
  String? haveKids;
  List<GenderIdentities>? genderIdentities;
  String? smoking;
  String? sleepingHabits;
  String? dietaryPreference;
  String? politics;
  String? hometown;
  int? height;
  List<Language>? spokenLanguages;
  int? createdByAdminId;
  List<Modes>? modes;
  List<Relationships>? relationships;
  List<Industries>? industries;
  String? newToArea;
  List<Experiences>? experiences;
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
    this.headLine,
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
    this.works,
    this.sports,
    this.location,
    this.educationLevel,
    this.exercise,
    this.haveKids,
    this.genderIdentities,
    this.smoking,
    this.sleepingHabits,
    this.dietaryPreference,
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
        headLine = null,
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
        works=[],
        sports=[],
        location = null,
        educationLevel = null,
        exercise = null,
        haveKids = null,
        genderIdentities = [],
        smoking = null,
        sleepingHabits = null,
        dietaryPreference=null,
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
      headLine=_parseString(json['headLine']);
      
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
       if (json['sports'] != null) {
      sports = <Sports>[];
      json['sports'].forEach((v) {
        sports!.add(Sports.fromJson(v));
      });
    }
    if (json['works'] != null) {
      works = <Work>[];
      json['works'].forEach((v) {
        works!.add(Work.fromJson(v));
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
      starSign =
        json['starSign'] != null ? StarSign.fromJson(json['starSign']) : null;
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
      

      education = _parseString(json['education']);
  
      
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
      // haveKids = _parseBool(json['haveKids']);
      
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
      sleepingHabits = _parseString(json['sleepingHabits']);
      dietaryPreference = _parseString(json['dietaryPreference']);
      politics = _parseString(json['politics']);
      hometown = _parseString(json['hometown']);
      newToArea=_parseString(json['newToArea']);
      haveKids=_parseString(json['haveKids']);
      height = json['height'];
      
      // Parse spokenLanguages
      if (json['spokenLanguages'] != null && json['spokenLanguages'] is List) {
        spokenLanguages = <Language>[];
        json['spokenLanguages'].forEach((item) {
          if (item != null) {
             try {
              spokenLanguages!.add(Language.fromJson(item));
            } catch (e) {
              print('Error parsing Language: $e');
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
        relationships = <Relationships>[];
        json['relationships'].forEach((item) {
          if (item != null) {
            try {
              relationships!.add(Relationships.fromJson(item));
            } catch (e) {
              print('Error parsing Relationships: $e');
            } 
          }
        });
      }
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
      
      // Parse industries
      if (json['industries'] != null && json['industries'] is List) {
        industries = <Industries>[];
        json['industries'].forEach((item) {
          if (item != null) {
            try {
              industries!.add(Industries.fromJson(item));
            } catch (e) {
              print('Error parsing genderIdentities: $e');
            }
          }
        });
      }
      
      // Fixed newToArea parsing
      // newToArea = _parseBool(json['newToArea']);
      
      // Parse experiences
      if (json['experiences'] != null && json['experiences'] is List) {
        experiences = <Experiences>[];
        json['experiences'].forEach((item) {
          if (item != null) {
             try {
              experiences!.add(Experiences.fromJson(item));
            } catch (e) {
              print('Error parsing Experiences: $e');
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
    data['headLine'] = headLine;
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
    if (sports != null) {
      data['sports'] = sports!.map((v) => v.toJson()).toList();
    }
    if (works != null) {
      data['works'] = works!.map((v) => v.toJson()).toList();
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
     if (starSign != null) {
      data['starSign'] = starSign!.toJson();
    }
    if (profilePics != null) {
      data['profile_pics'] = profilePics!.map((v) => v.toJson()).toList();
    }
    

    data['education'] = education;

    
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
    data['sleepingHabits'] = sleepingHabits;
    data['dietaryPreference'] = dietaryPreference;
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
    String? headLine,
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
    StarSign? starSign,
    String? education,
    List<Sports>? sports,
    List<Work>? works,
    Location? location,
    String? educationLevel,
    String? exercise,
    String? haveKids,
    List<GenderIdentities>? genderIdentities,
    String? smoking,
    String ? sleepingHabits,
    String? dietaryPreference ,
    String? politics,
    String? hometown,
    int? height,
    List<Language>? spokenLanguages,
    int? createdByAdminId,
    List<Modes>? modes,
    List<Relationships>? relationships,
    List<Industries>? industries,
    String? newToArea,
    List<Experiences>? experiences,
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
      headLine :headLine ?? this.headLine,
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
      sports: sports ?? this.sports,
      works: works ?? this.works  ,
      location: location ?? this.location,
      educationLevel: educationLevel ?? this.educationLevel,
      exercise: exercise ?? this.exercise,
      haveKids: haveKids ?? this.haveKids,
      genderIdentities: genderIdentities ?? this.genderIdentities,
      smoking: smoking ?? this.smoking,
      sleepingHabits:sleepingHabits?? this.sleepingHabits,
      dietaryPreference :dietaryPreference?? this.dietaryPreference,
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

class StarSign {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  StarSign({this.id, this.name, this.createdAt, this.updatedAt});

  StarSign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  StarSign copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return StarSign(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static StarSign initial() {
    return StarSign();
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
class Relationships {
  int? id;
  String? relation;
  UserRelation? userRelation;

  Relationships({this.id, this.relation, this.userRelation});

  factory Relationships.fromJson(Map<String, dynamic> json) {
    return Relationships(
      id: json['id'],
      relation: json['relation'],
      userRelation: json['user_relation'] != null
          ? UserRelation.fromJson(json['user_relation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['relation'] = relation;
    if (userRelation != null) {
      data['user_relation'] = userRelation!.toJson();
    }
    return data;
  }

  Relationships copyWith({
    int? id,
    String? relation,
    UserRelation? userRelation,
  }) {
    return Relationships(
      id: id ?? this.id,
      relation: relation ?? this.relation,
      userRelation: userRelation ?? this.userRelation,
    );
  }

  factory Relationships.initial() {
    return Relationships(
      id: 0,
      relation: '',
      userRelation: UserRelation.initial(),
    );
  }
}

class UserRelation {
  int? userId;
  int? relationId;

  UserRelation({this.userId, this.relationId});

  factory UserRelation.fromJson(Map<String, dynamic> json) {
    return UserRelation(
      userId: json['user_id'],
      relationId: json['relation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['relation_id'] = relationId;
    return data;
  }

  UserRelation copyWith({
    int? userId,
    int? relationId,
  }) {
    return UserRelation(
      userId: userId ?? this.userId,
      relationId: relationId ?? this.relationId,
    );
  }

  factory UserRelation.initial() {
    return UserRelation(
      userId: 0,
      relationId: 0,
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
class Industries {
  int? id;
  String? industrie;
  UserIndustries? userIndustries;

  Industries({this.id, this.industrie, this.userIndustries});

  factory Industries.fromJson(Map<String, dynamic> json) {
    return Industries(
      id: json['id'],
      industrie: json['industry'],
      userIndustries: json['user_industries'] != null
          ? UserIndustries.fromJson(json['user_industries'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['industry'] = industrie;
    if (userIndustries != null) {
      data['user_industries'] = userIndustries!.toJson();
    }
    return data;
  }

  Industries copyWith({
    int? id,
    String? industrie,
    UserIndustries? userIndustries,
  }) {
    return Industries(
      id: id ?? this.id,
      industrie: industrie ?? this.industrie,
      userIndustries: userIndustries ?? this.userIndustries,
    );
  }

  factory Industries.initial() {
    return Industries(
      id: 0,
      industrie: '',
      userIndustries: UserIndustries.initial(),
    );
  }
}
class Work {
  final int? id;
  final String? title;
  final String? company;

  Work({
    this.id,
    this.title,
    this.company,
  });

  /// Factory constructor for initial empty state
  factory Work.initial() {
    return Work(
      id: 0,
      title: '',
      company: '',
    );
  }

  /// Parse from JSON
  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['id'],
      title: json['title'],
      company: json['company'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
    };
  }

  /// CopyWith for immutability
  Work copyWith({
    int? id,
    String? title,
    String? company,
  }) {
    return Work(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
    );
  }
}

class Sports {
  final int? id;
  final String? title;

  Sports({this.id, this.title});

  factory Sports.fromJson(Map<String, dynamic> json) {
    return Sports(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

  Sports copyWith({
    int? id,
    String? title,
  }) {
    return Sports(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  factory Sports.initial() {
    return Sports(
      id: 0,
      title: '',
    );
  }
}


class UserIndustries {
  int? userId;
  int? industriesId;

  UserIndustries({this.userId, this.industriesId});

  UserIndustries.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    industriesId = json['industries_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['industries_id'] = industriesId;
    return data;
  }

  UserIndustries copyWith({
    int? userId,
    int? industriesId,
  }) {
    return UserIndustries(
      userId: userId ?? this.userId,
      industriesId: industriesId ?? this.industriesId,
    );
  }

  static UserIndustries initial() {
    return UserIndustries();
  }
}
class Experiences {
  int? id;
  String? experience;
  UserExperiences? userExperiences;

  Experiences({
    this.id,
    this.experience,
    this.userExperiences,
  });

  factory Experiences.fromJson(Map<String, dynamic> json) {
    return Experiences(
      id: json['id'],
      experience: json['experience'],
      userExperiences: json['user_experiences'] != null
          ? UserExperiences.fromJson(json['user_experiences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['experience'] = experience;
    if (userExperiences != null) {
      data['user_experiences'] = userExperiences!.toJson();
    }
    return data;
  }

  Experiences copyWith({
    int? id,
    String? experiences,
    UserExperiences? userExperiences,
  }) {
    return Experiences(
      id: id ?? this.id,
      experience: experiences ?? this.experience,
      userExperiences: userExperiences ?? this.userExperiences,
    );
  }

  factory Experiences.initial() {
    return Experiences(
      id: 0,
      experience: '',
      userExperiences: UserExperiences.initial(),
    );
  }
}

class UserExperiences {
  int? userId;
  int? experiencesId;

  UserExperiences({
    this.userId,
    this.experiencesId,
  });

  factory UserExperiences.fromJson(Map<String, dynamic> json) {
    return UserExperiences(
      userId: json['user_id'],
      experiencesId: json['experiences_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['experiences_id'] = experiencesId;
    return data;
  }

  UserExperiences copyWith({
    int? userId,
    int? experiencesId,
  }) {
    return UserExperiences(
      userId: userId ?? this.userId,
      experiencesId: experiencesId ?? this.experiencesId,
    );
  }

  factory UserExperiences.initial() {
    return UserExperiences(
      userId: 0,
      experiencesId: 0,
    );
  }
}
class Language {
  int? id;
  String? name;

  Language({this.id, this.name});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
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
    mode = json['value'] is String ? json['value'] : json['value']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = mode;
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
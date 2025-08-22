class Realusersmodel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;
  Pagination? pagination;

  Realusersmodel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
    this.pagination,
  });

  // Initial/Empty constructor
  Realusersmodel.initial()
      : statusCode = null,
        success = null,
        messages = [],
        data = [],
        pagination = null;

  Realusersmodel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages']?.cast<String>();
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

  // CopyWith method
  Realusersmodel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
    Pagination? pagination,
  }) {
    return Realusersmodel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
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
  Qualities? starSign;
  Education? education;
  Work? work;
  Location? location;
  String? educationLevel;
  String? exercise;
  String? haveKids;
  List<GenderIdentities>? genderIdentities;
  String? smoking;
  String? politics;
  String? hometown;
  int? height;
  List<SpokenLanguages>? spokenLanguages;
  dynamic createdByAdminId;
  List<dynamic>? modes;
  List<dynamic>? relationships;
  List<dynamic>? industries;
  dynamic newToArea;
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

  // Initial/Empty constructor
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobile = json['mobile'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    pronouns = json['pronouns'];
    dob = json['dob'];
    showOnProfile = json['showOnProfile'];
    if (json['qualities'] != null) {
      qualities = <Qualities>[];
      json['qualities'].forEach((v) {
        qualities!.add(Qualities.fromJson(v));
      });
    }
    if (json['drinking'] != null) {
      drinking = <Drinking>[];
      json['drinking'].forEach((v) {
        drinking!.add(Drinking.fromJson(v));
      });
    }
    if (json['kids'] != null) {
      kids = <Kids>[];
      json['kids'].forEach((v) {
        kids!.add(Kids.fromJson(v));
      });
    }
    if (json['religions'] != null) {
      religions = <Religions>[];
      json['religions'].forEach((v) {
        religions!.add(Religions.fromJson(v));
      });
    }
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(Interests.fromJson(v));
      });
    }
    if (json['lookingFor'] != null) {
      lookingFor = <LookingFor>[];
      json['lookingFor'].forEach((v) {
        lookingFor!.add(LookingFor.fromJson(v));
      });
    }
    if (json['causesAndCommunities'] != null) {
      causesAndCommunities = <CausesAndCommunities>[];
      json['causesAndCommunities'].forEach((v) {
        causesAndCommunities!.add(CausesAndCommunities.fromJson(v));
      });
    }
    if (json['prompts'] != null) {
      prompts = <Prompts>[];
      json['prompts'].forEach((v) {
        prompts!.add(Prompts.fromJson(v));
      });
    }
    if (json['defaultMessages'] != null) {
      defaultMessages = <DefaultMessages>[];
      json['defaultMessages'].forEach((v) {
        defaultMessages!.add(DefaultMessages.fromJson(v));
      });
    }
    if (json['profile_pics'] != null) {
      profilePics = <ProfilePics>[];
      json['profile_pics'].forEach((v) {
        profilePics!.add(ProfilePics.fromJson(v));
      });
    }
    starSign = json['starSign'] != null
        ? Qualities.fromJson(json['starSign'])
        : null;
    education = json['education'] != null
        ? Education.fromJson(json['education'])
        : null;
    work = json['work'] != null ? Work.fromJson(json['work']) : null;
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    educationLevel = json['educationLevel'];
    exercise = json['exercise'];
    haveKids = json['haveKids'];
    if (json['genderIdentities'] != null) {
      genderIdentities = <GenderIdentities>[];
      json['genderIdentities'].forEach((v) {
        genderIdentities!.add(GenderIdentities.fromJson(v));
      });
    }
    smoking = json['smoking'];
    politics = json['politics'];
    hometown = json['hometown'];
    height = json['height'];
    if (json['spokenLanguages'] != null) {
      spokenLanguages = <SpokenLanguages>[];
      json['spokenLanguages'].forEach((v) {
        spokenLanguages!.add(SpokenLanguages.fromJson(v));
      });
    }
    createdByAdminId = json['createdByAdminId'];
    modes = json['modes'];
    relationships = json['relationships'];
    industries = json['industries'];
    newToArea = json['newToArea'];
    experiences = json['experiences'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  // CopyWith method
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
    Qualities? starSign,
    Education? education,
    Work? work,
    Location? location,
    String? educationLevel,
    String? exercise,
    String? haveKids,
    List<GenderIdentities>? genderIdentities,
    String? smoking,
    String? politics,
    String? hometown,
    int? height,
    List<SpokenLanguages>? spokenLanguages,
    dynamic createdByAdminId,
    List<dynamic>? modes,
    List<dynamic>? relationships,
    List<dynamic>? industries,
    dynamic newToArea,
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
    if (starSign != null) {
      data['starSign'] = starSign!.toJson();
    }
    if (education != null) {
      data['education'] = education!.toJson();
    }
    if (work != null) {
      data['work'] = work!.toJson();
    }
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
    if (spokenLanguages != null) {
      data['spokenLanguages'] =
          spokenLanguages!.map((v) => v.toJson()).toList();
    }
    data['createdByAdminId'] = createdByAdminId;
    data['modes'] = modes;
    data['relationships'] = relationships;
    data['industries'] = industries;
    data['newToArea'] = newToArea;
    data['experiences'] = experiences;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class Qualities {
  int? id;
  String? name;

  Qualities({this.id, this.name});

  Qualities.initial()
      : id = null,
        name = null;

  Qualities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Qualities copyWith({
    int? id,
    String? name,
  }) {
    return Qualities(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
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
    preference = json['preference'];
  }

  Drinking copyWith({
    int? id,
    String? preference,
  }) {
    return Drinking(
      id: id ?? this.id,
      preference: preference ?? this.preference,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['preference'] = preference;
    return data;
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
    kids = json['kids'];
  }

  Kids copyWith({
    int? id,
    String? kids,
  }) {
    return Kids(
      id: id ?? this.id,
      kids: kids ?? this.kids,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['kids'] = kids;
    return data;
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
    religion = json['religion'];
  }

  Religions copyWith({
    int? id,
    String? religion,
  }) {
    return Religions(
      id: id ?? this.id,
      religion: religion ?? this.religion,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['religion'] = religion;
    return data;
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
    interests = json['interests'];
  }

  Interests copyWith({
    int? id,
    String? interests,
  }) {
    return Interests(
      id: id ?? this.id,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['interests'] = interests;
    return data;
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
    value = json['value'];
  }

  LookingFor copyWith({
    int? id,
    String? value,
  }) {
    return LookingFor(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
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
    causesAndCommunities = json['causesAndCommunities'];
  }

  CausesAndCommunities copyWith({
    int? id,
    String? causesAndCommunities,
  }) {
    return CausesAndCommunities(
      id: id ?? this.id,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['causesAndCommunities'] = causesAndCommunities;
    return data;
  }
}

class Prompts {
  int? id;
  String? prompt;
  dynamic response;

  Prompts({this.id, this.prompt, this.response});

  Prompts.initial()
      : id = null,
        prompt = null,
        response = null;

  Prompts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prompt = json['prompt'];
    response = json['response'];
  }

  Prompts copyWith({
    int? id,
    String? prompt,
    dynamic response,
  }) {
    return Prompts(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['prompt'] = prompt;
    data['response'] = response;
    return data;
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
    message = json['message'];
  }

  DefaultMessages copyWith({
    int? id,
    String? message,
  }) {
    return DefaultMessages(
      id: id ?? this.id,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    return data;
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
    url = json['url'];
    isPrimary = json['isPrimary'];
  }

  ProfilePics copyWith({
    int? id,
    String? url,
    bool? isPrimary,
  }) {
    return ProfilePics(
      id: id ?? this.id,
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['isPrimary'] = isPrimary;
    return data;
  }
}

class Education {
  int? id;
  String? institution;
  int? gradYear;

  Education({this.id, this.institution, this.gradYear});

  Education.initial()
      : id = null,
        institution = null,
        gradYear = null;

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institution = json['institution'];
    gradYear = json['gradYear'];
  }

  Education copyWith({
    int? id,
    String? institution,
    int? gradYear,
  }) {
    return Education(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      gradYear: gradYear ?? this.gradYear,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['institution'] = institution;
    data['gradYear'] = gradYear;
    return data;
  }
}

class Work {
  int? id;
  String? title;
  String? company;

  Work({this.id, this.title, this.company});

  Work.initial()
      : id = null,
        title = null,
        company = null;

  Work.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    company = json['company'];
  }

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['company'] = company;
    return data;
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
    name = json['name'];
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? name,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    return data;
  }
}

// Missing classes that were referenced but not defined
class GenderIdentities {
  int? id;
  String? identity;

  GenderIdentities({this.id, this.identity});

  GenderIdentities.initial()
      : id = null,
        identity = null;

  GenderIdentities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identity = json['identity'];
  }

  GenderIdentities copyWith({
    int? id,
    String? identity,
  }) {
    return GenderIdentities(
      id: id ?? this.id,
      identity: identity ?? this.identity,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['identity'] = identity;
    return data;
  }
}

class SpokenLanguages {
  int? id;
  String? language;

  SpokenLanguages({this.id, this.language});

  SpokenLanguages.initial()
      : id = null,
        language = null;

  SpokenLanguages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    language = json['language'];
  }

  SpokenLanguages copyWith({
    int? id,
    String? language,
  }) {
    return SpokenLanguages(
      id: id ?? this.id,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language'] = language;
    return data;
  }
}

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    return data;
  }
}
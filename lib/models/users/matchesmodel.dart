class Matchesmodel {
  bool? success;
  String? message;
  List<Data>? data;

  Matchesmodel({this.success, this.message, this.data});

  /// Factory constructor for initial/default object
  factory Matchesmodel.initial() => Matchesmodel(
        success: false,
        message: '',
        data: [],
      );

  Matchesmodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// CopyWith method
  Matchesmodel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Matchesmodel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? matchId;
  String? status;
  String? matchedAt;
  MatchedUser? matchedUser;

  Data({this.matchId, this.status, this.matchedAt, this.matchedUser});

  /// Factory constructor for initial/default object
  factory Data.initial() => Data(
        matchId: 0,
        status: '',
        matchedAt: '',
        matchedUser: MatchedUser.initial(),
      );

  Data.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    status = json['status'];
    matchedAt = json['matchedAt'];
    matchedUser = json['matchedUser'] != null
        ? MatchedUser.fromJson(json['matchedUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['matchId'] = this.matchId;
    data['status'] = this.status;
    data['matchedAt'] = this.matchedAt;
    if (this.matchedUser != null) {
      data['matchedUser'] = this.matchedUser!.toJson();
    }
    return data;
  }

  /// CopyWith method
  Data copyWith({
    int? matchId,
    String? status,
    String? matchedAt,
    MatchedUser? matchedUser,
  }) {
    return Data(
      matchId: matchId ?? this.matchId,
      status: status ?? this.status,
      matchedAt: matchedAt ?? this.matchedAt,
      matchedUser: matchedUser ?? this.matchedUser,
    );
  }
}

class MatchedUser {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  int? age;
  String? bio;
  String? photoUrl;

  MatchedUser({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.age,
    this.bio,
    this.photoUrl,
  });

  /// Factory constructor for initial/default object
  factory MatchedUser.initial() => MatchedUser(
        id: 0,
        username: '',
        firstName: '',
        lastName: '',
        email: '',
        gender: '',
        age: 0,
        bio: '',
        photoUrl: '',
      );

  MatchedUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    gender = json['gender'];
    age = json['age'];
    bio = json['bio'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['username'] = this.username;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['bio'] = this.bio;
    data['photoUrl'] = this.photoUrl;
    return data;
  }

  /// CopyWith method
  MatchedUser copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    int? age,
    String? bio,
    String? photoUrl,
  }) {
    return MatchedUser(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

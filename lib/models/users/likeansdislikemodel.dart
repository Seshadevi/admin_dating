class Likeansdislikemodel {
  final bool? success;
  final String? message;
  final List<Data>? data;

  Likeansdislikemodel({this.success, this.message, this.data});

  factory Likeansdislikemodel.fromJson(Map<String, dynamic> json) {
    return Likeansdislikemodel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }

  /// copyWith
  Likeansdislikemodel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Likeansdislikemodel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// initial
  factory Likeansdislikemodel.initial() {
    return Likeansdislikemodel(
      success: false,
      message: '',
      data: [],
    );
  }
}

class Data {
  final int? likeId;
  final String? action;
  final String? createdAt;
  final TargetUser? targetUser;

  Data({this.likeId, this.action, this.createdAt, this.targetUser});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      likeId: json['likeId'],
      action: json['action'],
      createdAt: json['createdAt'],
      targetUser: json['targetUser'] != null
          ? TargetUser.fromJson(json['targetUser'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likeId': likeId,
      'action': action,
      'createdAt': createdAt,
      'targetUser': targetUser?.toJson(),
    };
  }

  /// copyWith
  Data copyWith({
    int? likeId,
    String? action,
    String? createdAt,
    TargetUser? targetUser,
  }) {
    return Data(
      likeId: likeId ?? this.likeId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      targetUser: targetUser ?? this.targetUser,
    );
  }

  /// initial
  factory Data.initial() {
    return Data(
      likeId: 0,
      action: '',
      createdAt: '',
      targetUser: TargetUser.initial(),
    );
  }
}

class TargetUser {
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? gender;
  final int? age;
  final String? bio;
  final String? photoUrl;

  TargetUser({
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

  factory TargetUser.fromJson(Map<String, dynamic> json) {
    return TargetUser(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: json['gender'],
      age: json['age'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'age': age,
      'bio': bio,
      'photoUrl': photoUrl,
    };
  }

  /// copyWith
  TargetUser copyWith({
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
    return TargetUser(
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

  /// initial
  factory TargetUser.initial() {
    return TargetUser(
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
  }
}

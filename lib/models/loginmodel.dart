// class UserModel {
//   int? statusCode;
//   bool? success;
//   List<String>? messages;
//   List<Data>? data;

//   UserModel({this.statusCode, this.success, this.messages, this.data});

//   factory UserModel.initial() => UserModel(
//         statusCode: 0,
//         success: false,
//         messages: [],
//         data: [],
//       );

//   UserModel copyWith({
//     int? statusCode,
//     bool? success,
//     List<String>? messages,
//     List<Data>? data,
//   }) {
//     return UserModel(
//       statusCode: statusCode ?? this.statusCode,
//       success: success ?? this.success,
//       messages: messages ?? this.messages,
//       data: data ?? this.data,
//     );
//   }

//   UserModel.fromJson(Map<String, dynamic> json) {
//     statusCode = json['statusCode'];
//     success = json['success'];
//     messages = List<String>.from(json['messages']);
//     data = json['data'] != null
//         ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
//         : null;
//   }

//   Map<String, dynamic> toJson() => {
//         'statusCode': statusCode,
//         'success': success,
//         'messages': messages,
//         'data': data?.map((v) => v.toJson()).toList(),
//       };
// }
// class Data {
//   String? accessToken;
//   String? refreshToken;
//   User? user;

//   Data({this.accessToken, this.refreshToken, this.user});

//   factory Data.initial() => Data(
//         accessToken: '',
//         refreshToken: '',
//         user: User.initial(),
//       );

//   Data copyWith({
//     String? accessToken,
//     String? refreshToken,
//     User? user,
//   }) {
//     return Data(
//       accessToken: accessToken ?? this.accessToken,
//       refreshToken: refreshToken ?? this.refreshToken,
//       user: user ?? this.user,
//     );
//   }

//   Data.fromJson(Map<String, dynamic> json) {
//     accessToken = json['access_token'];
//     refreshToken = json['refresh_token'];
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }

//   Map<String, dynamic> toJson() => {
//         'access_token': accessToken,
//         'refresh_token': refreshToken,
//         'user': user?.toJson(),
//       };
// }
// class User {
//   int? id;
//   String? username;
//   String? email;
//   String? role;
//   int? roleId;
//   String? profilePic;
//   String? createdAt;
//   String? updatedAt;

//   User({
//     this.id,
//     this.username,
//     this.email,
//     this.role,
//     this.roleId,
//     this.profilePic,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory User.initial() => User(
//         id: 0,
//         username: '',
//         email: '',
//         role: '',
//         roleId: 0,
//         profilePic: '',
//         createdAt: '',
//         updatedAt: '',
//       );

//   User copyWith({
//     int? id,
//     String? username,
//     String? email,
//     String? role,
//     int? roleId,
//     String? profilePic,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     return User(
//       id: id ?? this.id,
//       username: username ?? this.username,
//       email: email ?? this.email,
//       role: role ?? this.role,
//       roleId: roleId ?? this.roleId,
//       profilePic: profilePic ?? this.profilePic,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     email = json['email'];
//     role = json['role'];
//     roleId = json['roleId'];
//     profilePic = json['profilePic'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'username': username,
//         'email': email,
//         'role': role,
//         'roleId': roleId,
//         'profilePic': profilePic,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };
// }
class UserModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  UserModel({this.statusCode, this.success, this.messages, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'].cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['statusCode'] = statusCode;
    map['success'] = success;
    map['messages'] = messages;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

  /// ✅ Initial (default empty object)
  factory UserModel.initial() => UserModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );

  /// ✅ CopyWith method
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
}

class Data {
  String? accessToken;
  String? refreshToken;
  User? user;

  Data({this.accessToken, this.refreshToken, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }

  /// ✅ Initial (default empty object)
  factory Data.initial() => Data(
        accessToken: '',
        refreshToken: '',
        user: User.initial(),
      );

  /// ✅ CopyWith method
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
}

class User {
  int? id;
  String? username;
  String? email;
  String? role;
  int? roleId;
  String? profilePic;
  List<dynamic>? pages;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.username,
    this.email,
    this.role,
    this.roleId,
    this.profilePic,
    this.pages,
    this.createdAt,
    this.updatedAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    roleId = json['roleId'];
    profilePic = json['profilePic'];
    pages = json['pages'] ?? [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['role'] = role;
    map['roleId'] = roleId;
    map['profilePic'] = profilePic;
    map['pages'] = pages;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  /// ✅ Initial (default empty object)
  factory User.initial() => User(
        id: 0,
        username: '',
        email: '',
        role: '',
        roleId: 0,
        profilePic: '',
        pages: [],
        createdAt: '',
        updatedAt: '',
      );

  /// ✅ CopyWith method
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    int? roleId,
    String? profilePic,
    List<dynamic>? pages,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      roleId: roleId ?? this.roleId,
      profilePic: profilePic ?? this.profilePic,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


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

  /// Initial/empty instance
  UserModel.initial()
      : statusCode = null,
        success = false,
        messages = const [],
        data = const [];

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    final msgs = json['messages'];
    if (msgs is List) {
      messages = msgs.map((e) => e.toString()).toList();
    } else if (msgs is String) {
      messages = [msgs];
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['success'] = success;
    map['messages'] = messages;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

  /// copyWith
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

  /// Initial/empty instance
  Data.initial()
      : accessToken = null,
        refreshToken = null,
        user = User.initial();

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }

  /// copyWith
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
  List<Pages>? pages;
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

  /// Initial/empty instance
  User.initial()
      : id = null,
        username = null,
        email = null,
        role = null,
        roleId = null,
        profilePic = null,
        pages = const [],
        createdAt = null,
        updatedAt = null;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    roleId = json['roleId'];
    profilePic = json['profilePic'];
    if (json['pages'] != null) {
      pages = <Pages>[];
      json['pages'].forEach((v) {
        pages!.add(Pages.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['role'] = role;
    map['roleId'] = roleId;
    map['profilePic'] = profilePic;
    if (pages != null) {
      map['pages'] = pages!.map((v) => v.toJson()).toList();
    }
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  /// copyWith
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    int? roleId,
    String? profilePic,
    List<Pages>? pages,
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

class Pages {
  int? id;
  String? pages;

  Pages({this.id, this.pages});

  /// Initial/empty instance
  Pages.initial()
      : id = null,
        pages = null;

  Pages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['pages'] = pages;
    return map;
  }

  /// copyWith
  Pages copyWith({
    int? id,
    String? pages,
  }) {
    return Pages(
      id: id ?? this.id,
      pages: pages ?? this.pages,
    );
  }
}

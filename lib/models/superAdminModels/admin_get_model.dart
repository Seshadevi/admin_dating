// class AdminGetModel {
//   int? id;
//   String? username;
//   String? email;
//   String? password;
//   String? profilePic;
//   int? roleId;
//   String? createdAt;
//   String? updatedAt;
//   Role? role;
//
//   AdminGetModel({
//     this.id,
//     this.username,
//     this.email,
//     this.password,
//     this.profilePic,
//     this.roleId,
//     this.createdAt,
//     this.updatedAt,
//     this.role,
//   });
//
//   /// Factory constructor for creating an empty/initial object
//   factory AdminGetModel.initial() {
//     return AdminGetModel(
//       id: 0,
//       username: '',
//       email: '',
//       password: '',
//       profilePic: '',
//       roleId: 0,
//       createdAt: '',
//       updatedAt: '',
//       role: Role.initial(),
//     );
//   }
//
//   /// Creates a new object while allowing selective field updates
//   AdminGetModel copyWith({
//     int? id,
//     String? username,
//     String? email,
//     String? password,
//     String? profilePic,
//     int? roleId,
//     String? createdAt,
//     String? updatedAt,
//     Role? role,
//   }) {
//     return AdminGetModel(
//       id: id ?? this.id,
//       username: username ?? this.username,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       profilePic: profilePic ?? this.profilePic,
//       roleId: roleId ?? this.roleId,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       role: role ?? this.role,
//     );
//   }
//
//   AdminGetModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     email = json['email'];
//     password = json['password'];
//     profilePic = json['profilePic'];
//     roleId = json['roleId'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     role = json['role'] != null ? Role.fromJson(json['role']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['email'] = this.email;
//     data['password'] = this.password;
//     data['profilePic'] = this.profilePic;
//     data['roleId'] = this.roleId;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     if (this.role != null) {
//       data['role'] = this.role!.toJson();
//     }
//     return data;
//   }
// }
//
// class Role {
//   int? id;
//   String? roleName;
//   String? createdAt;
//   String? updatedAt;
//
//   Role({
//     this.id,
//     this.roleName,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   /// Factory constructor for initial empty role
//   factory Role.initial() {
//     return Role(
//       id: 0,
//       roleName: '',
//       createdAt: '',
//       updatedAt: '',
//     );
//   }
//
//   /// Copy with method for Role
//   Role copyWith({
//     int? id,
//     String? roleName,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     return Role(
//       id: id ?? this.id,
//       roleName: roleName ?? this.roleName,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
//
//   Role.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     roleName = json['role_name'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = this.id;
//     data['role_name'] = this.roleName;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }
class AdminGetModel {
  final String message;
  final List<Admin> data;

  AdminGetModel({
    required this.message,
    required this.data,
  });

  factory AdminGetModel.fromJson(Map<String, dynamic> json) => AdminGetModel(
    message: json['message'] ?? '',
    data: json['data'] != null
        ? List<Admin>.from(json['data'].map((x) => Admin.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data.map((x) => x.toJson()).toList(),
  };
}

class Admin {
  final int id;
  final String username;
  final String email;
  final String password;
  final String? profilePic;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Page> pages;

  Admin({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.profilePic,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
    required this.pages,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json['id'],
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    profilePic: json['profilePic'],
    roleId: json['roleId'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    pages: json['pages'] != null
        ? List<Page>.from(json['pages'].map((x) => Page.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'profilePic': profilePic,
    'roleId': roleId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'pages': pages.map((x) => x.toJson()).toList(),
  };
}

class Page {
  final int id;
  final String pages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Page({
    required this.id,
    required this.pages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    id: json['id'],
    pages: json['pages'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'pages': pages,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

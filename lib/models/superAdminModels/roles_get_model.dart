class GetRolesModel {
  String? message;
  List<Data>? data;

  GetRolesModel({this.message, this.data});

  GetRolesModel.fromJson(Map<String, dynamic> json) {
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
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// copyWith method
  GetRolesModel copyWith({
    String? message,
    List<Data>? data,
  }) {
    return GetRolesModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// initial factory method
  factory GetRolesModel.initial() {
    return GetRolesModel(
      message: '',
      data: [],
    );
  }
}

class Data {
  int? id;
  String? roleName;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.roleName, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['role_name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['role_name'] = roleName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  /// copyWith method
  Data copyWith({
    int? id,
    String? roleName,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      roleName: roleName ?? this.roleName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// initial factory method
  factory Data.initial() {
    return Data(
      id: 0,
      roleName: '',
      createdAt: '',
      updatedAt: '',
    );
  }
}

class LanguagesModel {
  int? statusCode;
  bool? success;
  String? message;
  List<Data>? data;

  LanguagesModel({this.statusCode, this.success, this.message, this.data});

  factory LanguagesModel.initial() {
    return LanguagesModel(
      statusCode: 0,
      success: false,
      message: '',
      data: [],
    );
  }

  LanguagesModel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return LanguagesModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  LanguagesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
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
    final Map<String, dynamic> result = {};
    result['statusCode'] = statusCode;
    result['success'] = success;
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Data {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.name, this.createdAt, this.updatedAt});

  factory Data.initial() {
    return Data(
      id: 0,
      name: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  Data copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['name'] = name;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    return result;
  }
}

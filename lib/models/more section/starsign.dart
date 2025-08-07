class StartSignModel {
  int? statusCode;
  bool? success;
  String? message;
  List<Data>? data;

  StartSignModel({this.statusCode, this.success, this.message, this.data});

  factory StartSignModel.initial() {
    return StartSignModel(
      statusCode: 0,
      success: false,
      message: '',
      data: [],
    );
  }

  StartSignModel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return StartSignModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  StartSignModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = {};
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
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
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

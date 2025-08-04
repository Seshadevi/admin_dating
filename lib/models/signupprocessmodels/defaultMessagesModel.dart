class DefaultModel {
  bool? success;
  String? message;
  List<Data>? data;

  DefaultModel({this.success, this.message, this.data});

  /// Initial method
  factory DefaultModel.initial() {
    return DefaultModel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
  DefaultModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return DefaultModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  DefaultModel.fromJson(Map<String, dynamic> json) {
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
}

class Data {
  int? id;
  String? message;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.message, this.createdAt, this.updatedAt});

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      message: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? message,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

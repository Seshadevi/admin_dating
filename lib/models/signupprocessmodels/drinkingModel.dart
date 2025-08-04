class DrinkingModel {
  bool? success;
  String? message;
  List<Data>? data;

  DrinkingModel({this.success, this.message, this.data});

  /// Initial method
  factory DrinkingModel.initial() {
    return DrinkingModel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
  DrinkingModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return DrinkingModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  DrinkingModel.fromJson(Map<String, dynamic> json) {
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
  String? preference;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.preference,
    this.createdAt,
    this.updatedAt,
  });

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      preference: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? preference,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      preference: preference ?? this.preference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    preference = json['preference'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['preference'] = this.preference;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

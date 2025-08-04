class GenderModel {
  bool? success;
  String? message;
  List<Data>? data;

  GenderModel({this.success, this.message, this.data});

  /// Initial method
  factory GenderModel.initial() {
    return GenderModel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
  GenderModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return GenderModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  GenderModel.fromJson(Map<String, dynamic> json) {
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
  String? value;

  Data({this.id, this.value});

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      value: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? value,
  }) {
    return Data(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}

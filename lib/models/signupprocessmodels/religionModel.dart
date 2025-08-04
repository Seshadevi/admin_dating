class ReligionModel {
  bool? success;
  String? message;
  List<Data>? data;

  ReligionModel({this.success, this.message, this.data});

  ReligionModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> json = {};
    json['success'] = success;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }

  /// ✅ copyWith method
  ReligionModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return ReligionModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// ✅ initial method
  static ReligionModel initial() {
    return ReligionModel(
      success: false,
      message: '',
      data: [],
    );
  }
}

class Data {
  int? id;
  String? religion;

  Data({this.id, this.religion});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    religion = json['religion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['religion'] = religion;
    return json;
  }

  /// ✅ copyWith method
  Data copyWith({
    int? id,
    String? religion,
  }) {
    return Data(
      id: id ?? this.id,
      religion: religion ?? this.religion,
    );
  }

  /// ✅ initial method
  static Data initial() {
    return Data(
      id: 0,
      religion: '',
    );
  }
}

class ExperienceModel {
  bool? success;
  String? message;
  List<Data>? data;

  ExperienceModel({this.success, this.message, this.data});

  /// Factory constructor for initial/default values
  factory ExperienceModel.initial() {
    return ExperienceModel(
      success: false,
      message: '',
      data: [],
    );
  }

  ExperienceModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

  /// CopyWith method
  ExperienceModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return ExperienceModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? id;
  String? experience;

  Data({this.id, this.experience});

  /// Factory constructor for initial/default values
  factory Data.initial() {
    return Data(
      id: 0,
      experience: '',
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['experience'] = experience;
    return map;
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? experience,
  }) {
    return Data(
      id: id ?? this.id,
      experience: experience ?? this.experience,
    );
  }
}

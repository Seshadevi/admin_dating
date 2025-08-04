class InterestsModel {
  bool? success;
  String? message;
  List<Data>? data;

  InterestsModel({this.success, this.message, this.data});

  InterestsModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return InterestsModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  static InterestsModel initial() {
    return InterestsModel(
      success: false,
      message: '',
      data: [],
    );
  }

  InterestsModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? interests;

  Data({this.id, this.interests});

  Data copyWith({
    int? id,
    String? interests,
  }) {
    return Data(
      id: id ?? this.id,
      interests: interests ?? this.interests,
    );
  }

  static Data initial() {
    return Data(
      id: 0,
      interests: '',
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    interests = json['interests'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['interests'] = this.interests;
    return data;
  }
}

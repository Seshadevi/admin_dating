class KidsModel {
  bool? success;
  String? message;
  List<Data>? data;

  KidsModel({this.success, this.message, this.data});

  /// Initial method
  factory KidsModel.initial() {
    return KidsModel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
  KidsModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return KidsModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  KidsModel.fromJson(Map<String, dynamic> json) {
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
  String? kids;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.kids, this.createdAt, this.updatedAt});

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      kids: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? kids,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      kids: kids ?? this.kids,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kids = json['kids'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['kids'] = this.kids;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

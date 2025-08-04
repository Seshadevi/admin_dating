class CausesModel {
  bool? success;
  String? message;
  List<Data>? data;

  CausesModel({this.success, this.message, this.data});

  /// Initial method
  factory CausesModel.initial() {
    return CausesModel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
  CausesModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return CausesModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  CausesModel.fromJson(Map<String, dynamic> json) {
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
  String? causesAndCommunities;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.causesAndCommunities,
    this.createdAt,
    this.updatedAt,
  });

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      causesAndCommunities: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? causesAndCommunities,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      causesAndCommunities: causesAndCommunities ?? this.causesAndCommunities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    causesAndCommunities = json['causesAndCommunities'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['causesAndCommunities'] = this.causesAndCommunities;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

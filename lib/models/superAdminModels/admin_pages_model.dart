class AdminpagesModel {
  String? message;
  List<Data>? data;

  AdminpagesModel({this.message, this.data});

  AdminpagesModel.fromJson(Map<String, dynamic> json) {
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
    result['message'] = message;
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }

  /// copyWith method
  AdminpagesModel copyWith({
    String? message,
    List<Data>? data,
  }) {
    return AdminpagesModel(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// initial method
  factory AdminpagesModel.initial() {
    return AdminpagesModel(
      message: '',
      data: [],
    );
  }
}

class Data {
  int? id;
  String? pages;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.pages, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pages = json['pages'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['id'] = id;
    result['pages'] = pages;
    result['createdAt'] = createdAt;
    result['updatedAt'] = updatedAt;
    return result;
  }

  /// copyWith method
  Data copyWith({
    int? id,
    String? pages,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// initial method
  factory Data.initial() {
    return Data(
      id: 0,
      pages: '',
      createdAt: '',
      updatedAt: '',
    );
  }
}

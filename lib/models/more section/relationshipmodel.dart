class RelationshipModel {
  bool? success;
  String? message;
  List<Data>? data;

  RelationshipModel({this.success, this.message, this.data});

  /// Factory constructor for initial empty/default values
  factory RelationshipModel.initial() {
    return RelationshipModel(
      success: false,
      message: '',
      data: [],
    );
  }

  RelationshipModel.fromJson(Map<String, dynamic> json) {
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
  RelationshipModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return RelationshipModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? id;
  String? relation;

  Data({this.id, this.relation});

  /// Factory constructor for initial empty/default values
  factory Data.initial() {
    return Data(
      id: 0,
      relation: '',
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['relation'] = relation;
    return map;
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? relation,
  }) {
    return Data(
      id: id ?? this.id,
      relation: relation ?? this.relation,
    );
  }
}

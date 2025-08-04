import 'package:flutter/src/widgets/basic.dart';

class QualitiesModel {
  bool? success;
  String? message;
  List<Data>? data;

  QualitiesModel({this.success, this.message, this.data});

  /// Initial method
  factory QualitiesModel.initial() {
    return QualitiesModel(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
  QualitiesModel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return QualitiesModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  QualitiesModel.fromJson(Map<String, dynamic> json) {
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

  when({required Center Function() loading, required Center Function(dynamic e, dynamic _) error, required Padding Function(dynamic qualitiesModel) data}) {}
}

class Data {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.name, this.createdAt, this.updatedAt});

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      name: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

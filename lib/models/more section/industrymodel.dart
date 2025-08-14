class Industrymodel {
  bool? success;
  String? message;
  List<Data>? data;

  Industrymodel({this.success, this.message, this.data});

  /// Factory constructor for initial/default values
  factory Industrymodel.initial() {
    return Industrymodel(
      success: false,
      message: '',
      data: [],
    );
  }

  Industrymodel.fromJson(Map<String, dynamic> json) {
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
  Industrymodel copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Industrymodel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Data {
  int? id;
  String? industry;

  Data({this.id, this.industry});

  /// Factory constructor for initial/default values
  factory Data.initial() {
    return Data(
      id: 0,
      industry: '',
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    industry = json['industry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['industry'] = industry;
    return map;
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? industry,
  }) {
    return Data(
      id: id ?? this.id,
      industry: industry ?? this.industry,
    );
  }
}

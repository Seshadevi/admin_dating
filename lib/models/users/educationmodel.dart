class Educationmodel {
  int? statusCode;
  bool? success;
  String? message;
  List<Data>? data;

  Educationmodel({this.statusCode, this.success, this.message, this.data});

  factory Educationmodel.fromJson(Map<String, dynamic> json) {
    return Educationmodel(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
    };
  }

  /// CopyWith method
  Educationmodel copyWith({
    int? statusCode,
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return Educationmodel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  /// Initial method
  factory Educationmodel.initial() {
    return Educationmodel(
      statusCode: 0,
      success: false,
      message: '',
      data: [],
    );
  }
}

class Data {
  int? id;
  String? institution;
  int? gradYear;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.institution,
    this.gradYear,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      institution: json['institution'],
      gradYear: json['gradYear'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'gradYear': gradYear,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? institution,
    int? gradYear,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      institution: institution ?? this.institution,
      gradYear: gradYear ?? this.gradYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      institution: '',
      gradYear: 0,
      createdAt: '',
      updatedAt: '',
    );
  }
}

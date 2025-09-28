class Sportsmodel {
  final bool? success;
  final List<Data>? data;

  Sportsmodel({this.success, this.data});

  /// Initial empty state
  factory Sportsmodel.initial() {
    return Sportsmodel(
      success: false,
      data: const [],
    );
  }

  /// Create from JSON
  factory Sportsmodel.fromJson(Map<String, dynamic> json) {
    return Sportsmodel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List).map((v) => Data.fromJson(v)).toList()
          : [],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }

  /// CopyWith
  Sportsmodel copyWith({
    bool? success,
    List<Data>? data,
  }) {
    return Sportsmodel(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }
}

class Data {
  final int? id;
  final String? sportsTitle;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.sportsTitle,
    this.createdAt,
    this.updatedAt,
  });

  /// Initial empty state
  factory Data.initial() {
    return Data(
      id: 0,
      sportsTitle: '',
      createdAt: '',
      updatedAt: '',
    );
  }

  /// Create from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      sportsTitle: json['sports_title'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sports_title': sportsTitle,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// CopyWith
  Data copyWith({
    int? id,
    String? sportsTitle,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      sportsTitle: sportsTitle ?? this.sportsTitle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

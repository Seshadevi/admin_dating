class AdminFeatureModel {
  List<Data> data;

  AdminFeatureModel({required this.data});

  factory AdminFeatureModel.initial() {
    return AdminFeatureModel(data: []);
  }

  AdminFeatureModel copyWith({List<Data>? data}) {
    return AdminFeatureModel(
      data: data ?? this.data,
    );
  }

  factory AdminFeatureModel.fromJson(Map<String, dynamic> json) {
    return AdminFeatureModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Data {
  int id;
  String featureName;
  int count;
  bool isEnabled;
  String createdAt;
  String updatedAt;

  Data({
    required this.id,
    required this.featureName,
    required this.count,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.initial() {
    return Data(
      id: 0,
      featureName: '',
      count: 0,
      isEnabled: false,
      createdAt: '',
      updatedAt: '',
    );
  }

  Data copyWith({
    int? id,
    String? featureName,
    int? count,
    bool? isEnabled,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      featureName: featureName ?? this.featureName,
      count: count ?? this.count,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0,
      featureName: json['featureName'] ?? '',
      count: json['count'] ?? 0,
      isEnabled: json['isEnabled'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'featureName': featureName,
      'count': count,
      'isEnabled': isEnabled,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

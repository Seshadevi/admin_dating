class AdminFeatureModel {
  List<Data>? data;

  AdminFeatureModel({this.data});

  // Initial method
  factory AdminFeatureModel.initial() {
    return AdminFeatureModel(data: []);
  }

  // CopyWith method
  AdminFeatureModel copyWith({
    List<Data>? data,
  }) {
    return AdminFeatureModel(
      data: data ?? this.data,
    );
  }

  AdminFeatureModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? featureName;
  int? count;
  bool? isEnabled;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.featureName,
    this.count,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
  });

  // Initial method
  factory Data.initial() {
    return Data(
      id: 0,
      featureName: "",
      count: 0,
      isEnabled: false,
      createdAt: "",
      updatedAt: "",
    );
  }

  // CopyWith method
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    featureName = json['featureName'];
    count = json['count'];
    isEnabled = json['isEnabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['featureName'] = this.featureName;
    data['count'] = this.count;
    data['isEnabled'] = this.isEnabled;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

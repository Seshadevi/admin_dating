class FeatureplansModel {
  List<Data>? data;

  FeatureplansModel({this.data});

  // ✅ Initial factory
  factory FeatureplansModel.initial() {
    return FeatureplansModel(data: []);
  }

  // ✅ copyWith
  FeatureplansModel copyWith({
    List<Data>? data,
  }) {
    return FeatureplansModel(
      data: data ?? this.data,
    );
  }

  FeatureplansModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    if (data != null) {
      result['data'] = data!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Data {
  int? planTypeId;
  String? planName;
  String? description;
  List<Features>? features;

  Data({this.planTypeId, this.planName, this.description, this.features});

  // ✅ Initial factory
  factory Data.initial() {
    return Data(
      planTypeId: 0,
      planName: '',
      description: '',
      features: [],
    );
  }

  // ✅ copyWith
  Data copyWith({
    int? planTypeId,
    String? planName,
    String? description,
    List<Features>? features,
  }) {
    return Data(
      planTypeId: planTypeId ?? this.planTypeId,
      planName: planName ?? this.planName,
      description: description ?? this.description,
      features: features ?? this.features,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    planTypeId = json['planTypeId'];
    planName = json['planName'];
    description = json['description'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['planTypeId'] = planTypeId;
    result['planName'] = planName;
    result['description'] = description;
    if (features != null) {
      result['features'] = features!.map((v) => v.toJson()).toList();
    }
    return result;
  }
}

class Features {
  int? id;
  String? featureName;

  Features({this.id, this.featureName});

  // ✅ Initial factory
  factory Features.initial() {
    return Features(
      id: 0,
      featureName: '',
    );
  }

  // ✅ copyWith
  Features copyWith({
    int? id,
    String? featureName,
  }) {
    return Features(
      id: id ?? this.id,
      featureName: featureName ?? this.featureName,
    );
  }

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    featureName = json['featureName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};
    result['id'] = id;
    result['featureName'] = featureName;
    return result;
  }
}

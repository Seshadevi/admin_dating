class LookingFor {
  bool? success;
  String? message;
  List<Data>? data;

 LookingFor({this.success, this.message, this.data});

  /// Factory constructor for initial/default state
  factory LookingFor.initial() {
    return LookingFor(
      success: false,
      message: '',
      data: [],
    );
  }

  /// CopyWith method
 LookingFor copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return LookingFor(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

 LookingFor.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  get isLoading => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? value;

  Data({this.id, this.value});

  /// Factory constructor for initial/default state
  factory Data.initial() {
    return Data(
      id: 0,
      value: '',
    );
  }

  /// CopyWith method
  Data copyWith({
    int? id,
    String? value,
  }) {
    return Data(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }
}

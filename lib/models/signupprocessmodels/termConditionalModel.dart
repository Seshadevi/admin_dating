class TermsAndConditions {
  bool? success;
  String? message;
  List<Data>? data;

  TermsAndConditions({this.success, this.message, this.data});

  /// Initial factory method
  factory TermsAndConditions.initial() {
    return TermsAndConditions(
      success: false,
      message: '',
      data: [],
    );
  }

  /// copyWith method
  TermsAndConditions copyWith({
    bool? success,
    String? message,
    List<Data>? data,
  }) {
    return TermsAndConditions(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  TermsAndConditions.fromJson(Map<String, dynamic> json) {
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
  bool? value;

  Data({this.id, this.value});

  /// Initial factory method
  factory Data.initial() {
    return Data(
      id: 0,
      value: false,
    );
  }

  /// copyWith method
  Data copyWith({
    int? id,
    bool? value,
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

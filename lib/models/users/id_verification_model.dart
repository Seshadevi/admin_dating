class VerificationId {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  VerificationId({this.statusCode, this.success, this.messages, this.data});

  /// Static initial state (handy for providers)
  static VerificationId initial() => VerificationId(
        statusCode: 0,
        success: false,
        messages: const <String>[],
        data: const <Data>[],
      );

  /// Copy-with (override only what you pass)
  VerificationId copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return VerificationId(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  VerificationId.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages']?.cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<Verifications>? verifications;

  Data({this.verifications});

  /// Static initial
  static Data initial() => Data(
        verifications: const <Verifications>[],
      );

  /// Copy-with
  Data copyWith({
    List<Verifications>? verifications,
  }) {
    return Data(
      verifications: verifications ?? this.verifications,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    if (json['verifications'] != null) {
      verifications = <Verifications>[];
      json['verifications'].forEach((v) {
        verifications!.add(Verifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (verifications != null) {
      data['verifications'] = verifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verifications {
  int? id;
  int? userId;
  String? firstName;
  String? dob;
  bool? verified;
  String? status;
  Images? images;
  List<String>? userImages;

  Verifications({
    this.id,
    this.userId,
    this.firstName,
    this.dob,
    this.verified,
    this.status,
    this.images,
    this.userImages,
  });

  /// Static initial
  static Verifications initial() => Verifications(
        id: 0,
        userId: 0,
        firstName: '',
        dob: '',
        verified: false,
        status: '',
        images: Images.initial(),
        userImages: const <String>[],
      );

  /// Copy-with
  Verifications copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? dob,
    bool? verified,
    String? status,
    Images? images,
    List<String>? userImages,
  }) {
    return Verifications(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      dob: dob ?? this.dob,
      verified: verified ?? this.verified,
      status: status ?? this.status,
      images: images ?? this.images,
      userImages: userImages ?? this.userImages,
    );
  }

  Verifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    dob = json['dob'];
    verified = json['verified'];
    status = json['status'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;
    userImages = json['userImages']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['dob'] = dob;
    data['verified'] = verified;
    data['status'] = status;
    if (images != null) {
      data['images'] = images!.toJson();
    }
    data['userImages'] = userImages;
    return data;
  }
}

class Images {
  String? image1;
  String? image2;
  String? image3;

  Images({this.image1, this.image2, this.image3});

  /// Static initial
  static Images initial() => Images(
        image1: null,
        image2: null,
        image3: null,
      );

  /// Copy-with
  Images copyWith({
    String? image1,
    String? image2,
    String? image3,
  }) {
    return Images(
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
    );
  }

  Images.fromJson(Map<String, dynamic> json) {
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image1'] = image1;
    data['image2'] = image2;
    data['image3'] = image3;
    return data;
  }
}

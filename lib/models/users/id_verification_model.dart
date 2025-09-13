class VerificationId {
  int? id;
  int? userId;
  String? firstName;
  String? dob;
  bool? verified;
  Images? images;
  List<String>? userImages;

  // Sentinel to allow setting fields to null in copyWith
  static const Object _unset = Object();

  VerificationId({
    this.id,
    this.userId,
    this.firstName,
    this.dob,
    this.verified,
    this.images,
    this.userImages,
  });

  /// Convenient empty/initial instance
  factory VerificationId.initial() => VerificationId(
        id: null,
        userId: null,
        firstName: '',
        dob: '',
        verified: false,
        images: Images.initial(),
        userImages: <String>[],
      );

  /// Safe copyWith: pass only what you want to change.
  /// To set a value to null, pass `null` explicitly.
  VerificationId copyWith({
    Object? id = _unset,
    Object? userId = _unset,
    Object? firstName = _unset,
    Object? dob = _unset,
    Object? verified = _unset,
    Object? images = _unset,
    Object? userImages = _unset,
  }) {
    return VerificationId(
      id: identical(id, _unset) ? this.id : id as int?,
      userId: identical(userId, _unset) ? this.userId : userId as int?,
      firstName:
          identical(firstName, _unset) ? this.firstName : firstName as String?,
      dob: identical(dob, _unset) ? this.dob : dob as String?,
      verified:
          identical(verified, _unset) ? this.verified : verified as bool?,
      images: identical(images, _unset) ? this.images : images as Images?,
      userImages: identical(userImages, _unset)
          ? this.userImages
          : userImages as List<String>?,
    );
  }

  VerificationId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    firstName = json['firstName'];
    dob = json['dob'];
    verified = json['verified'];
    images = json['images'] != null ? Images.fromJson(json['images']) : null;

    final dynamic imgs = json['userImages'];
    if (imgs is List) {
      userImages = imgs.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    } else {
      userImages = <String>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['dob'] = dob;
    data['verified'] = verified;
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

  static const Object _unset = Object();

  Images({this.image1, this.image2, this.image3});

  /// Initial/empty instance
  factory Images.initial() => Images(image1: '', image2: '', image3: '');

  Images copyWith({
    Object? image1 = _unset,
    Object? image2 = _unset,
    Object? image3 = _unset,
  }) {
    return Images(
      image1: identical(image1, _unset) ? this.image1 : image1 as String?,
      image2: identical(image2, _unset) ? this.image2 : image2 as String?,
      image3: identical(image3, _unset) ? this.image3 : image3 as String?,
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

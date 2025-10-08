class LikedUsersModel {
  String? message;
  Pagination? pagination;
  List<Data>? data;

  LikedUsersModel({this.message, this.pagination, this.data});

  LikedUsersModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// Initial factory
  factory LikedUsersModel.initial() {
    return LikedUsersModel(
      message: "",
      pagination: Pagination.initial(),
      data: [],
    );
  }

  /// CopyWith
  LikedUsersModel copyWith({
    String? message,
    Pagination? pagination,
    List<Data>? data,
  }) {
    return LikedUsersModel(
      message: message ?? this.message,
      pagination: pagination ?? this.pagination,
      data: data ?? this.data,
    );
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? totalPages;

  Pagination({this.page, this.limit, this.total, this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['limit'] = limit;
    data['total'] = total;
    data['totalPages'] = totalPages;
    return data;
  }

  /// Initial factory
  factory Pagination.initial() {
    return Pagination(
      page: 0,
      limit: 0,
      total: 0,
      totalPages: 0,
    );
  }

  /// CopyWith
  Pagination copyWith({
    int? page,
    int? limit,
    int? total,
    int? totalPages,
  }) {
    return Pagination(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class Data {
  String? likedAt;
  int? userId;
  String? firstName;
  String? lastName; // changed from Null? to String?
  String? email;
  String? image;

  Data({
    this.likedAt,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
  });

  Data.fromJson(Map<String, dynamic> json) {
    likedAt = json['likedAt'];
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['likedAt'] = likedAt;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['image'] = image;
    return data;
  }

  /// Initial factory
  factory Data.initial() {
    return Data(
      likedAt: "",
      userId: 0,
      firstName: "",
      lastName: "",
      email: "",
      image: "",
    );
  }

  /// CopyWith
  Data copyWith({
    String? likedAt,
    int? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
  }) {
    return Data(
      likedAt: likedAt ?? this.likedAt,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }
}

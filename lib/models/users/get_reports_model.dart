class GetReportModel {
  int? total;
  int? limit;
  int? offset;
  List<Reports>? reports;

  GetReportModel({this.total, this.limit, this.offset, this.reports});

  GetReportModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['reports'] != null) {
      reports = <Reports>[];
      json['reports'].forEach((v) {
        reports!.add(Reports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.reports != null) {
      data['reports'] = this.reports!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// copyWith method
  GetReportModel copyWith({
    int? total,
    int? limit,
    int? offset,
    List<Reports>? reports,
  }) {
    return GetReportModel(
      total: total ?? this.total,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      reports: reports ?? this.reports,
    );
  }

  /// initial factory
  factory GetReportModel.initial() {
    return GetReportModel(
      total: 0,
      limit: 0,
      offset: 0,
      reports: [],
    );
  }
}

class Reports {
  int? id;
  int? userId;
  int? categoryId;
  String? description;
  String? createdAt;
  String? updatedAt;
  Reporter? reporter;
  Category? category;

  Reports({
    this.id,
    this.userId,
    this.categoryId,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.reporter,
    this.category,
  });

  Reports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    categoryId = json['categoryId'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    reporter =
        json['reporter'] != null ? Reporter.fromJson(json['reporter']) : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['categoryId'] = this.categoryId;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.reporter != null) {
      data['reporter'] = this.reporter!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }

  /// copyWith method
  Reports copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? description,
    String? createdAt,
    String? updatedAt,
    Reporter? reporter,
    Category? category,
  }) {
    return Reports(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reporter: reporter ?? this.reporter,
      category: category ?? this.category,
    );
  }

  /// initial factory
  factory Reports.initial() {
    return Reports(
      id: 0,
      userId: 0,
      categoryId: 0,
      description: '',
      createdAt: '',
      updatedAt: '',
      reporter: Reporter.initial(),
      category: Category.initial(),
    );
  }
}

class Reporter {
  int? id;
  String? username;
  String? firstName;
  String? email;

  Reporter({this.id, this.username, this.firstName, this.email});

  Reporter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['firstName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['username'] = this.username;
    data['firstName'] = this.firstName;
    data['email'] = this.email;
    return data;
  }

  /// copyWith method
  Reporter copyWith({
    int? id,
    String? username,
    String? firstName,
    String? email,
  }) {
    return Reporter(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
    );
  }

  /// initial factory
  factory Reporter.initial() {
    return Reporter(
      id: 0,
      username: '',
      firstName: '',
      email: '',
    );
  }
}

class Category {
  int? id;

  Category({this.id});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    return data;
  }

  /// copyWith method
  Category copyWith({int? id}) {
    return Category(
      id: id ?? this.id,
    );
  }

  /// initial factory
  factory Category.initial() {
    return Category(id: 0);
  }
}

class ReportCategoriesModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;
  Pagination? pagination;

  ReportCategoriesModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
    this.pagination,
  });

  ReportCategoriesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages']?.cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['statusCode'] = statusCode;
    json['success'] = success;
    json['messages'] = messages;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      json['pagination'] = pagination!.toJson();
    }
    return json;
  }

  /// copyWith
  ReportCategoriesModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
    Pagination? pagination,
  }) {
    return ReportCategoriesModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  /// initial
  factory ReportCategoriesModel.initial() {
    return ReportCategoriesModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
      pagination: Pagination.initial(),
    );
  }
}

class Data {
  int? id;
  String? category;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['id'] = id;
    json['category'] = category;
    json['createdAt'] = createdAt;
    json['updatedAt'] = updatedAt;
    return json;
  }

  /// copyWith
  Data copyWith({
    int? id,
    String? category,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// initial
  factory Data.initial() {
    return Data(
      id: 0,
      category: '',
      createdAt: '',
      updatedAt: '',
    );
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['total'] = total;
    json['page'] = page;
    json['limit'] = limit;
    json['totalPages'] = totalPages;
    return json;
  }

  /// copyWith
  Pagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return Pagination(
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  /// initial
  factory Pagination.initial() {
    return Pagination(
      total: 0,
      page: 1,
      limit: 10,
      totalPages: 0,
    );
  }
}

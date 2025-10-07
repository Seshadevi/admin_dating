class SubscriptionsModel {
  int? totalUsers;
  int? totalActivePurchases;
  int? usersWithPlans;
  int? percentageOfUsersWithActivePlan;
  List<TopPlans>? topPlans;
  List<AllPlans>? allPlans;

  SubscriptionsModel({
    this.totalUsers,
    this.totalActivePurchases,
    this.usersWithPlans,
    this.percentageOfUsersWithActivePlan,
    this.topPlans,
    this.allPlans,
  });

  SubscriptionsModel.fromJson(Map<String, dynamic> json) {
    totalUsers = json['totalUsers'];
    totalActivePurchases = json['totalActivePurchases'];
    usersWithPlans = json['usersWithPlans'];
    percentageOfUsersWithActivePlan = json['percentageOfUsersWithActivePlan'];
    if (json['topPlans'] != null) {
      topPlans = <TopPlans>[];
      json['topPlans'].forEach((v) {
        topPlans!.add(TopPlans.fromJson(v));
      });
    }
    if (json['allPlans'] != null) {
      allPlans = <AllPlans>[];
      json['allPlans'].forEach((v) {
        allPlans!.add(AllPlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['totalUsers'] = totalUsers;
    data['totalActivePurchases'] = totalActivePurchases;
    data['usersWithPlans'] = usersWithPlans;
    data['percentageOfUsersWithActivePlan'] = percentageOfUsersWithActivePlan;
    if (topPlans != null) {
      data['topPlans'] = topPlans!.map((v) => v.toJson()).toList();
    }
    if (allPlans != null) {
      data['allPlans'] = allPlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// copyWith
  SubscriptionsModel copyWith({
    int? totalUsers,
    int? totalActivePurchases,
    int? usersWithPlans,
    int? percentageOfUsersWithActivePlan,
    List<TopPlans>? topPlans,
    List<AllPlans>? allPlans,
  }) {
    return SubscriptionsModel(
      totalUsers: totalUsers ?? this.totalUsers,
      totalActivePurchases: totalActivePurchases ?? this.totalActivePurchases,
      usersWithPlans: usersWithPlans ?? this.usersWithPlans,
      percentageOfUsersWithActivePlan:
          percentageOfUsersWithActivePlan ?? this.percentageOfUsersWithActivePlan,
      topPlans: topPlans ?? this.topPlans,
      allPlans: allPlans ?? this.allPlans,
    );
  }

  /// initial
  factory SubscriptionsModel.initial() {
    return SubscriptionsModel(
      totalUsers: 0,
      totalActivePurchases: 0,
      usersWithPlans: 0,
      percentageOfUsersWithActivePlan: 0,
      topPlans: [],
      allPlans: [],
    );
  }
}

class TopPlans {
  int? planId;
  String? title;
  String? price;
  int? durationDays;
  dynamic time;
  PlanType? planType;
  int? purchaseCount;
  int? percentageOfPurchases;

  TopPlans({
    this.planId,
    this.title,
    this.price,
    this.durationDays,
    this.time,
    this.planType,
    this.purchaseCount,
    this.percentageOfPurchases,
  });

  TopPlans.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    title = json['title'];
    price = json['price'];
    durationDays = json['durationDays'];
    time = json['time'];
    planType =
        json['planType'] != null ? PlanType.fromJson(json['planType']) : null;
    purchaseCount = json['purchaseCount'];
    percentageOfPurchases = json['percentageOfPurchases'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['planId'] = planId;
    data['title'] = title;
    data['price'] = price;
    data['durationDays'] = durationDays;
    data['time'] = time;
    if (planType != null) {
      data['planType'] = planType!.toJson();
    }
    data['purchaseCount'] = purchaseCount;
    data['percentageOfPurchases'] = percentageOfPurchases;
    return data;
  }

  /// copyWith
  TopPlans copyWith({
    int? planId,
    String? title,
    String? price,
    int? durationDays,
    dynamic time,
    PlanType? planType,
    int? purchaseCount,
    int? percentageOfPurchases,
  }) {
    return TopPlans(
      planId: planId ?? this.planId,
      title: title ?? this.title,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      time: time ?? this.time,
      planType: planType ?? this.planType,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      percentageOfPurchases: percentageOfPurchases ?? this.percentageOfPurchases,
    );
  }

  /// initial
  factory TopPlans.initial() {
    return TopPlans(
      planId: 0,
      title: '',
      price: '',
      durationDays: 0,
      time: null,
      planType: PlanType.initial(),
      purchaseCount: 0,
      percentageOfPurchases: 0,
    );
  }
}

class AllPlans {
  int? planId;
  String? title;
  String? price;
  int? durationDays;
  dynamic time;
  PlanType? planType;
  int? purchaseCount;

  AllPlans({
    this.planId,
    this.title,
    this.price,
    this.durationDays,
    this.time,
    this.planType,
    this.purchaseCount,
  });

  AllPlans.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    title = json['title'];
    price = json['price'];
    durationDays = json['durationDays'];
    time = json['time'];
    planType =
        json['planType'] != null ? PlanType.fromJson(json['planType']) : null;
    purchaseCount = json['purchaseCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['planId'] = planId;
    data['title'] = title;
    data['price'] = price;
    data['durationDays'] = durationDays;
    data['time'] = time;
    if (planType != null) {
      data['planType'] = planType!.toJson();
    }
    data['purchaseCount'] = purchaseCount;
    return data;
  }

  /// copyWith
  AllPlans copyWith({
    int? planId,
    String? title,
    String? price,
    int? durationDays,
    dynamic time,
    PlanType? planType,
    int? purchaseCount,
  }) {
    return AllPlans(
      planId: planId ?? this.planId,
      title: title ?? this.title,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      time: time ?? this.time,
      planType: planType ?? this.planType,
      purchaseCount: purchaseCount ?? this.purchaseCount,
    );
  }

  /// initial
  factory AllPlans.initial() {
    return AllPlans(
      planId: 0,
      title: '',
      price: '',
      durationDays: 0,
      time: null,
      planType: PlanType.initial(),
      purchaseCount: 0,
    );
  }
}

class PlanType {
  int? id;
  String? name;
  String? description;

  PlanType({this.id, this.name, this.description});

  PlanType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }

  /// copyWith
  PlanType copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return PlanType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  /// initial
  factory PlanType.initial() {
    return PlanType(
      id: 0,
      name: '',
      description: '',
    );
  }
}

class Feature {
  final int id;
  final String featureName;

  Feature({required this.id, required this.featureName});

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    id: json['id'],
    featureName: json['featureName'],
  );
}

class PlanType {
  final int id;
  final String planName;
  final String description;
  final List<Feature> features;

  PlanType({
    required this.id,
    required this.planName,
    required this.description,
    required this.features,
  });

  factory PlanType.fromJson(Map<String, dynamic> json) => PlanType(
    id: json['id'],
    planName: json['planName'],
    description: json['description'],
    features: (json['features'] as List?)
        ?.map((e) => Feature.fromJson(e))
        .toList() ?? [],
  );
}

class FullPlan {
  final int id;
  final int typeId;
  final String title;
  final String price;
  final int? durationDays;
  final int? quantity;
  final PlanType planType;

  FullPlan({
    required this.id,
    required this.typeId,
    required this.title,
    required this.price,
    this.durationDays,
    this.quantity,
    required this.planType,
  });

  factory FullPlan.fromJson(Map<String, dynamic> json) => FullPlan(
    id: json['id'],
    typeId: json['typeId'],
    title: json['title'],
    price: json['price'],
    durationDays: json['durationDays'],
    quantity: json['quantity'],
    planType: PlanType.fromJson(json['planType']),
  );
}

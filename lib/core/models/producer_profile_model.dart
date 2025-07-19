class ProducerProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoPath;
  final String? description;
  final String? location;
  final String? farmingMethods;
  final List<Production> productions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProducerProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoPath,
    this.description,
    this.location,
    this.farmingMethods,
    this.productions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProducerProfile.fromJson(Map<String, dynamic> json) {
    return ProducerProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoPath: json['photo_path'],
      description: json['description'],
      location: json['location'],
      farmingMethods: json['farming_methods'],
      productions: (json['productions'] as List<dynamic>?)
              ?.map((p) => Production.fromJson(p))
              .toList() ??
          [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['created_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        json['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo_path': photoPath,
      'description': description,
      'location': location,
      'farming_methods': farmingMethods,
      'productions': productions.map((p) => p.toJson()).toList(),
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  ProducerProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoPath,
    String? description,
    String? location,
    String? farmingMethods,
    List<Production>? productions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProducerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
      description: description ?? this.description,
      location: location ?? this.location,
      farmingMethods: farmingMethods ?? this.farmingMethods,
      productions: productions ?? this.productions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Production {
  final String id;
  final String name;
  final String? season;
  final DateTime? plantingDate;
  final DateTime? harvestDate;
  final double? estimatedYield;
  final String? yieldUnit;
  final List<String> photos;
  final String? notes;
  final ProductionStatus status;

  Production({
    required this.id,
    required this.name,
    this.season,
    this.plantingDate,
    this.harvestDate,
    this.estimatedYield,
    this.yieldUnit,
    this.photos = const [],
    this.notes,
    this.status = ProductionStatus.active,
  });

  factory Production.fromJson(Map<String, dynamic> json) {
    return Production(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      season: json['season'],
      plantingDate: json['planting_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['planting_date'])
          : null,
      harvestDate: json['harvest_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['harvest_date'])
          : null,
      estimatedYield: json['estimated_yield']?.toDouble(),
      yieldUnit: json['yield_unit'],
      photos: (json['photos'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: json['notes'],
      status: ProductionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ProductionStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'season': season,
      'planting_date': plantingDate?.millisecondsSinceEpoch,
      'harvest_date': harvestDate?.millisecondsSinceEpoch,
      'estimated_yield': estimatedYield,
      'yield_unit': yieldUnit,
      'photos': photos,
      'notes': notes,
      'status': status.name,
    };
  }

  Production copyWith({
    String? id,
    String? name,
    String? season,
    DateTime? plantingDate,
    DateTime? harvestDate,
    double? estimatedYield,
    String? yieldUnit,
    List<String>? photos,
    String? notes,
    ProductionStatus? status,
  }) {
    return Production(
      id: id ?? this.id,
      name: name ?? this.name,
      season: season ?? this.season,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      estimatedYield: estimatedYield ?? this.estimatedYield,
      yieldUnit: yieldUnit ?? this.yieldUnit,
      photos: photos ?? this.photos,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}

enum ProductionStatus {
  planned,    // Planifiée
  active,     // En cours
  harvested,  // Récoltée
  archived,   // Archivée
}

extension ProductionStatusExtension on ProductionStatus {
  String get displayName {
    switch (this) {
      case ProductionStatus.planned:
        return 'Planifiée';
      case ProductionStatus.active:
        return 'En cours';
      case ProductionStatus.harvested:
        return 'Récoltée';
      case ProductionStatus.archived:
        return 'Archivée';
    }
  }

  String get icon {
    switch (this) {
      case ProductionStatus.planned:
        return '📅';
      case ProductionStatus.active:
        return '🌱';
      case ProductionStatus.harvested:
        return '🌾';
      case ProductionStatus.archived:
        return '📦';
    }
  }
}
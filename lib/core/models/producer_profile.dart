class ProductionItem {
  final String id;
  final String type;
  final String quantity;
  final String season;
  final ProductionStatus status;

  ProductionItem({
    required this.id,
    required this.type,
    required this.quantity,
    required this.season,
    required this.status,
  });

  factory ProductionItem.fromJson(Map<String, dynamic> json) {
    return ProductionItem(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      quantity: json['quantity'] ?? '',
      season: json['season'] ?? '',
      status: ProductionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProductionStatus.enStock,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'quantity': quantity,
      'season': season,
      'status': status.name,
    };
  }
}

enum ProductionStatus {
  enStock('En stock'),
  vendu('Vendu'),
  enCroissance('En croissance'),
  recolte('Récolte');

  const ProductionStatus(this.label);
  final String label;
}

class ProducerProfile {
  final String id;
  final String fullName;
  final String? profileImageUrl;
  final String description;
  final List<ProductionItem> productions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProducerProfile({
    required this.id,
    required this.fullName,
    this.profileImageUrl,
    required this.description,
    required this.productions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProducerProfile.fromJson(Map<String, dynamic> json) {
    return ProducerProfile(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImageUrl: json['profile_image_url'],
      description: json['description'] ?? '',
      productions: (json['productions'] as List<dynamic>?)
              ?.map((item) => ProductionItem.fromJson(item))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'description': description,
      'productions': productions.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ProducerProfile copyWith({
    String? id,
    String? fullName,
    String? profileImageUrl,
    String? description,
    List<ProductionItem>? productions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProducerProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      description: description ?? this.description,
      productions: productions ?? this.productions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
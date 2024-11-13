class DeliveryModel {
  DeliveryModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.price,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? phone;
  final int? price;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      price: json["price"],
      address: json["address"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "price": price,
        "address": address,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

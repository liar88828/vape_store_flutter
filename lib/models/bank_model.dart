class BankModel {
  BankModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.accounting,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  final String name;
  final String phone;
  final String address;
  final String accounting;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int id;

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      name: json["name"],
      phone: json["phone"],
      address: json["address"],
      accounting: json["accounting"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "address": address,
        "accounting": accounting,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}

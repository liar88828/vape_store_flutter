class TrolleyModel {
  final int? id;
  final int? id_checkout;
  final int id_product;
  final int id_user;
  final int qty;
  final DateTime? created_at;
  final DateTime? updated_at;

  TrolleyModel({
    required this.id,
    required this.id_checkout,
    required this.id_product,
    required this.id_user,
    required this.qty,
    required this.created_at,
    required this.updated_at,
  });

  factory TrolleyModel.fromJson(Map<String, dynamic> json) {
    return TrolleyModel(
      id: json['id'],
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      id_checkout:
          json['id_checkout'] != null ? int.parse(json['id_checkout']) : null,
      id_product: json['id_product'],
      id_user: json['id_user'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_checkout': id_checkout,
      'id_product': id_product,
      'id_user': id_user,
      'qty': qty,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }

  // Partial constructor
  factory TrolleyModel.create({
    required int id_product,
    required int id_user,
    required int qty,
    int? id,
    int? id_checkout,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return TrolleyModel(
      id: id,
      id_checkout: id_checkout,
      id_product: id_product,
      id_user: id_user,
      qty: qty,
      created_at: created_at,
      updated_at: updated_at,
    );
  }
  // Partial constructor
  factory TrolleyModel.update({
    required int id,
    required int id_product,
    required int id_user,
    required int qty,
    int? id_checkout,
    DateTime? created_at,
    DateTime? updated_at,
  }) {
    return TrolleyModel(
      id: id,
      id_checkout: id_checkout,
      id_product: id_product,
      id_user: id_user,
      qty: qty,
      created_at: created_at,
      updated_at: updated_at,
    );
  }
}

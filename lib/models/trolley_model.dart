// ignore_for_file: non_constant_identifier_names

class TrolleyModel {
  TrolleyModel({
    required this.id,
    required this.idCheckout,
    required this.idProduct,
    required this.trolleyIdUser,
    required this.idUser,
    required this.qty,
    required this.createdAt,
    required this.updatedAt,
    required this.idTrolley,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  final int? id;
  final dynamic idCheckout;
  final int idProduct;
  final int idUser;
  int qty;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int idTrolley;
  final String name;
  double price;
  final int? trolleyIdUser;
  final String? category;
  final String? description;

  factory TrolleyModel.fromJson(Map<String, dynamic> json) {
    return TrolleyModel(
      id: json["id"],
      idCheckout: json["id_checkout"],
      idProduct: json["id_product"],
      idUser: json["id_user"],
      trolleyIdUser: json["trolley_id_user"],
      qty: json["qty"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      idTrolley: json["id_trolley"],
      name: json["name"],
      price: json["price"],
      category: json["category"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_checkout": idCheckout,
        "id_product": idProduct,
        "id_user": idUser,
        "trolley_id_user": trolleyIdUser,
        "qty": qty,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "id_trolley": idTrolley,
        "name": name,
        "price": price,
        "category": category,
        "description": description,
      };
  // Partial constructor
  factory TrolleyModel.create({
    required int id_product,
    required int id_user,
    required int trolleyIdUser,
    required int qty,
    DateTime? created_at,
    DateTime? updated_at,
    int? id_checkout,
    int? id,
    required int idTrolley,
    required double price,
    String? category,
    String? description,
    required String name,
  }) {
    return TrolleyModel(
        trolleyIdUser: trolleyIdUser,
        id: id,
        qty: qty,
        category: category,
        createdAt: created_at,
        description: description,
        idCheckout: id_checkout,
        idProduct: id_product,
        idTrolley: idTrolley,
        idUser: id_user,
        name: name,
        price: price,
        updatedAt: updated_at);
  }
  // Partial constructor
  factory TrolleyModel.update({
    required int id_product,
    required int id_user,
    required int trolleyIdUser,
    required int qty,
    required double price,
    DateTime? created_at,
    DateTime? updated_at,
    int? id_checkout,
    int? id,
    required int idTrolley,
    String? category,
    String? description,
    required String name,
  }) {
    return TrolleyModel(
        id: id,
        trolleyIdUser: trolleyIdUser,
        qty: qty,
        category: category,
        createdAt: created_at,
        description: description,
        idCheckout: id_checkout,
        idProduct: id_product,
        idTrolley: idTrolley,
        idUser: id_user,
        name: name,
        price: price,
        updatedAt: updated_at);
  }
}

// ignore_for_file: non_constant_identifier_names

sealed class TrolleyData {}

class TrolleyModel extends TrolleyData {
  TrolleyModel({
    required this.id,
    required this.idCheckout,
    required this.idProduct,
    required this.trolleyIdUser,
    required this.idUser,
    required this.type,
    required this.qty,
    required this.trolleyQty,
    this.createdAt,
    this.updatedAt,
    required this.idTrolley,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
  });

  final int? id;
  final int idProduct;
  final int idUser;
  int qty;
  int trolleyQty;
  int? idCheckout;
  String? type;
  num price;
  final int idTrolley;
  final String name;
  final int trolleyIdUser;
  final String category;
  final String description;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TrolleyModel.fromJson(Map<String, dynamic> json) {
    return TrolleyModel(
      id: json["id"],
      type: json["type"],
      idCheckout: json["id_checkout"],
      idProduct: json["id_product"],
      idUser: json["id_user"],
      trolleyIdUser: json["trolley_id_user"],
      qty: json["qty"],
      trolleyQty: json["trolley_qty"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
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
        "trolley_qty": trolleyQty,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "id_trolley": idTrolley,
        "name": name,
        "price": price,
        "category": category,
        "description": description,
      };
}

class TrolleyCreate extends TrolleyData {
  final int id;
  final int qty;
  final int idProduct;
  final int idUser;
  final String type;

  TrolleyCreate({
    required this.id,
    required this.qty,
    required this.idProduct,
    required this.idUser,
    required this.type,
  });

  // Convert to JSON for network requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'id_product': idProduct,
      'id_user': idUser,
      'type': type,
    };
  }
}

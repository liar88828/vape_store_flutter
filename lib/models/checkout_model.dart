class CheckoutModel {
  CheckoutModel({
    this.id,
    required this.idUser,
    required this.total,
    required this.paymentMethod,
    required this.paymentPrice,
    required this.deliveryMethod,
    required this.deliveryPrice,
    // required this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int idUser;
  final num total;
  final String paymentMethod;
  final int paymentPrice;
  final String deliveryMethod;
  final num deliveryPrice;
  // DateTime? createdAt;
  DateTime? updatedAt;

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
      id: json["id"],
      idUser: json["id_user"],
      total: json["total"],
      paymentMethod: json["payment_method"],
      paymentPrice: json["payment_price"],
      deliveryMethod: json["delivery_method"],
      deliveryPrice: json["delivery_price"],
      // createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": idUser,
        "total": total,
        "payment_method": paymentMethod,
        "payment_price": paymentPrice,
        "delivery_method": deliveryMethod,
        "delivery_price": deliveryPrice,
        // "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class OrderInfoModel {
  OrderInfoModel({
    required this.subTotal,
    required this.shippingCost,
    required this.discount,
    required this.discountPrice,
    required this.total,
  });

  num subTotal;
  num shippingCost;
  num discount;
  num discountPrice;
  num total;
}

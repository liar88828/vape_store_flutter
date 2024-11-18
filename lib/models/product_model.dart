class ProductModel {
  final int? id;
  final String name;
  final int qty;
  final num price;
  final String brand;
  final String description;
  final int idUser;
  final int? idProduct;
  final String? img;

  // final String img;

  ProductModel({
    this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.brand,
    required this.description,
    required this.idUser,
    this.idProduct,
    this.img,
  });

  // Convert JSON to ProductModel object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      idUser: json['id_user'],
      idProduct: json['id_product'],
      name: json['name'],
      qty: json['qty'],
      brand: json['brand'],
      price: json['price'],
      description: json['description'],
      img: json['img'],
    );
  }

  // Convert ProductModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'brand': brand,
      'price': price,
      'description': description,
      'id_user': idUser,
      'id_product': idProduct,
      'img': img,
    };
  }
}

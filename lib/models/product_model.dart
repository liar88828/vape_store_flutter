class ProductModel {
  final int? id;
  final String name;
  final int qty;
  final int price;
  final String description;
  final int id_user;

  // final String img;

  ProductModel({
    this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.description,
    required this.id_user,
    // required this.img,
  });

  // Convert JSON to ProductModel object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      id_user: json['id_user'],
      name: json['name'],
      qty: json['qty'],
      price: json['price'],
      description: json['description'],
      // img: json['img'],
    );
  }

  // Convert ProductModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'price': price,
      'description': description,
      'id_user': id_user,
      // 'img': img,
    };
  }
}


// class ProductModel {
//   final String title;
//   final DateTime date;
//   final String img;
//   final int price;
//   final int id;

//   ProductModel({
//     required this.img,
//     required this.title,
//     required this.date,
//     required this.price,
//     required this.id,
//   });
// }

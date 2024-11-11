class FavoriteModel {
  final int? id;
  final int id_user;
  // final int id_product;
  final String title;
  final String description;
  // final String img;
  // final int item;

  FavoriteModel({
    required this.id,
    required this.id_user,
    // required this.id_product,
    required this.title,
    required this.description,
    // required this.img,
    // required this.item,
  });

// convert JSON to model object
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      id_user: json['id_user'],
      // id_product: json['id_product'],
      title: json['title'],
      description: json['description'],
      // img: json['img'],
      // item: json['item'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': id_user,
      // 'id_product': id_product,
      'title': title,
      'description': description,
      // 'img':img,
      // 'item':item,
    };
  }
}

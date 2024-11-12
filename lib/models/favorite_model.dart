class FavoriteModel {
  final int? id;
  final int idUser;
  // final int id_product;
  final String title;
  final String description;
  // final String img;
  // final int item;

  FavoriteModel({
    required this.id,
    required this.idUser,
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
      idUser: json['id_user'],
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
      'id_user': idUser,
      // 'id_product': id_product,
      'title': title,
      'description': description,
      // 'img':img,
      // 'item':item,
    };
  }
}

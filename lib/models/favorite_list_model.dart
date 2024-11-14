class FavoriteListModel {
  int? favoriteListsId;
  int? idFavorite;
  int? idProduct;
  String? createdAt;
  String? updatedAt;
  int? productId;
  int? idUser;
  String? name;
  int? qty;
  int? price;
  String? description;

  FavoriteListModel({
    this.favoriteListsId,
    this.idFavorite,
    this.idProduct,
    this.createdAt,
    this.updatedAt,
    this.productId,
    this.idUser,
    this.name,
    this.qty,
    this.price,
    this.description,
  });

  FavoriteListModel.fromJson(Map<String, dynamic> json) {
    favoriteListsId = json['favorite_lists_id'];
    idFavorite = json['id_favorite'];
    idProduct = json['id_product'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productId = json['product_id'];
    idUser = json['id_user'];
    name = json['name'];
    qty = json['qty'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['favorite_lists_id'] = favoriteListsId;
    data['id_favorite'] = idFavorite;
    data['id_product'] = idProduct;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_id'] = productId;
    data['id_user'] = idUser;
    data['name'] = name;
    data['qty'] = qty;
    data['price'] = price;
    data['description'] = description;
    return data;
  }
}

class FavoriteListCreate {
  int? idFavorite;
  int? idProduct;
  // int? idUser;

  FavoriteListCreate({
    this.idFavorite,
    this.idProduct,
    // this.idUser,
  });

  FavoriteListCreate.fromJson(Map<String, dynamic> json) {
    idFavorite = json['id_favorite'];
    idProduct = json['id_product'];
    // idUser = json['id_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_favorite'] = idFavorite;
    data['id_product'] = idProduct;
    // data['id_user'] = idUser;
    return data;
  }
}

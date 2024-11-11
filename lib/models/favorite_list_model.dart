class FavoriteListModel {
  int? favorite_lists_id;
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

  FavoriteListModel(
      {this.favorite_lists_id,
      this.idFavorite,
      this.idProduct,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.idUser,
      this.name,
      this.qty,
      this.price,
      this.description});

  FavoriteListModel.fromJson(Map<String, dynamic> json) {
    favorite_lists_id = json['favorite_lists_id'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['favorite_lists_id'] = this.favorite_lists_id;
    data['id_favorite'] = this.idFavorite;
    data['id_product'] = this.idProduct;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_id'] = this.productId;
    data['id_user'] = this.idUser;
    data['name'] = this.name;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }
}

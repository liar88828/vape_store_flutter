class ProductModel {
  final String title;
  final DateTime date;
  final int price;
  final int id;
  final String img;

  ProductModel({
    required this.img,
    required this.title,
    required this.date,
    required this.price,
    required this.id,
  });
}

import 'package:vape_store/models/product_model.dart';

final List<ProductModel> productExample = [
  ProductModel(
      brand: 'Vape Rasa',

      // date: DateTime.now(),
      name: 'Vape Rasa Melon',
      price: 200000,
      id: 1,
      idUser: 1,
      // img: 'lib/images/banner1.png',
      description: 'Vape Rasa Melon',
      category: '',
      qty: 1),
  ProductModel(
      // date: DateTime.now(),
      brand: 'Vape Rasa',
      name: 'Vape Rasa Anggur',
      price: 200000,
      id: 2,
      idUser: 1,
      category: '',
      description: 'Vape Rasa Anggur',
      qty: 1
      // img: 'lib/images/banner1.png',
      ),
  ProductModel(
      brand: 'Vape Rasa',
      category: '',
      // date: DateTime.now(),
      name: 'Vape Rasa strawberry',
      description: 'is description',
      price: 200000,
      id: 3,
      idUser: 1,
      qty: 1
      // img: 'lib/images/banner1.png',
      ),
  ProductModel(
    // date: DateTime.now(),
    brand: 'Vape Rasa',
    name: 'Vape Rasa pisang',
    price: 200000,
    category: '',

    id: 4,
    idUser: 1,
    description: 'is description',
    qty: 1,
    // img: 'lib/images/banner1.png',
  ),
];

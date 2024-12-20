import 'package:vape_store/models/trolley_model.dart';

final List<TrolleyModel> cartItems = [
  TrolleyModel(
    trolleyQty: 1,
    id: 1,
    idCheckout: 101,
    idProduct: 1001,
    trolleyIdUser: 2001,
    idUser: 3001,
    // qty: 2,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    idTrolley: 4001,
    name: "Product 1",
    price: 25.0,
    category: "Electronics",
    description: "This is a great electronic product.",
    type: '30 ML',
  ),
  TrolleyModel(
    trolleyQty: 1,
    type: '30 ML',
    id: 3,
    idCheckout: 103,
    idProduct: 1003,
    trolleyIdUser: 2003,
    idUser: 3003,
    // qty: 3,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    idTrolley: 4003,
    name: "Product 3",
    price: 10.0,
    category: "Clothing",
    description: "Comfortable and stylish clothing.",
  ),
];

part of 'product_bloc.dart';

sealed class ProductState {
  String type;
  int counter;
  // List<ProductModel>? products;
  ProductModel? product;

  ProductState({
    this.type = '',
    this.counter = 1,
    this.product,
  });
}

final class ProductInitial extends ProductState {
  ProductInitial({
    super.type = '',
    super.counter = 1,
    super.product,
  });
}

final class ProductLoadsState extends ProductState {
  // @override
  final List<ProductModel> products;
  ProductLoadsState({required this.products}) //: super(products: products)
  ;
}

final class ProductNewState extends ProductState {
  // @override
  final List<ProductModel> products;
  ProductNewState({required this.products}) //: super(products: products)
  ;
}

final class ProductLoadState extends ProductState {
  @override
  final ProductModel product;
  ProductLoadState({required this.product}) : super(product: product);
}

final class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState({required this.message});
}

final class ProductErrorMessageState extends ProductState {
  final String message;
  ProductErrorMessageState({required this.message});
}

final class ProductLoadingState extends ProductState {}

// final class ProductTypeState extends ProductState {
//   ProductTypeState({required super.type, required super.counter});
// }

// final class ProductCounterState extends ProductState {
//   @override
//   ProductCounterState({required super.counter, required super.type});
// }

final class ProductGoCheckoutScreenState extends ProductState {
  final ProductModel product;
  final int counter;
  final String type;
  final UserModel user;
  ProductGoCheckoutScreenState({
    required this.counter,
    required this.product,
    required this.type,
    required this.user,
  });
}

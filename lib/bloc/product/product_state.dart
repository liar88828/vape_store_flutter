part of 'product_bloc.dart';

sealed class ProductState {
  String type;
  // List<ProductModel>? products;
  ProductModel? product;

  ProductState({
    this.type = '',
    this.product,
    // this.product,
  });
}

final class ProductInitial extends ProductState {
  // final String type;
  // final ProductModel? product;
  // ProductInitial({this.type = '', this.product}) : super(product: product, type: type);
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

final class ProductLoadingState extends ProductState {}

final class ProductTypeState extends ProductState {
  @override
  final String type;
  ProductTypeState({required this.type}) : super(type: type);
}

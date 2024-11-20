part of 'product_bloc.dart';

sealed class ProductState {
  String type;
  List<ProductModel>? products;
  ProductModel? product;

  ProductState({
    this.type = '',
    this.products,
    this.product,
  });
}

final class ProductInitial extends ProductState {}

final class ProductManyLoadState extends ProductState {
  final List<ProductModel> products;
  ProductManyLoadState({required this.products});
}

final class ProductSingleLoadState extends ProductState {
  final ProductModel product;
  ProductSingleLoadState({required this.product});
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

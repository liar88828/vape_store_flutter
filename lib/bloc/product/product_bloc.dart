import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/network/product_network.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductNetwork productRepository;
  ProductBloc({
    required this.productRepository,
  }) : super(ProductInitial()) {
    on<ProductAllEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final products = await productRepository.fetchProducts();
        emit(ProductManyLoadState(products: products));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });

    on<ProductDetailEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final product = await productRepository.fetchProductById(event.id);
        emit(ProductSingleLoadState(product: product));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });

    on<ProductTypeEvent>((event, emit) {
      emit(ProductTypeState(type: event.type));
    });
  }
}

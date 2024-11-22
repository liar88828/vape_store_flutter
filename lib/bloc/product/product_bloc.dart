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
        emit(ProductLoadsState(products: products));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });

    on<ProductDetailEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        print('load 1 time');
        final product = await productRepository.fetchProductById(event.id);
        emit(ProductLoadState(product: product));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });

    on<ProductTypeEvent>((event, emit) {
      if (state.type != event.type) {
        emit(ProductTypeState(type: event.type));
      }
    });

    on<ProductFilterEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final products = await productRepository.fetchProducts(category: event.category, name: event.name, order: event.order);
        emit(ProductLoadsState(products: products));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });

    on<ProductSearchEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final products = await productRepository.fetchProducts(name: event.search);
        emit(ProductLoadsState(products: products));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });

    on<ProductNewEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        final products = await productRepository.fetchProductsNewProduct();
        emit(ProductNewState(products: products));
      } catch (e) {
        emit(ProductErrorState(message: "Product Error Load ${e.toString()}"));
      }
    });
  }
}

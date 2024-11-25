import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/product_network.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductNetwork productRepository;
  final Future<UserModel> session;
  ProductBloc({
    required this.productRepository,
    required this.session,
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
        emit(ProductInitial(
          type: event.type,
          counter: state.counter,
          product: state.product,
        ));
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

    on<ProductCounterIncrementEvent>((event, emit) {
      var counter = state.counter;
      counter++;
      // ProductCounterState
      emit(ProductInitial(
        counter: counter,
        type: state.type,
        product: state.product,
      ));
    });

    on<ProductCounterDecrementEvent>((event, emit) {
      var counter = state.counter;
      counter--;
      if (counter > 0) {
        // ProductTypeState
        emit(ProductInitial(
          counter: counter,
          type: state.type,
          product: state.product,
        ));
      }
    });

    on<ProductAddCheckoutEvent>((event, emit) async {
      try {
        final product = state.product;
        if (state.counter <= 0) {
          // throw Exception('The product is out of stock');
          throw Exception('The product must be greater than 0');
        } else if (product == null) {
          throw Exception('The product is not found');
        } else if (state.type.isEmpty) {
          throw Exception('Please Add Type');
        } else {
          var user = await session;
          emit(ProductGoCheckoutScreenState(
            counter: state.counter,
            product: product,
            type: state.type,
            user: user,
          ));
        }
      } catch (e) {
        emit(ProductErrorMessageState(message: e.toString()));
      }
    });
  }
}

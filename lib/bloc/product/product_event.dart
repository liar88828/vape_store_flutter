part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

final class ProductFavoriteEvent extends ProductEvent {
  final int id;
  ProductFavoriteEvent({required this.id});
}

final class ProductAllEvent extends ProductEvent {
  ProductAllEvent();
}

final class ProductDetailEvent extends ProductEvent {
  final int id;
  ProductDetailEvent({required this.id});
}

final class ProductTypeEvent extends ProductEvent {
  final String type;
  ProductTypeEvent({required this.type});
}

final class ProductCounterIncrementEvent extends ProductEvent {}

final class ProductCounterDecrementEvent extends ProductEvent {}

final class ProductSearchEvent extends ProductEvent {
  final String search;
  ProductSearchEvent({required this.search});
}

final class ProductFilterEvent extends ProductEvent {
  final String? category, name, order;
  ProductFilterEvent({
    this.category,
    this.name,
    this.order,
  });
}

final class ProductNewEvent extends ProductEvent {}

final class ProductAddCheckoutEvent extends ProductEvent {}

// final class ProductOrderEvent extends ProductEvent {
//   final String order;
//   ProductOrderEvent({required this.order});
// }

// final class ProductDetailEvent extends ProductEvent {
//   final int id;
//   ProductDetailEvent({required this.id});
// }


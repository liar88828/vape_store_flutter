import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vape_store/models/bank_model.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/delivery_model.dart';
import 'package:vape_store/models/response_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/checkout_network.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CheckoutNetwork checkoutRepository;
  final Future<UserModel> session;
  OrderBloc({
    required this.checkoutRepository,
    required this.session,
  }) : super(const OrderInitial()) {
    on<CheckoutLoadsEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      try {
        final user = await session;
        final checkouts = await checkoutRepository.fetchAll(user.id);
        emit(CheckoutLoadsState(checkouts: checkouts));
      } catch (e) {
        CheckoutErrorState(message: e.toString());
      }
    });

    on<CheckoutDetailEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      try {
        final checkout = await checkoutRepository.fetchId(idCheckout: event.idCheckout);
        emit(CheckoutLoadState(checkout: checkout));
      } catch (e) {
        CheckoutErrorState(message: e.toString());
      }
    });

    on<OrderCalculateEvent>((event, emit) {
      // emit(OrderLoadingState());
      // emit(OrderInitial());
    });
    on<OrderRemoveProductEvent>((event, emit) {
      final product = state.productTrolleyData;
      product.removeWhere((item) => item.idProduct == event.id);
      emit(OrderInitial(
        productTrolleyData: product,
        bankData: state.bankData,
        deliveryData: state.deliveryData,
        totalAll: setOrderInfo(trolley: product),
      ));
    });

    on<OrderAddProductEvent>((event, emit) {
      // print('is event');
      // print(event.productTrolley.last.name);
      // print('is event');
      emit(OrderInitial(
        productTrolleyData: event.productTrolley,
        bankData: state.bankData,
        deliveryData: state.deliveryData,
        // totalAll: setOrderInfo(),
      ));
    });

    on<OrderAddBankEvent>((event, emit) {
      // print(state.deliveryData?.name);
      // print(state.bankData?.name);
      emit(OrderInitial(
        productTrolleyData: state.productTrolleyData,
        bankData: event.bankData,
        deliveryData: state.deliveryData,
        totalAll: setOrderInfo(),
      ));
    });

    on<OrderAddDeliveryEvent>((event, emit) {
      emit(OrderInitial(
        productTrolleyData: state.productTrolleyData,
        bankData: state.bankData,
        deliveryData: event.deliveryData,
        totalAll: setOrderInfo(),
      ));
    });

    on<CheckoutCreateManyEvent>((event, emit) async {
      if (state.bankData == null) {
        emit(CheckoutErrorState(message: 'Please select bank'));
      } else if (state.deliveryData == null) {
        emit(CheckoutErrorState(message: 'Please select delivery'));
      } else {
        try {
          final user = await session;
          var idTrolley = setIdTrolley();
          var totalCheckout = setCheckout(user);
          print('id trolley is $idTrolley');
          print('id trolley is ${totalCheckout.toJson()}');
          if (idTrolley.length > 1) {
            final ResponseModel<CheckoutModel> response = await checkoutRepository.createManyCheckout(
              checkout: totalCheckout,
              idTrolley: idTrolley,
              user: user,
            );
            if (response.success) {
              emit(CheckoutLoadState(checkout: response.data!));
            } else {
              throw Exception(response.message);
            }
          } else if (idTrolley.length == 1) {
            final response = await checkoutRepository.createSingleCheckout(
              checkout: totalCheckout,
              product: state.productTrolleyData.first,
              user: user,
            );
            if (response.success) {
              emit(CheckoutLoadState(checkout: response.data!));
            } else {
              throw Exception(response.message);
            }
          } else {
            print('Trolley is empty');
            throw Exception("Trolley is empty");
          }
        } catch (e) {
          emit(CheckoutErrorState(message: e.toString()));
        }
      }
    });
  }

  List<int> setIdTrolley() => state.productTrolleyData.map((d) => d.idTrolley).toList();
  CheckoutModel setCheckout(UserModel user) {
    return CheckoutModel(
      idUser: user.id,
      total: calculateTotal(
        state.productTrolleyData,
        state.deliveryData!.price,
      ),
      deliveryMethod: state.deliveryData!.name,
      paymentMethod: state.bankData!.name,
      paymentPrice: 100,
      deliveryPrice: state.deliveryData!.price,
    );
  }

  num calculateTotal(List<TrolleyModel> trolley, num initial) {
    return trolley.fold(
      initial,
      (value, element) => value + (element.trolleyQty * element.price),
    );
  }

  OrderInfoModel setOrderInfo({List<TrolleyModel>? trolley}) {
    final deliveryData = state.deliveryData;
    // final trolley = state.productTrolleyData;
    final trolleyData = trolley ?? state.productTrolleyData;
    final subtotal = calculateTotal(trolleyData, 0);

    num shippingPrice = deliveryData?.price ?? 0;

    // Add shipping cost to subtotal
    final totalBeforeDiscount = subtotal + shippingPrice;

    // Define discount as a percentage (e.g., 10%)
    const discountPercentage = 10;
    num discount = (totalBeforeDiscount * discountPercentage) / 100;

    // Calculate the total after applying the discount
    final afterDiscount = totalBeforeDiscount - discount;

    return OrderInfoModel(
      subTotal: subtotal,
      shippingCost: shippingPrice,
      discount: discountPercentage,
      discountPrice: discount,
      total: afterDiscount,
    );
  }
}

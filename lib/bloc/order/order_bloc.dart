import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vape_store/models/bank_model.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/delivery_model.dart';
import 'package:vape_store/models/trolley_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<CalculateOrderInfo>(_onCalculateOrderInfo);
    on<RemoveTrolleyItem>(_onRemoveTrolleyItem);
  }

  void _onCalculateOrderInfo(CalculateOrderInfo event, Emitter<OrderState> emit) {
    // Calculate subtotal
    final subtotal = event.trolley.fold<num>(
      0,
      (value, item) => value + (item.trolleyQty * item.price),
    );

    // Calculate shipping cost
    final shippingPrice = event.deliveryData.price;

    // Calculate total before discount
    final totalBeforeDiscount = subtotal + shippingPrice;

    // Calculate discount
    const discountPercentage = 10;
    final discount = (totalBeforeDiscount * discountPercentage) / 100;

    // Calculate final total
    final afterDiscount = totalBeforeDiscount - discount;

    // Create the updated order info model
    final orderInfo = OrderInfoModel(
      subTotal: subtotal,
      shippingCost: shippingPrice,
      discount: discountPercentage,
      discountPrice: discount,
      total: afterDiscount,
    );

    emit(OrderUpdated(orderInfo));
  }

  void _onRemoveTrolleyItem(RemoveTrolleyItem event, Emitter<OrderState> emit) {
    // This event can be enhanced to update the trolley list and recalculate.
  }
}

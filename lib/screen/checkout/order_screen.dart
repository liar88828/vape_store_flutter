import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/bank/bank_bloc.dart';
import 'package:vape_store/bloc/delivery/delivery_bloc.dart';
import 'package:vape_store/bloc/order/order_bloc.dart';
import 'package:vape_store/models/bank_model.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/delivery_model.dart';
import 'package:vape_store/models/trolley_model.dart';
import 'package:vape_store/screen/checkout/detail_checkout_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/utils/text.dart';

class OrderScreen extends StatefulWidget {
  final List<TrolleyModel>? productTrolley;
  const OrderScreen({super.key, required this.productTrolley});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void _removeData(int id) => context.read<OrderBloc>().add(OrderRemoveProductEvent(id));

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(OrderAddProductEvent(widget.productTrolley ?? []));
    final colorTheme = Theme.of(context).colorScheme;

    void createCheckout() => context.read<OrderBloc>().add(CheckoutCreateManyEvent());

    void goTrolleyScreen(BuildContext context) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const TrolleyScreen();
      }));
    }

    void unSelectBankHandler() {
      context.read<OrderBloc>().add(OrderAddBankEvent(bankData: null));
      Navigator.pop(context); // Close the dialog after selection
    }

    void selectBankHandler(BankModel data) {
      context.read<OrderBloc>().add(OrderAddBankEvent(bankData: data));
      Navigator.pop(context); // Close the dialog after selection
    }

    void unSelectDeliveryHandler() {
      context.read<OrderBloc>().add(OrderAddDeliveryEvent(deliveryData: null));
      Navigator.pop(context); // Close the dialog after selection
    }

    void selectDeliveryHandler(DeliveryModel data) {
      context.read<OrderBloc>().add(OrderAddDeliveryEvent(deliveryData: data));
      Navigator.pop(context); // Close the dialog after selection
    }

    // print(productModel.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text('Order Screen'),
        leading: BackButton(onPressed: () => goTrolleyScreen(context)),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
          style: FilledButton.styleFrom(
            fixedSize: const Size(240, 100),
            backgroundColor: colorTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => createCheckout(),
          child: BlocSelector<OrderBloc, OrderState, num>(
            selector: (state) {
              return state.totalAll?.total ?? 0;
            },
            builder: (context, stateTotalAll) {
              return Text('CHECKOUT ${formatPrice(stateTotalAll)}');
            },
          ),
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, stateConsumerListener) {
          if (stateConsumerListener is CheckoutErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(stateConsumerListener.message)));
          }

          if (stateConsumerListener is CheckoutLoadState) {
            // print('will go to detail checkout');

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailCheckoutScreen(
                    checkout: stateConsumerListener.checkout,
                    idCheckout: stateConsumerListener.checkout.id,
                  ),
                ));
          }
        },
        buildWhen: (previous, current) {
          if (previous is OrderInitial && current is OrderInitial) return true;
          return false;
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                listCheckout(
                  colorTheme: colorTheme,
                  text: 'My Location',
                  onClick: () {},
                  subtitle: 'Jl Simongan 63 RT 005/008',
                  title: 'Jl Kedungjati 12, Jawa Tengah',
                  icon: Icons.payment,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Cart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colorTheme.primary,
                        )),
                    Column(
                      children: widget.productTrolley == null
                          ? [const Text('Data is null')]
                          : widget.productTrolley!.map((product) {
                              return trolleyProductCard(
                                colorTheme: colorTheme,
                                product: product,
                              );
                            }).toList(),
                    )
                  ],
                ),

                // ---------

                BlocSelector<OrderBloc, OrderState, DeliveryModel?>(
                  selector: (stateOrder) => stateOrder.deliveryData,
                  builder: (context, stateDeliveryData) {
                    final delivery = stateDeliveryData;
                    return listCheckout(
                      colorTheme: colorTheme,
                      text: 'Delivery',
                      subtitle: delivery?.price != null ? formatPrice(delivery?.price ?? 0) : null,
                      title: delivery?.name,
                      icon: Icons.delivery_dining,
                      onClick: () async {
                        context.read<DeliveryBloc>().add(DeliveryLoadsEvent());
                        await showDialog(
                          context: context,
                          // barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text('Delivery Method'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  delivery != null
                                      ? Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              // tileColor: colorTheme.primaryContainer,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(delivery.name),
                                              subtitle: Text(formatPrice(delivery.price)),
                                              trailing: IconButton(
                                                onPressed: () => unSelectDeliveryHandler(),
                                                icon: const Icon(Icons.check_box),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Text('Please Select Delivery Method'),
                                  BlocBuilder<DeliveryBloc, DeliveryState>(builder: (context, stateDelivery) {
                                    if (stateDelivery is DeliveryLoadingState) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (stateDelivery is DeliveryErrorState) {
                                      return Center(child: Text(stateDelivery.message));
                                    } else if (stateDelivery is DeliveryLoadsState) {
                                      return Column(
                                        children: stateDelivery.deliverys
                                            // .where(
                                            //   (data) {
                                            //     return data.id != deliveryData?.id;
                                            //   }
                                            // )
                                            .map((data) {
                                          return ListTile(
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(data.name),
                                            subtitle: Text(formatPrice(data.price)),
                                            trailing: IconButton(
                                              onPressed: () => selectDeliveryHandler(data),
                                              icon: const Icon(Icons.check_box_outline_blank),
                                            ),
                                          );
                                        }).toList(), // Convert to a list of widgets
                                      );
                                    } else {
                                      return const Center(child: Text('No data available'));
                                    }
                                  }),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                // ---------
                BlocSelector<OrderBloc, OrderState, BankModel?>(
                  selector: (stateOrder) => stateOrder.bankData,
                  builder: (context, stateBank) {
                    final bank = stateBank;
                    return listCheckout(
                      colorTheme: colorTheme,
                      text: 'Payment Method',
                      title: bank?.name,
                      subtitle: bank?.accounting,
                      icon: Icons.money,
                      onClick: () async {
                        context.read<BankBloc>().add(BankLoadsEvent());
                        await showDialog(
                          context: context,
                          // barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: const Text('Payment Method'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  stateBank != null
                                      ? Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(bank!.name),
                                              subtitle: Text(bank.accounting),
                                              trailing: IconButton(
                                                onPressed: () => unSelectBankHandler(),
                                                icon: const Icon(Icons.check_box),
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Text('Please Select Payment Method'),
                                  BlocBuilder<BankBloc, BankState>(
                                    builder: (context, state) {
                                      if (state is BankLoadingState) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (state is BankErrorState) {
                                        return const Center(child: Text('Error fetching data'));
                                      } else if (state is BankLoadsState) {
                                        return Column(
                                          children: state.banks.map((data) {
                                            return ListTile(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(data.name),
                                              subtitle: Text(data.accounting),
                                              trailing: IconButton(
                                                onPressed: () => selectBankHandler(data),
                                                icon: const Icon(Icons.check_box_outline_blank),
                                              ),
                                            );
                                          }).toList(), // Convert to a list of widgets
                                        );
                                      } else {
                                        return const Center(child: Text('No data available'));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocSelector<OrderBloc, OrderState, OrderInfoModel?>(
                  selector: (stateSelector) {
                    return stateSelector.totalAll;
                  },
                  builder: (context, stateSelectorAll) {
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('Order Info',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorTheme.primary,
                            )),
                      ]),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal : ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                          Text(
                            formatPrice(stateSelectorAll?.subTotal ?? 0),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: widget.productTrolley == null
                            ? [const Text('Data is null')]
                            : widget.productTrolley!.map(
                                (product) {
                                  return trolleyProductTotal(
                                    colorTheme: colorTheme,
                                    product: product,
                                  );
                                },
                              ).toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Shipping Cost : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )),
                        Text(formatPrice(stateSelectorAll?.shippingCost ?? 0),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ))
                      ]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Discount : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${stateSelectorAll?.discount ?? 0}%",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500],
                                )),
                            Text("- ${formatPrice(stateSelectorAll?.discountPrice ?? 0)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colorTheme.error,
                                ))
                          ],
                        ),
                      ]),
                      const SizedBox(height: 15),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Total : ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )),
                        Text(formatPrice(stateSelectorAll?.total ?? 0),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ))
                      ])
                    ]);
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget trolleyProductCard({
    required ColorScheme colorTheme,
    required TrolleyModel product,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Card(
                child: Image.asset(
              'lib/images/banner1.png',
              height: 70,
              width: 70,
            )),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Type : ${product.type}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
                const SizedBox(height: 10),
                Text(
                  formatPrice(product.price),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: colorTheme.errorContainer,
                    fixedSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () => _removeData(product.idProduct),
                icon: Icon(
                  Icons.delete,
                  color: colorTheme.error,
                )),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Qty : ${product.trolleyQty}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget trolleyProductTotal({
    required ColorScheme colorTheme,
    required TrolleyModel product,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const SizedBox(width: 10),
          Text(
            "${product.trolleyQty} x ${truncate(product.name, 15)}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
          )
        ]),
        Text(
          formatPrice(product.price * product.trolleyQty),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Column listCheckout({
    required ColorScheme colorTheme,
    required String text,
    required String? title,
    required String? subtitle,
    required Function onClick,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorTheme.primary,
            )),
        // const SizedBox(height: 2),
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: IconButton(
              style: IconButton.styleFrom(
                  backgroundColor: colorTheme.primaryContainer,
                  fixedSize: const Size(50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              onPressed: () {},
              icon: Icon(icon, color: colorTheme.primary)),
          title: Text(title ?? 'Please Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              )),
          subtitle: Text(subtitle ?? 'Please Select',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              )),
          trailing: IconButton(
            onPressed: () => onClick(),
            icon: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}

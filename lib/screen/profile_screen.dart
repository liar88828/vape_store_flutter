import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/auth/auth_bloc.dart';
import 'package:vape_store/bloc/checkout/checkout_bloc.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/screen/checkout/detail_checkout_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/date.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/widgets/button_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _toDetailCheckout(CheckoutModel data, int id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailCheckoutScreen(checkout: data, idCheckout: id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;

    context.read<AuthBloc>().add(AuthInfoEvent());
    context.read<FavoriteBloc>().add(FavoriteCountByUserId());
    context.read<CheckoutBloc>().add(CheckoutLoadEvent());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BlocSelector<TrolleyBloc, TrolleyState, int>(
              selector: (stateTrolley) {
                return stateTrolley.count ?? 0;
              },
              builder: (context, stateTrolleyCount) {
                return IconButton(
                  color: colorTheme.primary,
                  style: IconButton.styleFrom(
                      backgroundColor: colorTheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  // color: Colors.red,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const TrolleyScreen();
                    }));
                  },
                  icon: Badge(label: Text(stateTrolleyCount.toString()), child: const Icon(Icons.trolley)),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ButtonNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, stateAuth) {
                      if (stateAuth is AuthLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (stateAuth is AuthErrorState) {
                        return Text(stateAuth.message);
                      } else if (stateAuth is AuthLoadedState) {
                        final user = stateAuth.user;
                        return Row(
                          children: [
                            Image.asset(
                              'lib/images/profile.png',
                              height: 110,
                              width: 110,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  formatDate(user.createdAt),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        return const Text('Something error');
                      }
                    },
                  ),
                  Row(
                    children: [
                      BlocSelector<FavoriteBloc, FavoriteState, int>(
                        selector: (stateFavorite) {
                          return stateFavorite.count ?? 0;
                        },
                        builder: (context, stateFavoriteCount) {
                          return CardStatus(
                            colorTheme: colorTheme,
                            title: 'Total Favorite',
                            count: stateFavoriteCount,
                          );
                        },
                      ),
                      CardStatus(
                        colorTheme: colorTheme,
                        title: 'Total Buy',
                        count: 20,
                      ),
                      // CardStatus(
                      //   colorTheme: colorTheme,
                      //   title: 'Total Buy',
                      //   count: 20,
                      // ),
                      // CardStatus(
                      //   colorTheme: colorTheme,
                      //   title: '',
                      //   count: 0,
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('View More'))
                ]),
                BlocBuilder<CheckoutBloc, CheckoutState>(builder: (context, stateCheckout) {
                  if (stateCheckout is CheckoutLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (stateCheckout is CheckoutErrorState) {
                    return const Center(child: Text('Data is Empty'));
                  } else if (stateCheckout is CheckoutLoadsState) {
                    return Column(
                        children: stateCheckout.checkouts.map((data) {
                      return listHistory(data);
                    }).toList());
                  } else {
                    return const Text('Something Error');
                  }
                })
              ],
            ),
          )
        ]),
      ),
    );
  }

  Card listHistory(CheckoutModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'lib/images/banner1.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID History : ${data.id}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Total ${formatPrice(data.total)}",
                      style: const TextStyle(),
                    ),
                    Text(formatDate(data.updatedAt!),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ))
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  _toDetailCheckout(data, data.id ?? 0);
                },
                icon: const Icon(Icons.arrow_forward))
          ],
        ),
      ),
    );
  }
}

class CardStatus extends StatelessWidget {
  const CardStatus({
    super.key,
    required this.colorTheme,
    required this.title,
    required this.count,
  });

  final ColorScheme colorTheme;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorTheme.primaryContainer,
      child: Container(
        // width: 85,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vape_store/models/checkout_model.dart';
import 'package:vape_store/models/user_model.dart';
import 'package:vape_store/network/checkout_network.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/screen/checkout/detail_checkout_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/date.dart';
import 'package:vape_store/utils/money.dart';
import 'package:vape_store/utils/pref_user.dart';
import 'package:vape_store/widgets/button_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FavoriteNetwork _favoriteNetwork = FavoriteNetwork();
  final CheckoutNetwork _checkoutNetwork = CheckoutNetwork();
  final TrolleyNetwork _trolleyNetwork = TrolleyNetwork();

  int? _favoriteCount;
  int? _trolleyCount;
  UserModel? _userData;
  Future<List<CheckoutModel>>? _checkoutData;

  Future<void> _refreshHandler() async {
    final session = await loadUserData();
    if (session != null) {
      _favoriteCount = await _favoriteNetwork.fetchFavoritesByUserIdCount(session.id);
      _trolleyCount = await _trolleyNetwork.fetchTrolleyCount(session.id);
      _checkoutData = _checkoutNetwork.fetchAll(session.id);
      setState(() {
        _userData = session;
        // _trolleyCount
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshHandler();
  }

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    // final List<ProductModel> products = productExample;

    if (_userData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        // backgroundColor: colorTheme.primaryContainer,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
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
                icon: Badge(
                    label: Text(
                      _trolleyCount != null ? _trolleyCount.toString() : '',
                    ),
                    child: const Icon(Icons.trolley)),
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
                    Row(
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
                              _userData?.name ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _userData?.email ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              _userData?.createdAt != null ? formatDate(_userData!.createdAt!) : '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        CardStatus(
                          colorTheme: colorTheme,
                          title: 'Total Favorite',
                          count: _favoriteCount ?? 0,
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
                  FutureBuilder<List<CheckoutModel>>(
                      future: _checkoutData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Data is Empty'));
                        } else {
                          return Column(
                            children: snapshot.data!.map((data) {
                              return HistoryList(data: data);
                            }).toList(),
                          );
                        }
                      })
                ],
              ),
            )
          ]),
        ),
      );
    }
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.data,
  });
  final CheckoutModel data;

  @override
  Widget build(BuildContext context) {
    // final String formattedDate = formatDate(date);
    final formattedPrice = formatPrice(data.total);

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
                      data.paymentMethod,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedPrice,
                      style: const TextStyle(),
                    ),
                    Text(data.deliveryMethod,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    // return DetailScreen(id: data.id);
                    return DetailCheckoutScreen();
                  }));
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

import 'package:flutter/material.dart';
import 'package:vape_store/bloc/auth/auth_bloc.dart';
import 'package:vape_store/bloc/bank/bank_bloc.dart';
import 'package:vape_store/bloc/checkout/checkout_bloc.dart';
import 'package:vape_store/bloc/counter/counter_bloc.dart';
import 'package:vape_store/bloc/delivery/delivery_bloc.dart';
import 'package:vape_store/bloc/favorite/favorite_bloc.dart';
import 'package:vape_store/bloc/preferences/preferences_bloc.dart';
import 'package:vape_store/bloc/product/product_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/network/bank_network.dart';
import 'package:vape_store/network/checkout_network.dart';
import 'package:vape_store/network/delivery_network.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/network/product_network.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/network/user_network.dart';
import 'package:vape_store/repository/preferences_repo.dart';
import 'package:vape_store/screen/auth/login_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
      userNetwork: UserNetwork(),
      trolleyNetwork: TrolleyNetwork(),
      preferencesRepository: PreferencesRepository(),
      productNetwork: ProductNetwork(),
      favoriteNetwork: FavoriteNetwork(),
      bankNetwork: BankNetwork(),
      deliveryNetwork: DeliveryNetwork(),
      checkoutNetwork: CheckoutNetwork()));
}

class MyApp extends StatelessWidget {
  final PreferencesRepository preferencesRepository;
  final UserNetwork userNetwork;
  final TrolleyNetwork trolleyNetwork;
  final ProductNetwork productNetwork;
  final FavoriteNetwork favoriteNetwork;
  final BankNetwork bankNetwork;
  final DeliveryNetwork deliveryNetwork;
  final CheckoutNetwork checkoutNetwork;
  // final UserModel userSession;
  const MyApp(
      {super.key,
      required this.preferencesRepository,
      required this.userNetwork,
      required this.trolleyNetwork,
      required this.productNetwork,
      required this.favoriteNetwork,
      required this.bankNetwork,
      required this.deliveryNetwork,
      required this.checkoutNetwork});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.pinkAccent);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DeliveryBloc(deliveryRepository: deliveryNetwork)),
        BlocProvider(
            create: (context) => CheckoutBloc(
                  checkoutRepository: checkoutNetwork,
                  session: preferencesRepository.getUser(),
                )),
        BlocProvider(create: (context) => BankBloc(bankRepository: bankNetwork)),
        BlocProvider(
            create: (context) => FavoriteBloc(
                  favoriteRepository: favoriteNetwork,
                  session: preferencesRepository.getUser(),
                )),
        BlocProvider(
            create: (context) => TrolleyBloc(
                  trolleyRepository: trolleyNetwork,
                  session: preferencesRepository.getUser(),
                )..add(TrolleyGetSessionEvent())),
        BlocProvider(
            create: (context) => ProductBloc(
                  productRepository: productNetwork,
                )),
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(
            create: (context) => PreferencesBloc(
                  preferencesRepository: preferencesRepository,
                )..add(LoadPreferencesEvent())),
        BlocProvider(
            create: (context) => AuthBloc(
                  authRepository: userNetwork,
                  preferencesRepository: preferencesRepository,
                )..add(AuthInfoEvent())),
      ],
      child: BlocBuilder<PreferencesBloc, PreferencesState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(colorScheme: colorScheme, useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const ValidationSession(),
          );
        },
      ),
    );
  }
}

class ValidationSession extends StatelessWidget {
  const ValidationSession({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthLoadingState) return const Center(child: CircularProgressIndicator());
      if (state is AuthErrorState) return LoginScreen();
      if (state is AuthLoadedState) {
        return const HomeScreen();
      } else {
        return LoginScreen();
      }
    });
  }
}




  // Future<bool> _checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool('isLoggedIn') ?? false;
  // }

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.pinkAccent);
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Flutter Demo',
  //     // themeMode: ThemeData.light,
  //     // darkTheme: ThemeData.dark(),
  //     theme: ThemeData(
  //       colorScheme: colorScheme,
  //       iconButtonTheme: const IconButtonThemeData(
  //           style: ButtonStyle(
  //               // backgroundColor: WidgetStateProperty.all(colorScheme.primaryContainer),
  //               )),
  //       // Theme.of(context).colorScheme.inversePrimary
  //       useMaterial3: true,
  //     ),
  //     home: FutureBuilder(
  //       future: _checkLoginStatus(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasData && snapshot.data == true) {
  //           return const HomeScreen();
  //         } else {
  //           return const LoginScreen();
  //         }
  //       },
  //     ),
  //   );
  // }


 
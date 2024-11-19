import 'package:flutter/material.dart';
import 'package:vape_store/bloc/auth/auth_bloc.dart';
import 'package:vape_store/bloc/preferences/preferences_bloc.dart';
import 'package:vape_store/network/user_network.dart';
import 'package:vape_store/repository/preferences_repo.dart';
import 'package:vape_store/screen/auth/login_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesRepository();
  final userNetwork = UserNetwork();
  runApp(MyApp(
    userNetwork: userNetwork,
    preferencesRepository: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final PreferencesRepository preferencesRepository;
  final UserNetwork userNetwork;
  const MyApp({
    super.key,
    required this.preferencesRepository,
    required this.userNetwork,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.pinkAccent);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PreferencesBloc(preferencesRepository: preferencesRepository)..add(LoadPreferencesEvent())),
        BlocProvider(create: (context) => AuthBloc(authRepository: userNetwork, preferencesRepository: preferencesRepository)),
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
      context.read<AuthBloc>().add(AuthInfoEvent());
      if (state is AuthLoadingState) return const Center(child: CircularProgressIndicator());
      if (state is AuthErrorState) return const LoginScreen();
      if (state is AuthLoadedState) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
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


 
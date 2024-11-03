import 'package:flutter/material.dart';
import 'package:vape_store/screen/favorites_screen.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/profile_screen.dart';
import 'package:vape_store/screen/search_screen.dart';
import 'package:vape_store/screen/setting_screen.dart';

class ButtonNavigation extends StatelessWidget {
  const ButtonNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;
    var currentRoute = ModalRoute.of(context)?.settings.name;
    int getCurrentRoute() {
      switch (currentRoute) {
        case '/home':
          return 0;
        case '/favorite':
          return 1;
        case '/search':
          return 2;
        case '/profile':
          return 3;
        case '/setting':
          return 4;
        default:
          return 0;
      }
    }

    // print(ModalRoute.of(context)?.settings.name);
    return BottomNavigationBar(
        // backgroundColor: Colors.orangeAccent,
        unselectedItemColor: colorTheme.primary,
        fixedColor: colorTheme.inversePrimary,
        currentIndex: getCurrentRoute(),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                      settings: const RouteSettings(name: '/home')));
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                    settings: RouteSettings(name: '/favorite'),
                  ));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                      settings: RouteSettings(name: '/search')));
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                    settings: RouteSettings(name: '/profile'),
                  ));
              break;
            case 4:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingScreen(),
                    settings: RouteSettings(name: '/setting'),
                  ));
              break;
            default:
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              // backgroundColor: Colors.amberAccent,
              icon: Icon(Icons.favorite),
              label: 'Favorite'),
          BottomNavigationBarItem(
              // backgroundColor: Colors.redAccent,

              icon: Icon(Icons.search),
              label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ]);
  }
}

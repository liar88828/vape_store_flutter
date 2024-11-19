// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vape_store/screen/setting/theme_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // var colorTheme = Theme.of(context).colorScheme;
    final List<Map<String, dynamic>> personalSettingsOptions = [
      {'title': 'Personal', 'icon': Icons.person, 'onTap': () => print('Personal tapped')},
      {'title': 'Change Password', 'icon': Icons.lock, 'onTap': () => print('Change Password tapped')},
    ];

// List for app settings
    final List<Map<String, dynamic>> appSettingsOptions = [
      {'title': 'Notifications', 'icon': Icons.notifications, 'onTap': () => print('Notifications tapped')},
      {'title': 'Privacy Policy', 'icon': Icons.privacy_tip, 'onTap': () => print('Privacy Policy tapped')},
      {'title': 'Terms of Service', 'icon': Icons.description, 'onTap': () => print('Terms of Service tapped')},
      {'title': 'Help', 'icon': Icons.help_outline, 'onTap': () => print('Help tapped')},
      {'title': 'Language', 'icon': Icons.language, 'onTap': () => print('Language tapped')},
      {
        'title': 'Theme',
        'icon': Icons.color_lens,
        'onTap': () => Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ThemeScreen();
              },
            ))
      },
      {'title': 'About', 'icon': Icons.info, 'onTap': () => print('About tapped')},
      {'title': 'Exit', 'icon': Icons.exit_to_app, 'onTap': () => print('Exit tapped')},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SettingList('Personal Information', personalSettingsOptions),
              const SizedBox(height: 20),
              // Divider(),
              SettingList('App Information', appSettingsOptions),
            ],
          ),
        ),
      ),
    );
  }

  Column SettingList(String title, List<Map<String, dynamic>> appSettingsOptions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
            children: appSettingsOptions.map((option) {
          return ListTile(
            leading: Icon(option['icon']),
            title: Text(option['title']),
            onTap: () => option['onTap'](),
            trailing: const Icon(Icons.chevron_right),
          );
        }).toList())
      ],
    );
  }
}

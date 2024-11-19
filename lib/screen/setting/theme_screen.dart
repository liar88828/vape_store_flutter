import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vape_store/bloc/preferences/preferences_bloc.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Theme'),
        ),
        body: BlocBuilder<PreferencesBloc, PreferencesState>(builder: (context, state) {
          return Column(children: [
            ElevatedButton(
              onPressed: () async {
                context.read<PreferencesBloc>().add(SetLightThemeEvent());
              },
              child: const Text('Set Light Theme'),
            ),
            ElevatedButton(
              onPressed: () async {
                context.read<PreferencesBloc>().add(GetThemeEvent());
              },
              child: const Text('Set Dark Theme'),
            ),
            Text('Current Theme is ${state.isDarkMode ? 'Dark' : 'Light'}'),
          ]);
        }));
  }
}

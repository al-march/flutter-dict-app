import 'package:flutter/material.dart';
import 'package:mobile/main.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();
    var appTheme = state.appTheme;

    return Center(
      child: Column(
        children: [
          ListTile(
            title: const Text('Light theme'),
            leading: Radio<AppTheme>(
              value: AppTheme.light,
              groupValue: appTheme,
              onChanged: (AppTheme? value) {
                if (value != null) {
                  state.toggleTheme(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Dark theme'),
            leading: Radio<AppTheme>(
              value: AppTheme.dark,
              groupValue: appTheme,
              onChanged: (AppTheme? value) {
                if (value != null) {
                  state.toggleTheme(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

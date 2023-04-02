import 'package:flutter/material.dart';
import 'package:mobile/pages/all_words_page.dart';
import 'package:mobile/pages/settings_page.dart';
import 'package:mobile/pages/start_page.dart';
import 'package:provider/provider.dart';

enum AppTheme { dark, light }

main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return app(context);
  }

  Widget app(BuildContext context) => MaterialApp(
        theme: theme(context),
        home: const Layout(),
      );

  ThemeData theme(BuildContext context) {
    var state = context.watch<AppState>();

    return state.appTheme == AppTheme.dark
        ? ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark().copyWith(
              background: const Color.fromARGB(255, 25, 25, 25),
              primary: Colors.teal,
              surface: const Color.fromARGB(255, 40, 40, 40),
            ),
          )
        : ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light().copyWith(
              primary: Colors.teal,
            ),
          );
  }
}

class AppState extends ChangeNotifier {
  AppTheme appTheme = AppTheme.dark;
  int pageIndex = 0;

  changePage(int index) {
    pageIndex = index;
    notifyListeners();
  }

  toggleTheme(AppTheme theme) {
    appTheme = theme;
    notifyListeners();
  }
}

class Layout extends StatelessWidget {
  const Layout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary'),
      ),
      body: const Pages(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.pageIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onBackground,
        onTap: (index) => state.changePage(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Words',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class Pages extends StatelessWidget {
  const Pages({
    super.key,
  });

  static const List<Widget> pages = [
    StartPage(),
    Text(
      'Index 1: Games',
      style: TextStyle(fontSize: 30),
    ),
    AllWordsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    var state = context.watch<AppState>();
    var index = state.pageIndex;

    return Center(
      child: pages[index],
    );
  }
}

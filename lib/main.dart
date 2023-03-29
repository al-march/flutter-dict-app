import 'package:flutter/material.dart';
import 'package:mobile/pages/all_words_page.dart';
import 'package:provider/provider.dart';

main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: const ColorScheme.dark().copyWith(
            background: const Color.fromARGB(255, 25, 25, 25),
            primary: Colors.teal,
            surface: const Color.fromARGB(255, 40, 40, 40),
          ),
        ),
        home: const Layout(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  int pageIndex = 0;

  changePage(int index) {
    pageIndex = index;
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
    Text(
      'Index 0: Home',
      style: TextStyle(fontSize: 30),
    ),
    Text(
      'Index 1: Games',
      style: TextStyle(fontSize: 30),
    ),
    AllWordsPage(),
    Text(
      'Index 3: Settings',
      style: TextStyle(fontSize: 30),
    ),
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

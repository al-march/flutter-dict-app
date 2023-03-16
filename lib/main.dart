import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        home: const Text("Hello world"),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
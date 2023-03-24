import 'package:flutter/material.dart';
import 'package:mobile/dto/word.dto.dart';
import 'package:mobile/init_db.dart';
import 'package:provider/provider.dart';

main() async {
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
        home: const StartPage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Word> words = [];
  Map<String, List<Word>> wordMap = {'a': [], 'b': [], 'c': []};

  @override
  void initState() {
    super.initState();
    getWords();
  }

  getWords() async {
    var dictDB = DictDB();
    await dictDB.init();

    var a = await dictDB.getWords('a');
    var b = await dictDB.getWords('b');
    var c = await dictDB.getWords('c');

    setState(() {
      wordMap['a'] = a;
      wordMap['b'] = b;
      wordMap['c'] = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(
                icon: Text('a'),
              ),
              Tab(
                icon: Text('b'),
              ),
              Tab(
                icon: Text('c'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ListView.builder(
                  itemCount: wordMap['a']!.length,
                  itemBuilder: (context, index) {
                    return WordCard(word: wordMap['a']![index]);
                  }),
            ),
            Center(
              child: ListView.builder(
                  itemCount: wordMap['b']!.length,
                  itemBuilder: (context, index) {
                    return WordCard(word: wordMap['b']![index]);
                  }),
            ),
            Center(
              child: ListView.builder(
                  itemCount: wordMap['c']!.length,
                  itemBuilder: (context, index) {
                    return WordCard(word: wordMap['c']![index]);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.word,
  });

  final Word word;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  word.name,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  '${word.difficult} ${word.type}',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(flex: 1),
                IconButton(onPressed: () {}, icon: const Icon(Icons.info))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

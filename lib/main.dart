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
  List<String> difficults = [
    'a',
    'b',
    'c',
  ];

  Map<String, List<Word>> wordMap = {
    'a': [],
    'b': [],
    'c': [],
  };

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
      length: difficults.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
              tabs: difficults
                  .map((tab) => Tab(
                        icon: Text(tab.toUpperCase()),
                      ))
                  .toList()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: difficults.map((difficult) {
              final d = wordMap[difficult]!;
              var proto = d.isNotEmpty ? WordCard(word: d.first) : null;

              return ListView.builder(
                itemCount: d.length,
                prototypeItem: proto,
                itemBuilder: (context, index) => WordCard(word: d[index]),
              );
            }).toList(),
          ),
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
        child: ListTile(
          title: Row(children: [
            Text(
              word.name,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(
              width: 8.0,
            ),
            const Spacer(flex: 1),
            IconButton(onPressed: () {}, icon: const Icon(Icons.info))
          ]),
          subtitle: Text(
            '${word.type} ${word.difficult}',
          ),
        ),
      ),
    );
  }
}

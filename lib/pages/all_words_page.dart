import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../components/word/word_mini_card.dart';
import '../dto/word.dto.dart';
import '../init_db.dart';

var definition = const Definition(
    transcription: '/ˈkæfeɪ/',
    meaning:
        'a place where you can buy drinks and simple meals. Alcohol is not usually served in British or American cafes',
    examples: [
      'There are small shops and pavement cafes around every corner.',
      'an outdoor cafe serving drinks and light meals',
      'They were having lunch at a cafe near the station',
      'We stopped for a coffee in our favourite cafe',
    ]);

class AllWordsPage extends StatefulWidget {
  const AllWordsPage({super.key});

  @override
  State<AllWordsPage> createState() => _AllWordsPageState();
}

class _AllWordsPageState extends State<AllWordsPage> {
  final player = AudioPlayer();
  List<String> difficults = [
    'all',
    'a1',
    'a2',
    'b1',
    'b2',
    'c1',
  ];

  Map<String, List<Word>> wordMap = {
    'all': [],
    'a1': [],
    'a2': [],
    'b1': [],
    'b2': [],
    'c1': [],
  };

  @override
  void initState() {
    super.initState();
    getWords();
  }

  getWords() async {
    var dictDB = DictDB();
    await dictDB.init();

    var all = await dictDB.getAllWords();
    var a1 = await dictDB.getWords('a1');
    var a2 = await dictDB.getWords('a2');
    var b1 = await dictDB.getWords('b1');
    var b2 = await dictDB.getWords('b2');
    var c1 = await dictDB.getWords('c1');

    setState(() {
      wordMap['all'] = all;
      wordMap['a1'] = a1;
      wordMap['a2'] = a2;
      wordMap['b1'] = b1;
      wordMap['b2'] = b2;
      wordMap['c1'] = c1;
    });
  }

  play(Word word) {
    var url = 'https://www.oxfordlearnersdictionaries.com/${word.audio}';
    player.play(UrlSource(url));
  }

  showWordDefinition(Word word) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);

        return FractionallySizedBox(
          heightFactor: 0.4,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(word.difficult),
                          const SizedBox(width: 6),
                          Text(
                            definition.transcription,
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(definition.meaning),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),
              ElevatedButton(
                child: const Text('Close BottomSheet'),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: difficults.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
              tabs: difficults
                  .map(
                    (tab) => Tab(
                      icon: Text(tab.toUpperCase()),
                    ),
                  )
                  .toList()),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBarView(
                  children: difficults.map((difficult) {
                    final d = wordMap[difficult]!;
                    var proto =
                        d.isNotEmpty ? WordMiniCard(word: d.first) : null;

                    return ListView.builder(
                      itemCount: d.length,
                      prototypeItem: proto,
                      itemBuilder: (context, index) => WordMiniCard(
                        word: d[index],
                        onPlay: () => play(d[index]),
                        onShowDefinition: () => showWordDefinition(d[index]),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

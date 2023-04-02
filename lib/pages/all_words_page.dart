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
  ],
);

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
      context: context,
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: Border.all(width: 0, color: Colors.transparent),
      builder: (BuildContext context) => WordBottomSheet(
        word: word,
        onPlay: () => play(word),
      ),
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

class WordBottomSheet extends StatelessWidget {
  const WordBottomSheet({
    super.key,
    required this.word,
    required this.onPlay,
  });

  final Word word;
  final Function onPlay;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return makeDismissible(
      context: context,
      child: DraggableScrollableSheet(
        maxChildSize: 0.9,
        minChildSize: 0.3,
        initialChildSize: 0.7,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onBackground.withOpacity(0.8),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              ListView(
                controller: controller,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => onPlay(),
                        icon: const Icon(Icons.play_arrow),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        word.name,
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        definition.transcription,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Text(word.difficult),
                    ],
                  ),
                  Divider(
                    color: theme.colorScheme.onBackground.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(definition.meaning),
                  const SizedBox(height: 20),
                  Text(
                    'Примеры:',
                    style: theme.textTheme.bodyLarge,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: definition.examples
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: 6,
                                top: 6,
                              ),
                              child: Text('- $e'),
                            ))
                        .toList(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeDismissible({
    required Widget child,
    required BuildContext context,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(child: child),
    );
  }
}
